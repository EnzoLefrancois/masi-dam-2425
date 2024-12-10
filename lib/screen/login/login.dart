import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/model/error_firebase_auth.dart';
import 'package:manga_library/routes.dart';


class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);
  final _loginFormKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusScope.of(context).unfocus();},
      child: PopScope(
        child: Scaffold(
          body: SafeArea(
            child: Form(
              key: _loginFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom:8.0),
                        child: Text('Manga Vault',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom:50.0),
                          child: Text("L'application pour suivre l'évolution de votre mangathèque",style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                        ),

                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom:10),
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 2,
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'exemple@mail.com',
                              border: InputBorder.none,
                              icon: Icon(Icons.mail),
                            ),
                            autofocus: false,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'L’adresse mail doit être renseignée.';
                              } else if (!EmailValidator.validate(value)) {
                                return 'L’adresse mail doit être une adresse mail valide.';
                              }
                            },
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                          const Divider(

                            height: 8,
                          ),
                          TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Votre mot de passe',
                                border: InputBorder.none,
                                icon: Icon(Icons.password),
                              ),
                              autofocus: false,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le mot de passe doit être renseigné.';
                                } else if (value.length < 8) {
                                  return 'Le mot de passe doit contenir au moins 9 caractères.';
                                }
                              },
                              onChanged: (value) {
                            _password = value;
                          }),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: const Text('Créer un compte',style: TextStyle(color: Colors.blue)),
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            }),
                        InkWell(
                          child: const Text('Mot de passe oublié',style: TextStyle(color: Colors.blue),),
                          onTap: () {
                            Navigator.pushNamed(context, '/resetPassword');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20 * 2,
                    ),
                    ElevatedButton(
                      child: const Text('Se connecter',style: TextStyle(fontSize: 18)),
                        onPressed: () async {
                          if (_loginFormKey.currentState != null &&
                              _loginFormKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                  email: _email, password: _password)
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Bonjour ${FirebaseAuth.instance.currentUser!.email}')),
                                );
                                Navigator.pushNamed(context, '/main');
                              });
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(

                                    content: Text(
                                      errors[e.code]!,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.redAccent),
                              );
                            }
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}