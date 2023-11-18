import 'package:demo/constants/app_constant.dart';
import 'package:demo/extensions/context_ext.dart';
import 'package:demo/repository/auth.dart';
import 'package:demo/state/phone_auth/phone_auth_bloc.dart';
import 'package:demo/views/email_sign_up/widgets.dart';
import 'package:demo/views/phone_sign_up/widgets.dart';
import 'package:demo/views/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneSignUpPage extends StatelessWidget {
  PhoneSignUpPage({super.key});
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  String countryCode = '92';
  String phoneNo = '';
  late Bloc phoneBloc;
  @override
  Widget build(BuildContext context) {
    phoneBloc = context.read<PhoneAuthBloc>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener(
          bloc: phoneBloc,
          listener: (context, state) {
            if (state is PhoneAuthLoadingState) {
              showDialog(
                context: context,
                builder: (context) =>
                    LoadingDialoge(phoneNo: countryCode + phoneNo),
              );
            }
          },
          child: Stack(
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
                            'Phone Sign Up',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Sign up using Phone Number'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: context.height * 0.04,
                                  ),
                                  IntlPhoneField(
                                      decoration: const InputDecoration(
                                        hintText: '3090571374',
                                      ),
                                      disableLengthCheck: true,
                                      controller: phoneController,
                                      initialCountryCode: 'PK',
                                      onCountryChanged: (value) {
                                        countryCode = value.displayCC;
                                      },
                                      onChanged: (value) {
                                        phoneNo = value.number;
                                      },
                                      validator: (value) {
                                        if (value!.number.isEmpty) {
                                          return 'Please enter valid phone number to continue!';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (context) =>
                                          //       const AlertDialog(
                                          //     content:
                                          //         CircularProgressIndicator(),
                                          //   ),
                                          // );
                                          phoneBloc.add(SendOtpToPhoneEvent(
                                              phoneNo: '+$countryCode$phoneNo'));
                                          // print(
                                          //     'phone +${countryCode + phoneNo}');
                                        }
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
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.email_outlined),
                                                SizedBox(
                                                  width: context.width * 0.1,
                                                ),
                                                const Text(
                                                  'Use email sign up instead',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
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
          ),
        ));
  }
}

class FormKeys {}
