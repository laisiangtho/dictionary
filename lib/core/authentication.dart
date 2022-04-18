part of data.core;

class Authentication extends UnitAuthentication {
  // Authentication({name, options}) : super(name: name, options: options);
  Authentication()
      : super(
          appleServiceId: 'com.myordbok.app.signin',
          redirectUri: 'https://myordbok-app.firebaseapp.com/__/auth/handler',
        );
}
