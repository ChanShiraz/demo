import 'dart:io';

import 'package:demo/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

Future<String?> datePickerDialouge(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
          1900), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now());
  if (pickedDate != null) {
    String formattedDate = DateFormat('dd-MM-yyy').format(pickedDate);
    return formattedDate;
  }
  return null;
}

class GenderSelectionDropdown extends StatefulWidget {
  final Function(String?) onGenderSelected;

  const GenderSelectionDropdown({super.key, required this.onGenderSelected});

  @override
  _GenderSelectionDropdownState createState() =>
      _GenderSelectionDropdownState();
}

class _GenderSelectionDropdownState extends State<GenderSelectionDropdown> {
  String? selectedGender;
  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: context.height * 0.07,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black45, width: 1.2),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: DropdownButton<String>(
              hint: const Text('Select Gender'),
              value: selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });

                // Notify the parent widget about the selected gender
                widget.onGenderSelected(newValue);
              },
              items: genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ImagePickerView extends StatefulWidget {
  ImagePickerView({
    super.key,
    this.heith = 0.16,
    this.width = 0.375,
    required this.receivedFile,
  });
  double heith;
  double width;
  final Function(File) receivedFile;
  String? link;

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () async {
          widget.link = null;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Pick Image',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      image =
                          await picker.pickImage(source: ImageSource.camera);
                      try {
                        setState(() {
                          File file = File(image!.path);
                          imageFile = file;
                          widget.receivedFile(file);
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Icon(Icons.camera), Text('Camera')],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      image =
                          await picker.pickImage(source: ImageSource.gallery);
                      try {
                        setState(() {
                          File file = File(image!.path);
                          imageFile = file;
                          widget.receivedFile(file);
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Icon(Icons.image), Text('Gallery')],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          height: context.height * widget.heith,
          width: context.width * widget.width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: imageFile == null
              ? const Icon(Icons.add_a_photo_outlined)
              : Image.file(imageFile!),
        ),
      ),
    );
  }
}

class UploadingDialoge extends StatelessWidget {
  const UploadingDialoge({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please Wait',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
