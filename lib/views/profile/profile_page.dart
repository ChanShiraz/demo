import 'package:demo/model/user_details.dart';
import 'package:demo/repository/auth.dart';
import 'package:demo/state/fetch_bloc/fetch_bloc.dart';
import 'package:demo/views/email_sign_up/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  late FetchBloc fetchBloc;
  @override
  Widget build(BuildContext context) {
    fetchBloc = context.read<FetchBloc>();
    fetchBloc.add(FetchUserEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: BlocBuilder(
        bloc: fetchBloc,
        builder: (context, state) {
          if (state is FetchingUserState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FetchedUserState) {
            UserModel user = state.userModel;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 60,
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(user.imgLink),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user.email == null ? user.phone! : user.email!,
                  style: const TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user.dob,
                  style: const TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user.gender,
                  style: const TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      AuthRepository authRepository = AuthRepository();
                      await authRepository.signOutUser();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ),
                          (route) => false);
                    },
                    child: const Text('Log out'))
              ],
            );
          }
          return const Column(
            children: [],
          );
        },
      ),
    );
  }
}
