import 'dart:io';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/core/widgets/custom_button.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  TextEditingController nameController = TextEditingController();
  File? profileImage;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    profileImage = await pickImage(context);
    setState(() {});
  }

  void storeUserData(String name, File? profileImage) {
    if (name.isNotEmpty) {
      ref.watch(authControllerProvider).storeuserDataToFirestore(
            context,
            name,
            profileImage,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  (profileImage == null)
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/defaultProfileImage.png"),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            profileImage!,
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: CustomButton(
                      text: "SAVE",
                      onPressed: () => storeUserData(
                        nameController.text.trim(),
                        profileImage,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
