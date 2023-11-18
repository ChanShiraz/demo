import 'package:demo/state/details_bloc/details_bloc.dart';
import 'package:demo/state/email_bloc/email_auth_bloc.dart';
import 'package:demo/state/fetch_bloc/fetch_bloc.dart';
import 'package:demo/state/phone_auth/phone_auth_bloc.dart';
import 'package:demo/state/sigin_bloc/sign_in_bloc.dart';
import 'package:demo/theme/theme.dart';
import 'package:demo/views/email_sign_up/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => PhoneAuthBloc(),
      ),
      BlocProvider(
        create: (context) => EmailAuthBloc(),
      ),
      BlocProvider(
        create: (context) => DetailsBloc()!,
      ),
      BlocProvider(
        create: (context) => FetchBloc(),
      ),
      BlocProvider(
        create: (context) => SignInBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme,
      home: SignUpPage(),
    );
  }
}
