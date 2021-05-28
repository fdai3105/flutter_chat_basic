import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
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

  static void logout() {
    ggs.disconnect();
    ggs.signOut();
    fba.signOut();
  }
}
