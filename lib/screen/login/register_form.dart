import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/model/error_firebase_auth.dart';
import 'package:manga_library/model/user_model.dart';
import 'package:manga_library/provider/user_provider.dart';
import 'package:manga_library/routes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:manga_library/service/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manga_library/service/shared_pref_service.dart';
import 'package:provider/provider.dart';


class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _firstname = "";
  String _lastname = "";
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusScope.of(context).unfocus();},
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 40),

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
                     Center(
                             child: Image.asset(
                               "assets/images/splash.png",
                               width: 160,
                               height: 160,
                               fit: BoxFit.cover,
                             ),
                           ),
                const Center(
                child: Padding(
                padding: EdgeInsets.only(bottom:8.0),
                child: Text('Manga Vault',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:50.0),
                    child: Text(AppLocalizations.of(context)!.loginPageText ,style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                  ),
                ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 4 * 3, bottom: 8 / 2),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5 / 2,
                        horizontal: 4,
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.registerPageFirstName,
                              hintText: 'John',
                              border: InputBorder.none,
                              icon: const Icon(Icons.person),
                            ),
                            autofocus: false,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.registerPageEmptyFirstName;
                              } 
                            },
                            onChanged: (value) {
                              _firstname = value;
                            },
                          ),
                          const Divider(
            
                            height: 8,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.registerPageLastName,
                              hintText: 'Doe',
                              border: InputBorder.none,
                              icon: const Icon(Icons.family_restroom),
                            ),
                            autofocus: false,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.registerPageEmptyName;
                              } 
                            },
                            onChanged: (value) {
                              _lastname = value;
                            },
                          ),
                          const Divider(
            
                            height: 8,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'exemple@mail.com',
                              border: InputBorder.none,
                              icon: Icon(Icons.mail),
                            ),
                            autofocus: false,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.loginPageMail1;
                              } else if (!EmailValidator.validate(value)) {
                                return AppLocalizations.of(context)!.loginPageMail2;
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
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.loginPagePasswordFied,
                                hintText: AppLocalizations.of(context)!.loginPagePasswordFied,
                                border: InputBorder.none,
                                icon: const Icon(Icons.password),
                                suffixIcon: IconButton(onPressed: (){setState(() {
                                  _isObscure = !_isObscure;
                                });}, icon: Icon( _isObscure ? Icons.visibility : Icons.visibility_off))
                              ),
                              autofocus: false,
                              obscureText: _isObscure,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.loginPagePassword1;
                                } else if (value.length < 8) {
                                  return AppLocalizations.of(context)!.loginPagePassword2;
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
                            child: Text(AppLocalizations.of(context)!.loginPageConnection,style: const TextStyle(color: Colors.blue)),
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            }),
                        InkWell(
                          child: Text(AppLocalizations.of(context)!.loginPagePasswordForgot,style: const TextStyle(color: Colors.blue)),
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
                      padding: const EdgeInsets.only(top:16.0),
            
                      child: ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.loginPageCreateAccount),
                          onPressed: () async {
                            if (_registerFormKey.currentState != null &&
                                _registerFormKey.currentState!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _email, password: _password)
                                    .then((value) async {
                                  await createUserCollection();
                                  await saveUserToFirestore(_firstname,_lastname,"https://st2.depositphotos.com/3758943/6040/i/450/depositphotos_60400977-stock-photo-sleeping-on-your-desktop.jpg");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Bonjour ${FirebaseAuth.instance.currentUser!.email}')),
                                  );
                                  UserModel? userModel = await getUserDetailsFromFirebase();
                                  await saveUserToPreferences(userModel!);
                                  Provider.of<UserProvider>(context, listen: false).setUser(userModel);
                                  Navigator.popAndPushNamed(context, '/');
                                });
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                        errors[e.code]!,
                                        style: TextStyle(color: Theme.of(context).primaryColor),
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
      ),
    );
  }
}
