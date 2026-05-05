import 'package:chat_application/components/button.dart';
import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/providers/registerProivder.dart';
import 'package:chat_application/themes/app_theme.dart';
import 'package:chat_application/view/loginScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<Registerproivder>(context);

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
                const SizedBox(height: 40),
                Text(
                  'Create Account',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Join our community and start chatting',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary500.withOpacity(0.2),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary500.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          image: registerProvider.image != null
                              ? DecorationImage(
                                  image: FileImage(registerProvider.image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: registerProvider.image == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 60,
                                color: AppColors.grey400,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // Trigger image selection from provider
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary500,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
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
                          errortext: registerProvider.nameError,
                          onChanged: (value) =>
                              registerProvider.checkName(value ?? ''),
                          controller: name,
                          title: 'Full Name',
                          prefix: const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Customformfield(
                          errortext: registerProvider.emailError,
                          onChanged: (value) =>
                              registerProvider.checkmail(value ?? ''),
                          controller: email,
                          title: 'Email Address',
                          prefix: const Icon(
                            Icons.alternate_email_rounded,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Customformfield(
                          isObscure: registerProvider.ispasswordVisible,
                          suffixImage: IconButton(
                            onPressed: () {
                              registerProvider.setPasswordVisibility(
                                !registerProvider.ispasswordVisible,
                              );
                            },
                            icon: Icon(
                              registerProvider.ispasswordVisible
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 20,
                              color: AppColors.grey500,
                            ),
                          ),
                          errortext: registerProvider.passError,
                          onChanged: (value) =>
                              registerProvider.checkpass(value ?? ''),
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
                  title: 'Create Account',
                  isLoading: registerProvider.isLoading,
                  call: () async {
                    final register = await registerProvider.registerUser(
                      email.text,
                      password.text,
                      name.text,
                      context,
                    );
                    if (register != false) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginscreen(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
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
                                  builder: (context) => const Loginscreen(),
                                ),
                              );
                            },
                          text: 'Sign In',
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
