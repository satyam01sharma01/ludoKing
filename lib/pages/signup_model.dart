import 'package:flutter/material.dart';

class SignupModel {
  // State field(s) for Username widget.
  FocusNode? usernameFocusNode1;
  TextEditingController? usernameTextController1;
  String? Function(BuildContext, String?)? usernameTextController1Validator;
  // State field(s) for Username widget.
  FocusNode? usernameFocusNode2;
  TextEditingController? usernameTextController2;
  String? Function(BuildContext, String?)? usernameTextController2Validator;
  // State field(s) for Password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  void initState() {}

  void dispose() {
    usernameFocusNode1?.dispose();
    usernameTextController1?.dispose();
    usernameFocusNode2?.dispose();
    usernameTextController2?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
