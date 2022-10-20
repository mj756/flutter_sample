import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_sample/Utils/Utility.dart';
import 'package:flutter_sample/controller/api_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginController with ChangeNotifier {
  late FirebaseAuth firebaseAuth;
  // PublicClientApplication? pca;
  Future<String> googleLogin(BuildContext context) async {
    String status = '';
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        User? googleUser = userCredential.user;
        if (googleUser != null) {
          return await socialLoginApiCall(
              context, googleUser, PreferenceController.loginTypeGoogle);
        }
      }
    } catch (e) {
      status = e.toString();
    }
    return status;
  }

/*
  Future<void> appleLogin(BuildContext context) async{
    // 1. perform the sign-in request

    try {
      final result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      // 2. check the result
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken:
            String.fromCharCodes(appleIdCredential.authorizationCode!),
          );

          final userCredential =
          await firebaseAuth.signInWithCredential(credential);

          final firebaseUser = userCredential.user!;
          final scope = [Scope.email, Scope.fullName];
          if (scope.contains(Scope.fullName)) {
            final fullName = appleIdCredential.fullName;
            if (fullName != null &&
                fullName.givenName != null &&
                fullName.familyName != null) {
              final displayName =
                  '${fullName.givenName} ${fullName.familyName}';
              await firebaseUser.updateDisplayName(displayName);
            }
          }
          if(firebaseUser!=null)
          {
            AppUser user= AppUser.fromGoogleJson(json.decode(json.encode(firebaseUser)));
            PreferenceController.setString(PreferenceController.prefKeyUserPayload,json.encode(user));
            PreferenceController.setBoolean(PreferenceController.prefKeyIsLoggedIn,true);
            PreferenceController.setString(PreferenceController.prefKeyLoginType,PreferenceController.loginTypeApple);
          }
          break;
        case AuthorizationStatus.error:
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );
        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
        default:
          throw UnimplementedError();
      }
    } catch (e) {

    }
  }

  */

  Future<String> facebookLogin(BuildContext context) async {
    String status = '';
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);
      // Create a credential from the access token
      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return await socialLoginApiCall(
            context, firebaseUser, PreferenceController.loginTypeFaceBook);
      }
    } on FirebaseAuthException catch (e) {
      status = e.toString();
      Utility.showSnackBar(context, status);
      if (e.code == 'account-exists-with-different-credential') {
      } else if (e.code == 'invalid-credential') {}
    } catch (e) {
      status = e.toString();
    }
    return status;
  }

  Future<bool> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {}
    return false;
  }
/*
  Future<String> microsoftLogin({bool isSilent=false}) async
  {
    try {
      if(pca==null)
      {

        await PublicClientApplication.createPublicClientApplication(
          '485ebd43-1224-4bd8-b6bd-c352d96686ff',
          authority: 'https://login.microsoftonline.com/common',
          androidRedirectUri: 'msauth://com.flutter.sample/2jmj7l5rSw0yVb%2FvlWAYkK%2FYBwk%3D',
          );
      }
      return '';
    } catch (e) {

    }
    return '';
  }

*/

  Future<String> socialLoginApiCall(
      BuildContext context, User socialUser, String loginType) async {
    String status = '';
    await ApiController.post(
        AppConstants.endpointSocialLogin,
        json.encode({
          'email': socialUser.email,
          'name': socialUser.displayName,
          'profileImage': socialUser.photoURL ?? '',
          'fcmToken':
              PreferenceController.getString(PreferenceController.fcmToken)
        })).then((response) async {
      if (response.status == 0) {
        AppUser user =
            AppUser.fromJson(json.decode(json.encode(response.data)));
        PreferenceController.setString(
            PreferenceController.prefKeyUserPayload, json.encode(user));
        PreferenceController.setBoolean(
            PreferenceController.prefKeyIsLoggedIn, true);
        PreferenceController.setString(
            PreferenceController.prefKeyUserId, user.id);
        PreferenceController.setString(
            PreferenceController.prefKeyLoginType, loginType);
        PreferenceController.setString(
            PreferenceController.apiToken, user.token);
        return status;
      } else {
        await logOut();
        status = response.message;
      }
    });
    return status;
  }
}
