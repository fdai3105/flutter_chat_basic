import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdteam_demo_chat/app/data/constant/constant.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';

class AuthProvider {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseAuth fba = FirebaseAuth.instance;
  static GoogleSignIn ggs = GoogleSignIn(
    scopes: ['email', "https://www.googleapis.com/auth/contacts.readonly"],
  );

  Future<User?> loginWithGoogle() async {
    final googleSignInAccount = await ggs.signIn();
    if (googleSignInAccount != null) {
      final googleSignInAuth = await googleSignInAccount.authentication;
      final authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuth.idToken,
        accessToken: googleSignInAuth.accessToken,
      );
      await fba.signInWithCredential(authCredential);
      return fba.currentUser;
    }
  }

  Future<void> removeDeviceToken() async {
    final tokens = await UserProvider()
        .getListDeviceToken(FirebaseAuth.instance.currentUser!.uid);
    await firebaseMessaging
        .getToken(vapidKey: FB_VAPID_KEY)
        .then((value) async {
      if (tokens.isNotEmpty) {
        tokens.removeWhere((userToken) => userToken == value);
        store
            .collection('user')
            .doc(UserProvider.getCurrentUser().uid)
            .update({'deviceToken': tokens});
      }
    });
  }

  Future<void> logout() async {
    await removeDeviceToken();
    ggs.disconnect();
    ggs.signOut();
    fba.signOut();
  }
}
