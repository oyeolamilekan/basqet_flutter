import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'basqet.dart';

class BasqetFlutter {
  static Future launchBasqet(
    BuildContext _, {

    /// Public Key from your https://dashboard.basqet.com/settings
    required String publicKey,

    /// amount
    required String amount,

    /// currency
    required String currency,

    /// description
    required String description,

    /// email
    required String email,

    /// Success callback
    required void Function(dynamic code) onSuccess,

    /// Success callback
    required void Function(dynamic code) onError,

    /// Triggered on Connect Widget close
    required Function onClose,
    bool showLogs = false,
    String? reference,
  }) async =>
      showModalBottomSheet(
        isScrollControlled: true,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .9,
              child: BasqetWebview(
                publicKey: publicKey,
                amount: amount,
                currency: currency,
                description: description,
                email: email,
                onSuccess: onSuccess,
                onError: onError,
                onClose: () {
                  onClose();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        context: _,
      );
}
