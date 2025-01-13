import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/routes.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _resetPasswordFormKey = GlobalKey<FormState>();
  final _textControllerEmail = TextEditingController();
  late String _email;
  String _textEnvoye = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusScope.of(context).unfocus();},
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 40),

            child: Form(
              key: _resetPasswordFormKey,
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
                          top: 7 * 3, bottom: 6 / 2),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8 / 2,
                        horizontal: 4,
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              labelText: 'Email',
                              hintText: 'exemple@mail.com',
                              icon: Icon(Icons.mail),
                            ),
                            //controller: _textControllerEmail,
                            autofocus: false,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.loginPageMail1;
                              } else if (!EmailValidator.validate(value)) {
                                return AppLocalizations.of(context)!.loginPageMail2;
                              }
                            },
                          )
                          ]
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
                          child: Text(AppLocalizations.of(context)!.loginPageConnection,style: const TextStyle(color: Colors.blue)),
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4 * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.resetPasswordPageButton),
                          onPressed: () async {
            
                            sendPasswordResetEmail();
                            _showText();
                            //goHome(formKey: _resetPasswordFormKey, context: context);
                          }),
                    ),
                    Center(
                      child: Text(_textEnvoye,
                          style: const TextStyle(fontSize: 11,fontStyle: FontStyle.italic, color: Colors.red)),
                    ),
                     Text(AppLocalizations.of(context)!.resetPasswordPageInfoText,
                        style: const TextStyle(fontSize: 11,fontStyle: FontStyle.italic, color: Colors.grey))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      // Affichage d'un message de réussite
    } on PlatformException catch (e) {
      // Affichage d'un message d'erreur
      print(e.message);
    }
  }

  void _showText() {
    setState(() {
      _textEnvoye = AppLocalizations.of(context)!.resetPasswordPageConfirmation;
    });
  }
}