import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/core/widgets/custom_button.dart';
import 'package:bit_messenger/core/widgets/custom_textfield.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
  }

  void signupUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String cPassword}) {
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(
        context: context,
        text: "Please fill all the Values",
      );
    }
    if (password != cPassword) {
      showSnackBar(
        context: context,
        text: "Passwords does not Match!",
      );
    } else if (password.length < 6) {
      showSnackBar(
        context: context,
        text: "Password of atleast 6 characters is required",
      );
    } else {
      ref.read(authControllerProvider).signUpwithEmailAndPassword(
            context: context,
            email: email,
            password: password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Bit Messenger",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: "Enter your Email-Id",
                  inputType: TextInputType.emailAddress,
                  prefixIcon: Icons.person_pin,
                  isObscure: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Create Password",
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.password,
                  isObscure: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: cPasswordController,
                  hintText: "Re-Enter Password",
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.password,
                  isObscure: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  text: "SignUp",
                  onPressed: () {
                    signupUser(
                      context: context,
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      cPassword: cPasswordController.text.trim(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: const Text(
                    "Already a user Login here!",
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
