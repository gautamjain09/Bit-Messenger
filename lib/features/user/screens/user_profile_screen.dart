import 'dart:io';
import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/core/widgets/custom_button.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/features/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  File? profileImage;

  void selectImage() async {
    profileImage = await pickImage(context);
    setState(() {});
  }

  void storeUserData(File? profileImage, String profileUrl) {
    ref.read(userControllerProvider).updateUserProfile(
          context: context,
          profileImage: profileImage,
          profileUrl: profileUrl,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Profile",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        body: Column(
          children: [
            // State persistence Error && Contact Chat me bhi update krna pdega
            // ref
            //     .read(
            //         getUserDataProvider(FirebaseAuth.instance.currentUser!.uid))
            //     .when(
            //       data: (userModel) {
            //         return Center(
            //           child: Column(
            //             children: [
            //               const SizedBox(height: 20),
            //               Stack(
            //                 children: [
            //                   (profileImage == null)
            //                       ? CircleAvatar(
            //                           backgroundImage: NetworkImage(
            //                             userModel.profileUrl,
            //                           ),
            //                           radius: 64,
            //                         )
            //                       : CircleAvatar(
            //                           backgroundImage: FileImage(
            //                             profileImage!,
            //                           ),
            //                           radius: 64,
            //                         ),
            //                   Positioned(
            //                     bottom: -10,
            //                     left: 80,
            //                     child: IconButton(
            //                       onPressed: selectImage,
            //                       icon: const Icon(
            //                         Icons.add_a_photo,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.all(30),
            //                 child: CustomButton(
            //                   text: "Save",
            //                   onPressed: () {
            //                     storeUserData(
            //                       profileImage,
            //                       userModel.profileUrl,
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //       error: ((error, stackTrace) =>
            //           ErrorText(error: error.toString())),
            //       loading: () => const Loader(),
            //     ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: CustomButton(
                text: "Logout",
                onPressed: () {
                  ref.watch(authControllerProvider).logOut(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
