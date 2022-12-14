import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../files/basqet_html.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading.dart';

class BasqetWebview extends StatefulWidget {
  final String publicKey;
  final String amount;
  final String email;
  final String description;
  final String currency;
  final Function onClose;
  final Function onAbandoned;
  final Function(dynamic payload) onError;
  final Function(dynamic payload) onSuccess;

  const BasqetWebview({
    Key? key,
    required this.publicKey,
    required this.amount,
    required this.email,
    required this.description,
    required this.currency,
    required this.onClose,
    required this.onError,
    required this.onSuccess,
    required this.onAbandoned,
  }) : super(key: key);

  @override
  _BasqetWebviewState createState() => _BasqetWebviewState();
}

class _BasqetWebviewState extends State<BasqetWebview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isLoading = true;
  bool _isError = false;

  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers =
      {Factory(() => EagerGestureRecognizer())}.toSet();

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: WebView(
            initialUrl: Uri.dataFromString(
              buildBasqetHtml(
                widget.publicKey,
                widget.amount,
                widget.email,
                widget.description,
                widget.currency,
              ),
              mimeType: "text/html",
            ).toString(),
            javascriptChannels: _basqetJavascriptChannel,
            gestureRecognizers: gestureRecognizers,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (String url) {
              _isLoading = false;
              setState(() {});
            },
            onWebResourceError: (onWebResourceError) {
              _isLoading = false;
              _isError = true;
              setState(() {});
            },
            gestureNavigationEnabled: true,
            navigationDelegate: _handleNavigationInterceptor,
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: const Positioned(
            child: BASQETLoader(),
          ),
        ),
        Visibility(
          visible: _isError,
          child: Positioned(
            child: BASQETErrorWidget(
              title: "Couldn't load up checkout.",
              reload: () async {
                _isLoading = true;
                _isError = false;
                setState(() {});
                await _controller.future.then((value) => value.reload());
              },
            ),
          ),
        ),
      ],
    );
  }

  Set<JavascriptChannel> get _basqetJavascriptChannel => {
        JavascriptChannel(
          name: 'BasqetClientInterface',
          onMessageReceived: (data) {
            handleResponse(data.message);
          },
        )
      };

  void handleResponse(String body) async {
    try {
      final Map<String, dynamic> bodyMap = json.decode(body);
      final String event = bodyMap['event'];
      switch (event) {
        case "checkout.closed":
          widget.onClose();
          break;
        case "checkout.success":
          widget.onSuccess(
            bodyMap['transaction_reference'],
          );
          break;
        case "checkout.error":
          widget.onError(
            bodyMap['data'],
          );
          break;
        case "checkout.abandoned":
          widget.onAbandoned();
          break;
        default:
      }
    } catch (e) {
      widget.onError({"error": "something really bad happened."});
    }
  }

  NavigationDecision _handleNavigationInterceptor(NavigationRequest request) {
    if (request.url.toLowerCase().contains('basqet')) {
      // Navigate to all urls contianing basqet
      return NavigationDecision.navigate;
    } else {
      // Block all navigations outside basqet
      return NavigationDecision.prevent;
    }
  }
}
