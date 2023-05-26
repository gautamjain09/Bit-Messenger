import 'package:bit_messenger/common/utils.dart';
import 'package:bit_messenger/common/widgets/custom_button.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/theme/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  Country? country;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneNumberController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, "+${country!.phoneCode}$phoneNumber");
    } else {
      showSnackBar(context: context, text: "Fill out all the Fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enter your Phone Number",
          style: TextStyle(
            color: textColor,
          ),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Bit Messenger needs to verifly your Phone Number",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      pickCountry();
                    },
                    child: const Text("Pick Country"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (country != null)
                        Text(
                          "+${country?.phoneCode}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            hintText: "Phone Number",
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.5,
              child: CustomButton(
                text: "NEXT",
                onPressed: () {
                  sendPhoneNumber();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
