import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerWidget {
  final String id;
  const OTPScreen({
    super.key,
    required this.id,
  });

  void veriflyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.watch(authControllerProvider).veriflyOTP(context, id, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verifly your Phone Number",
          style: TextStyle(
            color: textColor,
          ),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "We have send an SMS with Code.",
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 180,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "- - - - - -",
                    hintStyle: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    if (val.length == 6) {
                      veriflyOTP(ref, context, val.trim());
                    }
                  },
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
