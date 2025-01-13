import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Récupérer l'utilisateur actuel
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Authentifier avec l'ancien mot de passe si nécessaire
          String email = user.email!;
          String currentPassword = _currentPasswordController.text;

          AuthCredential credential = EmailAuthProvider.credential(
            email: email,
            password: currentPassword,
          );

          // Re-authentifier l'utilisateur
          await user.reauthenticateWithCredential(credential);

          // Vérifier et mettre à jour le nouveau mot de passe
          String newPassword = _newPasswordController.text;
          await user.updatePassword(newPassword);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.changePasswordPageSuccess),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          throw Exception(AppLocalizations.of(context)!.changePasswordPageUserNotFound);
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = AppLocalizations.of(context)!.changePasswordError1;
        if (e.code == 'invalid-credential') {
          errorMessage = AppLocalizations.of(context)!.changePasswordError2;
        } else if (e.code == 'weak-password') {
          errorMessage = AppLocalizations.of(context)!.changePasswordError3;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Material(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.changePasswordPageText,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24,),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextFormField(
                              controller: _currentPasswordController,
                              obscureText: _isObscure1,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.changePasswordPageActualPassword,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:  const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isObscure1 = !_isObscure1;
                                    });
                                  },
                                  child: Icon(
                                    _isObscure1
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 22,
                                  ),
                                ),
                                
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.changePasswordPageActualPasswordValidator;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24,),
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: _isObscure2,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.changePasswordPageNewPassword,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });},
                                  child: Icon(
                                    _isObscure2
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 22,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.changePasswordPageNewPasswordValidator;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24,),
                            _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: _changePassword,
                                    child: Text(AppLocalizations.of(context)!.changePasswordPageButton),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
