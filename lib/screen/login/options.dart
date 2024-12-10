import 'package:manga_library/main.dart';

import 'package:manga_library/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'login.dart';


void main() => runApp(const Options());

class Options extends StatelessWidget {
  const Options({super.key});

  static const String _title = 'Options';

  //static ThemeModel themeModel =  ThemeModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      title: _title,
      home: const MyStatefulWidget(),
      routes: {
        '/login': (context) => LoginForm(),
      },
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  bool themeClair = false;

  changeBoolTheme()
  {
    setState(() {
      themeClair = !themeClair;
    });
  }

  Widget textButtonTheme()
  {
    if(!themeClair) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
            Icon(Icons.sunny),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Mode clair"),
            )
        ],
      );//
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.nightlight_round_sharp),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Mode sombre"),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: Center(
        child: ListView(
                children: [
                    ListTile(
                        title: const Text("Thème"),
                        onTap: () {
                          //final themeProvider = Provider.of<ThemeModel>(context);
                          changeBoolTheme();

                          //Provider.of<ThemeModel>(context,listen: false).changeTheme();
                      },
                      trailing: textButtonTheme(),
                    ),
                    ListTile(
                      title: const Text('Langues'),
                      onTap: () {
                      // Traitez l'option 2 ici
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("Français"),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.arrow_right),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text("Version"),
                      onTap: () {
                      },
                      trailing: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text("1.0"),
                      ),
                    ),
                  ListTile(
                    title: const Text("Se déconnecter et quitter"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            children: <Widget>[
                              Column(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                                    child: Text("Êtes-vous sûr de vouloir vous déconnecter et quitter ?"),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ElevatedButton(onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      SystemNavigator.pop();
                                      //Navigator.pushNamed(context,'/login');
                                    }, child: const Text("Valider")),
                                  ),
                                  ElevatedButton(onPressed: () { Navigator.pop(context);}, child: const Text("Annuler"))
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
        )

        /*Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    changeBoolTheme();
                    },
                  child: textButtonTheme(),
              ),
              ElevatedButton(
                onPressed: () { },
                child: const Text('Langues'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Version'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text("Voulez-vous vous déconnecter ?"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushNamed(context,kLoginRoute);
                                  }, child: const Text("Valider")),
                              ),
                              ElevatedButton(onPressed: () { Navigator.pop(context);}, child: const Text("Annuler"))
                            ],
                          )
                        ],
                      );
                    },
                  );
                  //FirebaseAuth.instance.signOut();
                },
                child: const Text('Se déconnecter'),
              ),
            ],
        )
      ),*/
    )
    );
  }

}
