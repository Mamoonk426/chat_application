import 'package:chat_application/components/button.dart';
import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/providers/loginProvider.dart';
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
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Loginprovider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/Images/login.jpg',
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text('Login', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Customformfield(
                        controller: email,
                        title: 'email',
                        prefix: Icon(Icons.alternate_email_outlined),
                      ),
                      SizedBox(height: 10),
                      Customformfield(
                        controller: password,
                        title: 'password',
                        prefix: Icon(Icons.password),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: "Don't have an Account ?  ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Registerscreen(),
                            ),
                          );
                        },
                      text: 'Register ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Button(
                  title: 'Login',
                  call: () async {
                    final login = await authProvider.login(
                      email.text.trim(),
                      password.text.trim(),
                      context,
                    );
                    if (login == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homescreen()),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
