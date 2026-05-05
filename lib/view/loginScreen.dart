import 'package:chat_application/components/button.dart';
import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/providers/loginProvider.dart';
import 'package:chat_application/themes/app_theme.dart';
import 'package:chat_application/view/homeScreen.dart';
import 'package:chat_application/view/registerScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Loginprovider>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary50,
              AppColors.grey0,
              AppColors.secondary50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Icon or Logo instead of heavy image
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_rounded,
                      size: 80,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome Back',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your conversations',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Card(
                  elevation: 0,
                  color: AppColors.grey0.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: AppColors.primary500.withOpacity(0.1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Customformfield(
                          controller: email,
                          title: 'Email Address',
                          prefix: const Icon(
                            Icons.alternate_email_rounded,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Customformfield(
                          isObscure: authProvider.ispasswordVisible,
                          suffixImage: IconButton(
                            onPressed: () {
                              authProvider.setPasswordVisibility(
                                !authProvider.ispasswordVisible,
                              );
                            },
                            icon: Icon(
                              authProvider.ispasswordVisible
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 20,
                              color: AppColors.grey500,
                            ),
                          ),
                          controller: password,
                          title: 'Password',
                          prefix: const Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Button(
                  isLoading: authProvider.isLoading,
                  title: 'Sign In',
                  call: () async {
                    final login = await authProvider.login(
                      email.text.trim(),
                      password.text.trim(),
                      context,
                    );
                    if (login == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Homescreen(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey600,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Registerscreen(),
                                ),
                              );
                            },
                          text: 'Register Now',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.primary600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
