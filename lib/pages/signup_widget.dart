import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  static String routeName = 'signup';
  static String routePath = '/signup';

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController usernameTextController1 = TextEditingController();
  final FocusNode usernameFocusNode1 = FocusNode();
  final TextEditingController usernameTextController2 = TextEditingController();
  final FocusNode usernameFocusNode2 = FocusNode();
  final TextEditingController passwordTextController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    usernameTextController1.dispose();
    usernameFocusNode1.dispose();
    usernameTextController2.dispose();
    usernameFocusNode2.dispose();
    passwordTextController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0, -0.62),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  // child: Image.network(
                  //   'https://t4.ftcdn.net/jpg/03/57/17/95/240_F_357179504_ZIAKTrItertNc6rdp4wEttYaC7xiCDzb.jpg',
                  //   width: double.infinity,
                  //   height: double.infinity,
                  //   fit: BoxFit.fill,
                  // ),
                  child: Image.asset(
                    'assets/images/background.jpg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(
                                        -0.04,
                                        -0.24,
                                      ),
                                      child: Text(
                                        'Dhoom Sign up',
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: AlignmentDirectional(
                                            0.06,
                                            -0.15,
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  10,
                                                  20,
                                                  10,
                                                  20,
                                                ),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {},
                                              child: Text(
                                                'Step into the Arena. Outsmart Rivals. Defy the Dice. Rule the Board.\nThis isn’t just Ludo — this is your throne. Be the King of Ludo!',
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontSize: 10,
                                                      color: theme
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Username / Email
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      opacity: 0.8,
                                      child: Align(
                                        alignment: AlignmentDirectional(
                                          -0.02,
                                          -0.05,
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                20,
                                                0,
                                                20,
                                              ),
                                          child: Container(
                                            width: 300,
                                            child: TextFormField(
                                              controller:
                                                  usernameTextController1,
                                              focusNode: usernameFocusNode1,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Username / E-mail',
                                                hintText: 'Username / E-mail',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    theme.colorScheme.surface,
                                              ),
                                              style: theme.textTheme.bodyLarge,
                                              cursorColor:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Password
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      opacity: 0.8,
                                      child: Align(
                                        alignment: AlignmentDirectional(
                                          -0.02,
                                          -0.05,
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                20,
                                                0,
                                                20,
                                              ),
                                          child: Container(
                                            width: 300,
                                            child: TextFormField(
                                              controller:
                                                  usernameTextController2,
                                              focusNode: usernameFocusNode2,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Password',
                                                hintText: 'Password',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    theme.colorScheme.surface,
                                              ),
                                              style: theme.textTheme.bodyLarge,
                                              cursorColor:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Confirm Password
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      opacity: 0.8,
                                      child: Align(
                                        alignment: AlignmentDirectional(
                                          -0.02,
                                          -0.05,
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                20,
                                                0,
                                                20,
                                              ),
                                          child: Container(
                                            width: 300,
                                            child: TextFormField(
                                              controller:
                                                  passwordTextController,
                                              focusNode: passwordFocusNode,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Confirm Password',
                                                hintText: 'Confirm Password',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    theme.colorScheme.surface,
                                              ),
                                              style: theme.textTheme.bodyLarge,
                                              cursorColor:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Sign Up Button
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(
                                        -0.02,
                                        0.3,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          20,
                                          0,
                                          20,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              SignupWidget.routeName,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(150, 44.5),
                                            backgroundColor:
                                                theme.colorScheme.onBackground,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            'Sign UP',
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Or Sign Up using
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    9,
                                    0,
                                    9,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Or Sign Up using ',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Google Account Button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    10,
                                    0,
                                    10,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            // Google sign up logic
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.google,
                                            size: 15,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                          label: Text(
                                            'Google Account',
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: Size(250, 40),
                                            side: BorderSide(
                                              color: theme
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            backgroundColor:
                                                theme.colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Facebook Account Button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    10,
                                    0,
                                    10,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            // Facebook sign up logic
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.facebookF,
                                            size: 15,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                          label: Text(
                                            'FaceBook Account',
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: Size(250, 40),
                                            side: BorderSide(
                                              color: theme
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            backgroundColor:
                                                theme.colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
