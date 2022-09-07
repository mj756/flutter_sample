import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:msal_flutter/msal_flutter.dart';
import '../preference_controller.dart';
class SocialLoginController with ChangeNotifier{
  late FirebaseAuth firebaseAuth;
  PublicClientApplication? pca;
  Future<void> googleLogin(BuildContext context) async{

    try
    {
      FirebaseAuth auth=FirebaseAuth.instance;
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
        if(googleUser!=null)
        {
          print('google login successful');


          AppUser user= AppUser.fromGoogleJson(json.decode(json.encode(googleUser)));
          PreferenceController.setString(PreferenceController.prefKeyUserPayload,json.encode(user));
          PreferenceController.setBoolean(PreferenceController.prefKeyIsLoggedIn,true);
          PreferenceController.setString(PreferenceController.prefKeyLoginType,PreferenceController.loginTypeGoogle);



        }
      }
    }catch(e)
    {
      if(kDebugMode)
      {
        print(e.toString());
      }
    }
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
      if(kDebugMode)
      {
        print(e.toString());
      }
    }
  }
  Future<void> facebookLogin(BuildContext context) async{
    try
    {
      final LoginResult result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final facebookAuthCredential =
      FacebookAuthProvider.credential(result.accessToken!.token);

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      User? firebaseUser = userCredential.user;
      if(firebaseUser!=null)
      {
        AppUser user= AppUser.fromGoogleJson(json.decode(json.encode(firebaseUser)));
        PreferenceController.setString(PreferenceController.prefKeyUserPayload,json.encode(user));
        PreferenceController.setBoolean(PreferenceController.prefKeyIsLoggedIn,true);
        PreferenceController.setString(PreferenceController.prefKeyLoginType,PreferenceController.loginTypeFaceBook);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {

      } else if (e.code == 'invalid-credential') {

      }
    }catch(e)
    {
      if(kDebugMode)
      {
        print(e.toString());
      }
    }
    return null;
  }
  Future<bool> logOut() async
  {
    try
    {
      String loginType= PreferenceController.getString(PreferenceController.prefKeyLoginType);
      switch(loginType)
      {
        case PreferenceController.loginTypeGoogle:
          await firebaseAuth.signOut();
          break;
        case PreferenceController.loginTypeMicrosoft:

          break;
        case PreferenceController.loginTypeFaceBook:
          await firebaseAuth.signOut();
          break;
        case PreferenceController.loginTypeApple:
          await firebaseAuth.signOut();
          break;
      }
       PreferenceController.clearLoginCredential();
      return true;
    }catch(e)
    {
      if(kDebugMode)
      {
        print(e.toString());
      }
    }
    return false;
  }

  Future<String> microsoftLogin({bool isSilent=false}) async
  {
    try {
      if(pca==null)
      {

        await PublicClientApplication.createPublicClientApplication(
          'f122a486-268c-43a0-8a9d-8cac3bfcbeb1',
          authority: 'https://login.microsoftonline.com/common',
          androidRedirectUri: 'msauth://com.flutter.sample/%2BJ%2B3yf%2FmrgPgKeg1llIttpSjcws%3D',
          );
      }
      return '';
      String token=  isSilent==false ? await pca!.acquireToken(["user.read"]):await pca!.acquireTokenSilent(["User.Read"]);

      return token;
    } catch (e) {
      if(kDebugMode)
      {
        print(e.toString());
      }
    }
    return '';
  }


  */
}