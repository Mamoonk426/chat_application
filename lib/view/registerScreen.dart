import 'package:chat_application/components/button.dart';
import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/providers/registerProivder.dart';
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
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<Registerproivder>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              Text(
                'Register',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 20),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 200,
                      height: 170,
                      decoration: BoxDecoration(
                        image: registerProvider.image != null
                            ? DecorationImage(
                                image: FileImage(registerProvider.image!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        shape: BoxShape.circle,
                      ),
                      child: registerProvider.image == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    Positioned(
                      top: 140,
                      left: 80,
                      child: InkWell(
                        child: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onInverseSurface,
                          child: Icon(Icons.add, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Customformfield(
                        errortext: registerProvider.nameError,
                        onChanged: (value) {
                          registerProvider.checkName(value.toString());
                          print(value);
                        },
                        controller: name,
                        title: 'Name',
                        prefix: Icon(Icons.person),
                      ),
                      SizedBox(height: 10),
                      Customformfield(
                        errortext: registerProvider.emailError,
                        onChanged: (value) {
                          registerProvider.checkmail(value.toString());
                        },
                        controller: email,
                        title: 'email',
                        prefix: Icon(Icons.alternate_email_outlined),
                      ),
                      SizedBox(height: 10),
                      Customformfield(
                        errortext: registerProvider.passError,
                        onChanged: (value) {
                          registerProvider.checkpass(value.toString());
                        },
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
                  text: 'Already have an Account ?  ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loginscreen(),
                            ),
                          );
                        },
                      text: 'Login ',
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
                  title: 'Register',
                  call: () async {
                    final register = await registerProvider.registerUser(
                      email.text,
                      password.text,
                      name.text,
                      context,
                    );
                    if (register == false) {
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Loginscreen()),
                    );
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
