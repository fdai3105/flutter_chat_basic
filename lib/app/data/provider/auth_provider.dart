import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  final FirebaseFirestore store = FirebaseFirestore.instance;
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
    final _tokens = await UserProvider().getListDeviceToken(FirebaseAuth.instance.currentUser!.uid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _currentToken = prefs.getString('device_token');
    if(_tokens.isNotEmpty){
      _tokens.removeWhere((userToken) => userToken == _currentToken);
      store.collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'deviceToken': _tokens.toSet().toList()
      });
    }
  }

  Future<void> logout() async {
    await removeDeviceToken();
    ggs.disconnect();
    ggs.signOut();
    fba.signOut();
  }
}
