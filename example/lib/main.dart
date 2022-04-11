import 'package:flutter/material.dart';
import 'package:flutter_basqet/flutter_basqet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const TestBasqet(),
    );
  }
}

class TestBasqet extends StatelessWidget {
  const TestBasqet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                BasqetFlutter.launchBasqet(
                  context,
                  publicKey: '<public_key>',
                  email: 'olalekan@gmail.com',
                  description: 'welcome to a special type of check out.',
                  currency: "ngn",
                  amount: "2000",
                  onClose: () {
                    print("modal closed");
                  },
                  onSuccess: (code) {
                    print(code);
                    Navigator.of(context).pop();
                  },
                  onError: (error) {
                    print(error);
                    print("on error");
                  },
                );
              },
              child: const Text("Pay wih basqet"),
            )
          ],
        ),
      ),
    );
  }
}
