import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MyLibrarypage extends StatefulWidget {
  const MyLibrarypage({super.key, required this.apiKey});

  final String apiKey;

  @override
  State<MyLibrarypage> createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibrarypage> {
  TextEditingController searchController = TextEditingController(); // Contrôleur pour la recherche

  @override
  Widget build(BuildContext context) {
    return  Container(
          child: Column(
            children: [
              _searchSide(),
              Expanded(child:  _listSide())
            ],
          ),

    );

  }

  Widget _searchSide() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal : 10.0),
                          child: Icon(
                            Icons.search,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'MANGA Search...',
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                            ),
                            minLines: 1,

                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ),
            SizedBox(width: 50,),
            Ink(
              decoration:  ShapeDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                shape: CircleBorder(),
              ),
              child: IconButton(
                iconSize: 50,
                icon: Icon(
                  Icons.filter_list,
                  size: 25,
                ),
                onPressed: (){},
              ),
            )
          ]
      ),
    );
  }


  Widget _listSide() {
    return  ListView.builder(
      itemCount: 10,
      itemBuilder: (_,index)
      {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: InkWell(
            onTap: () {print(index);},
            child: Material(
              color: Colors.white60,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
                  child: Row(
                    children: [
                      Image.network("https://cdn.pixabay.com/photo/2024/03/03/12/42/ai-generated-8610368_640.png", width: 100, height: 150,),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Titre',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'x/X Tomes  -  Lecture en cours',
                          ),
                        ],
                      )
                    ]
                  ),
                ),
              ),
            ),
          ),
        )
        ;
      },
    );
  }
}
