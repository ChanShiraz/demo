import 'package:demo/constants/app_constant.dart';
import 'package:demo/extensions/context_ext.dart';
import 'package:demo/repository/auth.dart';
import 'package:demo/state/email_bloc/email_auth_bloc.dart';
import 'package:demo/views/email_sign_up/widgets.dart';
import 'package:demo/views/phone_sign_up/signup_page.dart';
import 'package:demo/views/user_details/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late EmailAuthBloc emailBloc;
  @override
  Widget build(BuildContext context) {
    emailBloc = context.read<EmailAuthBloc>();
    return BlocListener(
      bloc: emailBloc,
      listener: (context, state) {
        if (state is EmailAuthCreateState) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                EmailLoadingDialoge(email: emailController.text),
          );
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                width: context.width,
                height: context.height,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.secondaryColor,
                      AppColors.primaryColor,
                    ]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: context.height * 0.12,
                    ),
                    const Text(
                      'Demo',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 22),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                   
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: context.height * 0.7,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          SizedBox(
                            width: context.width,
                            height: 20,
                          ),
                          const Text(
                            'Email Sign Up',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Sign up using email and password'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: context.height * 0.04,
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
                                        emailBloc.add(EmailAuthCreateUserEvent(
                                            email: emailController.text,
                                            password: passwordController.text));
                                      },
                                      child: const Text('Sign Up')),
                                  SizedBox(
                                    height: context.height * 0.02,
                                  ),
                                  SizedBox(
                                    height: context.height * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 1,
                                        width: context.width * 0.3,
                                        color: Colors.grey,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text('OR'),
                                      ),
                                      Container(
                                        height: 1,
                                        width: context.width * 0.3,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: context.height * 0.03,
                                  ),
                                  MyButton(
                                    voidCallback: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => PhoneSignUpPage(),
                                      ));
                                    },
                                    widget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                            Icons.phone_android_outlined),
                                        SizedBox(
                                          width: context.width * 0.1,
                                        ),
                                        const Text(
                                          'Continue With Phone',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  MyButton(
                                    voidCallback: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => SignInDialoge(),
                                      );
                                    },
                                    widget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.mail_outline),
                                        SizedBox(
                                          width: context.width * 0.1,
                                        ),
                                        const Text(
                                          'Sign in with email',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
