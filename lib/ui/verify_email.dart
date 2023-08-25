import 'package:crypto_wallet/utils/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    var hght = MediaQuery.of(context).size.height;
    var wdth = MediaQuery.of(context).size.width;
    bool sent = false;

    PreferredSize appBar = PreferredSize(
      preferredSize: Size.fromHeight(hght * 0.06),
      child: AppBar(backgroundColor: Colors.amber),
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(minWidth: 285, maxWidth: 315),
          height: hght > wdth ? hght * 0.1 : wdth * 0.1,
          child: MaterialButton(
            shape: const StadiumBorder(side: BorderSide.none),
            elevation: 5,
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;

              await FirebaseAuth.instance.currentUser!.sendEmailVerification();

              setState(() {
                sent = true;
              });

              if (sent) {
                // ignore: use_build_context_synchronously
                showSnackBar(context, "email resent to ${user!.email}");
              }

              setState(() {
                sent = false;
              });
            },
            child: Text(
              "Get Email verification",
              textScaleFactor: hght > wdth ? hght * 0.002 : wdth * 0.002,
              softWrap: true,
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }
}
