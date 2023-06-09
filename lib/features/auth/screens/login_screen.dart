import 'package:bit_messenger/core/widgets/custom_button.dart';
import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/core/widgets/custom_textfield.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    await ref.read(authControllerProvider).loginInwithEmailAndPassword(
          context: context,
          email: email,
          password: password,
        );
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
                  height: 30,
                ),
                CustomButton(
                  text: "Login",
                  onPressed: () {
                    loginUser(
                      context: context,
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: const Text(
                    "New user SignUp here!",
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const SignUpScreen();
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
