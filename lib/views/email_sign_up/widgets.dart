import 'package:demo/constants/app_constant.dart';
import 'package:demo/extensions/context_ext.dart';
import 'package:demo/state/email_bloc/email_auth_bloc.dart';
import 'package:demo/state/sigin_bloc/sign_in_bloc.dart';
import 'package:demo/views/phone_sign_up/signup_page.dart';
import 'package:demo/views/profile/profile_page.dart';
import 'package:demo/views/user_details/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {super.key,
      required this.title,
      required this.textEditingController,
      required this.validator,
      required this.hintStyle,
      this.textStyle = const TextStyle()});
  final String title;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obsecureText = true;
  Icon nonVisible = const Icon(
    Icons.visibility_off,
    size: 20,
  );

  _PasswordFieldState();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: widget.textStyle,
      validator: widget.validator,
      controller: widget.textEditingController,
      obscureText: _obsecureText,
      decoration: InputDecoration(
          label: Text(widget.title),
          //labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
          ),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obsecureText = _obsecureText == true ? false : true;
                  nonVisible = _obsecureText == true
                      ? const Icon(
                          Icons.visibility_off,
                          size: 20,
                        )
                      : const Icon(
                          Icons.visibility,
                          size: 20,
                        );
                });
              },
              icon: nonVisible)),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          overlayColor:
              MaterialStatePropertyAll(AppColors.primaryColor.withOpacity(0.2)),
          backgroundColor:
              const MaterialStatePropertyAll(AppColors.secondaryColor),
          minimumSize: MaterialStatePropertyAll(Size(context.width * 0.6, 45))),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class EmailLoadingDialoge extends StatelessWidget {
  EmailLoadingDialoge({super.key, required this.email});
  final String email;
  late EmailAuthBloc emailAuthBloc;
  @override
  Widget build(BuildContext context) {
    emailAuthBloc = context.read<EmailAuthBloc>();
    return BlocListener(
      bloc: emailAuthBloc,
      listener: (context, state) {
        if (state is EmailAuthUserCreatedState) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserDetailsPage(
              email: email,
            ),
          ));
        } else if (state is EmailAlreadyRegisteredState) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ));
        }
      },
      child: AlertDialog(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: BlocBuilder(
            bloc: emailAuthBloc,
            builder: (context, state) {
              if (state is EmailAuthCreateState) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Please wait',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator()
                  ],
                );
              } else if (state is EmailAuthErrorState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Error',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'))
                  ],
                );
              } else if (state is EmailVerificationSentState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Email Verfication',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Pleaes check your email to verify it',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          emailAuthBloc.add(EmailVerificationCheckEvent());
                        },
                        child: const Text('Verified'))
                  ],
                );
              }
              return const Column(
                mainAxisSize: MainAxisSize.min,
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final VoidCallback voidCallback;
  final Widget widget;
  const MyButton({super.key, required this.voidCallback, required this.widget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: voidCallback,
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Center(child: widget),
          ),
        ));
  }
}

class SignInDialoge extends StatelessWidget {
  SignInDialoge({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late SignInBloc signInBloc;
  @override
  Widget build(BuildContext context) {
    signInBloc = context.read<SignInBloc>();
    return AlertDialog(
      content: BlocListener(
        bloc: signInBloc,
        listener: (context, state) {
          if (state is SignInLoadedState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
                (route) => false);
          }
        },
        child: BlocBuilder(
          bloc: signInBloc,
          builder: (context, state) {
            if (state is SignInLoadingState) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Please wait',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  CircularProgressIndicator()
                ],
              );
            } else if (state is SignInErrorState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.error),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        signInBloc.add(SignInInitialEvent());
                      },
                      child: const Text('Cancel'))
                ],
              );
            }
            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Sign in using email and password',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      label: Text('Email'),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email to continue';
                      } else if (!value.isValidEmail()) {
                        return 'Enter valid email to continue';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PasswordField(
                      title: 'Passward',
                      textEditingController: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter passward to contiue';
                        }
                        return null;
                      },
                      hintStyle: const TextStyle()),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          signInBloc.add(SignInEvent(
                              email: emailController.text,
                              password: passwordController.text));
                        }
                      },
                      child: const Text('Sign in'))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
