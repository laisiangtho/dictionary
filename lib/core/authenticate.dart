part of 'main.dart';

class Authenticate extends AuthenticateUnit {
  Authenticate(Data data)
      : super(
          data: data,
          appleServiceId: 'com.myordbok.app.signin',
          redirectUri: 'https://myordbok-app.firebaseapp.com/__/auth/handler',
        );
}
