import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/model/error_firebase_auth.dart';
import 'package:manga_library/routes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:manga_library/service/firestore_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _registerFormKey,
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
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text('Manga Vault',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: Text(
                          "L'application pour suivre l'évolution de votre mangathèque",
                          style: TextStyle(
                              fontSize: 13, fontStyle: FontStyle.italic)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4 * 3, bottom: 8 / 2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5 / 2,
                      horizontal: 4,
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
                            obscureText: false,
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
                          child: const Text('Se connecter',
                              style: TextStyle(color: Colors.blue)),
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          }),
                      InkWell(
                        child: const Text('Mot de passe oublié',
                            style: TextStyle(color: Colors.blue)),
                        onTap: () {
                          Navigator.pushNamed(context, '/resetPassword');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                        child: const Text('Créer un compte'),
                        onPressed: () async {
                          if (_registerFormKey.currentState != null &&
                              _registerFormKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _email, password: _password)
                                  .then((value) async {
                                await createUserCollection();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Bonjour ${FirebaseAuth.instance.currentUser!.email}')),
                                );
                                Navigator.popAndPushNamed(context, '/main');
                              });
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                      errors[e.code]!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.redAccent),
                              );
                            }
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
