import 'package:flutter/cupertino.dart';

class PasswordVisibilityNotifier extends ChangeNotifier {
  bool isVisible = false;
  updateVisibility() {
    isVisible = isVisible ? false : true;
    notifyListeners();
  }
}
