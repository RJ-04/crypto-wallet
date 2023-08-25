import 'package:crypto_wallet/net/flutter_fire.dart';
import 'package:crypto_wallet/ui/home_view.dart';
import 'package:crypto_wallet/ui/verify_email.dart';
import 'package:crypto_wallet/utils/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hght = MediaQuery.of(context).size.height;
    var wdth = MediaQuery.of(context).size.width;

    PreferredSize appBar = PreferredSize(
      preferredSize: Size.fromHeight(hght * 0.06),
      child: AppBar(backgroundColor: Colors.amber),
    );

    return Scaffold(
      appBar: appBar,
      body: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            return Padding(
              padding: EdgeInsets.only(
                right: hght > wdth ? hght * 0.05 : 0,
                left: hght > wdth ? hght * 0.05 : 0,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        height: hght > wdth ? wdth * 0.5 : hght * 0.3,
                      ),
                    ),
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 285, maxWidth: 315),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        autocorrect: true,
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          fillColor: const Color.fromARGB(255, 226, 216, 216),
                          filled: true,
                          hintText: "janedoe1908@gmail.com",
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    const Divider(),
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 285, maxWidth: 315),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 226, 216, 216),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          hintText: "#janedoe_12;",
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        height: hght / 50,
                      ),
                    ),
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 285, maxWidth: 315),
                      height: 40,
                      child: MaterialButton(
                        shape: const StadiumBorder(),
                        splashColor: const Color.fromARGB(255, 51, 255, 0),
                        hoverColor: const Color.fromARGB(206, 230, 226, 226),
                        onPressed: () async {
                          String registered = "unknown";

                          kIsWeb
                              ? showCupertinoDialog(
                                  useRootNavigator: true,
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: appBar.preferredSize.height * 1.1,
                                        bottom: hght -
                                            appBar.preferredSize.height * 1.2,
                                      ),
                                      child: const LinearProgressIndicator(
                                        color: Color.fromARGB(255, 0, 225, 255),
                                        backgroundColor: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : showCupertinoDialog(
                                  useRootNavigator: true,
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: appBar.preferredSize.height * 1.7,
                                        bottom: hght -
                                            appBar.preferredSize.height * 1.8,
                                      ),
                                      child: const LinearProgressIndicator(
                                        color: Color.fromARGB(255, 0, 225, 255),
                                        backgroundColor: Colors.grey,
                                      ),
                                    );
                                  },
                                );

                          registered = await signUp(
                            _emailController.text,
                            _passwordController.text,
                          );

                          if (registered == "true") {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EmailVerification(),
                              ),
                            );
                            // ignore: use_build_context_synchronously
                            showSnackBar(context,
                                "registered & verification email sent");
                          } else if (registered != "unknown") {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, registered);
                          }
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 0, 170)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        height: hght / 50,
                      ),
                    ),
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 285, maxWidth: 315),
                      height: 40,
                      child: MaterialButton(
                        shape: const StadiumBorder(),
                        splashColor: const Color.fromARGB(255, 51, 255, 0),
                        hoverColor: const Color.fromARGB(206, 230, 226, 226),
                        onPressed: () async {
                          String signedIn = "unknown";

                          kIsWeb
                              ? showCupertinoDialog(
                                  useRootNavigator: true,
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: appBar.preferredSize.height * 1.1,
                                        bottom: hght -
                                            appBar.preferredSize.height * 1.2,
                                      ),
                                      child: const LinearProgressIndicator(
                                        color: Color.fromARGB(255, 0, 225, 255),
                                        backgroundColor: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : showCupertinoDialog(
                                  useRootNavigator: true,
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: appBar.preferredSize.height * 1.7,
                                        bottom: hght -
                                            appBar.preferredSize.height * 1.8,
                                      ),
                                      child: const LinearProgressIndicator(
                                        color: Color.fromARGB(255, 0, 225, 255),
                                        backgroundColor: Colors.grey,
                                      ),
                                    );
                                  },
                                );

                          signedIn = await signIn(
                            _emailController.text,
                            _passwordController.text,
                          );

                          if (signedIn == "true") {
                            bool isVerified = FirebaseAuth
                                .instance.currentUser!.emailVerified;
                            if (!isVerified) {
                              await FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EmailVerification(),
                                ),
                              );

                              // ignore: use_build_context_synchronously
                              showSnackBar(context,
                                  "Email Unverified & verification email sent");
                            } else {
                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeView(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          } else if (signedIn != "unknown") {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, signedIn);
                          }
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 0, 170)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
