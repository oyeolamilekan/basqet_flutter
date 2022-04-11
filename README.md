# Flutter Basqet

This package makes it easy to use the Basqet in your flutter project.

## 📸 Screen Shots

<p float="left">
<img src="https://github.com/oyeolamilekan/basqet_flutter/blob/master/001_screen_shot.png?raw=true" width="200">
<img src="https://github.com/oyeolamilekan/basqet_flutter/blob/master/002_screen_shot.png?raw=true" width="200">
<img src="https://github.com/oyeolamilekan/basqet_flutter/blob/master/003_screen_shot.png?raw=true" width="200">
</p>

### How to Use plugin

```dart
import 'package:flutter_basqet/flutter_basqet.dart';

BasqetFlutter.launchBasqet(
   context,
   publicKey: '<public_test_key|public_prod_key>',
   email: 'example@gmail.com',
   description: 'urgent 2k in crypto',
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

```

The Transaction JSON returned for successful events

```ts
  bq_<reference_code>
```
