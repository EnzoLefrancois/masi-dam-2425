import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/model/error_firebase_auth.dart';
import 'package:manga_library/model/user_model.dart';
import 'package:manga_library/provider/user_provider.dart';
import 'package:manga_library/service/firestore_service.dart';
import 'package:manga_library/service/shared_pref_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();
  bool _isObscure = true;
  String _email = "";

  String _password = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusScope.of(context).unfocus();},

      child: PopScope(
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 40),
              child: Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 0,
                  ),
                  child: Column(
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
                            child: Text(AppLocalizations.of(context)!.loginPageText,
                            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
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
                                  return AppLocalizations.of(context)!.loginPageMail1;
                                } else if (!EmailValidator.validate(value)) {
                                  return AppLocalizations.of(context)!.loginPageMail2;
                                }
                                return null;
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
                                  return null;
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
                            child: Text(AppLocalizations.of(context)!.loginPageCreateAccount,style: const TextStyle(color: Colors.blue)),
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              }),
                          InkWell(
                            child: Text(AppLocalizations.of(context)!.loginPagePasswordForgot,style: const TextStyle(color: Colors.blue),),
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
                        child: Text(AppLocalizations.of(context)!.loginPageConnection,style: const TextStyle(fontSize: 18)),
                          onPressed: () async {
                            if (_loginFormKey.currentState != null &&
                                _loginFormKey.currentState!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                    email: _email, password: _password)
                                    .then((value) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Bonjour ${FirebaseAuth.instance.currentUser!.email}')),
                                    );
                                  }
                                  
                                });
                                UserModel? userModel = await getUserDetailsFromFirebase();
                                await saveUserToPreferences(userModel!);
                                if (context.mounted) {
                                  Provider.of<UserProvider>(
                                      context, listen: false).setUser(
                                      userModel);
                                  Navigator.popAndPushNamed(context, '/');
                                }
                              } on FirebaseAuthException catch (e) {
                                if (context.mounted) {
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
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}