import 'package:demo/state/phone_auth/phone_auth_bloc.dart';
import 'package:demo/views/profile/profile_page.dart';
import 'package:demo/views/user_details/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingDialoge extends StatelessWidget {
  final String phoneNo;
  final TextEditingController otpController;
  LoadingDialoge({Key? key, required this.phoneNo})
      : otpController = TextEditingController(),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final phoneAuthBloc = context.read<PhoneAuthBloc>();
    return BlocListener(
      bloc: phoneAuthBloc,
      listener: (context, state) {
        if (state is PhoneAuthVerifiedState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => UserDetailsPage(phone: phoneNo),
            ),
          );
        }
        if (state is PhoneAuthOldUserState) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>  ProfilePage(),
              ),
              (route) => false);
        }
        if (state is PhoneAuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      child: AlertDialog(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: BlocBuilder(
            bloc: phoneAuthBloc,
            builder: (context, state) {
              if (state is PhoneAuthLoadingState) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please wait',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CircularProgressIndicator(),
                  ],
                );
              } else if (state is PhoneAuthCodeSentSuccessState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Enter received OTP at \n$phoneNo',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: otpController,
                      decoration: const InputDecoration(hintText: 'OTP'),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        phoneAuthBloc.add(VerifySentOtpEvent(
                          otpCode: otpController.text,
                          verificationId: state.verificationId,
                        ));
                      },
                      child: const Text('Continue'),
                    )
                  ],
                );
              } else if (state is PhoneAuthErrorState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Error Occurred!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(state.error),
                  ],
                );
              }
              return const Text('Some Error Occurred');
            },
          ),
        ),
      ),
    );
  }
}
