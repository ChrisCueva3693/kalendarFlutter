import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  // ───────────── Google ─────────────
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await _google.signIn();
    if (gUser == null) throw Exception('Proceso cancelado');

    final GoogleSignInAuthentication gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  // ──────────── Facebook ────────────
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) {
      throw Exception(result.message);
    }
    final credential =
    FacebookAuthProvider.credential(result.accessToken!.token);
    return _auth.signInWithCredential(credential);
  }

  // ─────────── Email / Password ───────────
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // ────────────── Logout ──────────────
  Future<void> signOut() async {
    await _google.signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }
}
