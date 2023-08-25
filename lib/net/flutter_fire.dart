import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* log in  */

Future<String> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return "true";
  } on FirebaseAuthException catch (e) {
    if (password.isEmpty) {
      return "password cannot be empty";
    } else if (email.isEmpty) {
      return "email cannot be empty";
    } else if (e.message ==
            'An unknown error occurred: FirebaseError: Firebase: There is no user record corresponding to this identifier. The user may have been deleted. (auth/user-not-found).' ||
        e.message ==
            'An unknown error occurred: FirebaseError: Firebase: The password is invalid or the user does not have a password. (auth/wrong-password).' ||
        e.message ==
            'The password is invalid or the user does not have a password.') {
      return "incorrect credentials";
    } else if (e.message ==
        'An unknown error occurred: FirebaseError: Firebase: The email address is badly formatted. (auth/invalid-email).') {
      return "invalid email address";
    } else {
      return e.toString();
    }
  } catch (e) {
    return e.toString();
  }
}

/* register  */

Future<String> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseAuth.instance.currentUser!.sendEmailVerification();

    return "true";
  } on FirebaseAuthException catch (e) {
    if (password.isEmpty) {
      return "password cannot be empty";
    } else if (email.isEmpty) {
      return "email cannot be empty";
    } else if (e.code == 'email-already-in-use') {
      return "email already in use";
    } else {
      return e.toString();
    }
  } catch (e) {
    return e.toString();
  }
}

/* add coin  */

Future<String> addCoin(String id, String amount) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var value = double.parse(amount);

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('coins')
        .doc(id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        documentReference.set({'amount': value});
      } else {
        double newAmount = snapshot.get('amount') + value;
        transaction.update(documentReference, {'amount': newAmount});
      }
    });
    return "true";
  } catch (e) {
    return e.toString();
  }
}

/* delete  */

Future<String> removeCoin(String id) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('coins')
        .doc(id)
        .delete();

    return "true";
  } catch (e) {
    return e.toString();
  }
}
