// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:demo/state/details_bloc/details_bloc.dart';
import 'package:demo/views/profile/profile_page.dart';
import 'package:flutter/material.dart';

import 'package:demo/model/user_details.dart';
import 'package:demo/repository/details.dart';
import 'package:demo/views/user_details/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsPage extends StatelessWidget {
  String? email;
  String? phone;
  UserDetailsPage({
    super.key,
    this.email,
    this.phone,
  });
  final formKey = GlobalKey<FormState>();
  String dob = '';
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  String selectedGender = '';
  File? profileImage;
  void getProfileImage(File file) {
    profileImage = file;
  }

  late DetailsBloc detailsBloc;
  @override
  Widget build(BuildContext context) {
    detailsBloc = context.read<DetailsBloc>();
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener(
        bloc: detailsBloc,
        listener: (context, state) {
          if (state is DetailsBlocUploadingState) {
            showDialog(
              context: context,
              builder: (context) => const UploadingDialoge(),
            );
          } else if (state is DetailsBlocUploadedState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>  ProfilePage(),
                ),
                (route) => false);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      'Enter your Details',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ImagePickerView(
                      receivedFile: getProfileImage,
                      // link: profileImageLink,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        prefixIcon: Icon(Icons.person_outline_outlined),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name is required!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: dobController,
                      onTap: () async {
                        String? pickedDate = await datePickerDialouge(context);
                        if (pickedDate != null) {
                          dobController.text = pickedDate;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Date of Birth',
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'DOB is required!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GenderSelectionDropdown(
                      onGenderSelected: (gender) {
                        selectedGender = gender ?? '';
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (profileImage == null) {
                            showSnackBar(context, 'Please add your photo');
                          } else if (selectedGender.isEmpty) {
                            showSnackBar(context, 'Please select a geneder');
                          } else if (formKey.currentState!.validate()) {
                            UserModel userModel = UserModel(
                                name: nameController.text,
                                dob: dobController.text,
                                gender: selectedGender,
                                imgLink: '',
                                email: email,
                                phone: phone);
                            detailsBloc.add(UploadUserDetailsEvent(
                                userModel: userModel,
                                imageFile: profileImage!));
                          }
                        },
                        child: const Text('Save'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
