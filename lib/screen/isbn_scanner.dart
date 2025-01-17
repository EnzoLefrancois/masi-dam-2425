import 'dart:collection';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/model/tome.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../widget/scanner_widget.dart';

class IsbnScannerScreen extends StatefulWidget {
  final List<Serie> allSeries;
  const IsbnScannerScreen({super.key, required this.allSeries});

  @override
  State<IsbnScannerScreen> createState() => _IsbnScannerScreenState();
}

class _IsbnScannerScreenState extends State<IsbnScannerScreen> {
  final Set<Tome> _list = HashSet();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.isbnScannerPageTitle)),

      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: ScannerWidget(
              onScan: onScan,
            ),
          ),
           Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Espacement autour
              child: Column(
                children: [
                  // Le bouton "Ajouter"
                  if(_list.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/tome-validation', arguments:  _list,).then((_) {
                        setState(() {
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    },
                    label: Text(AppLocalizations.of(context)!.isbnScannerPageAddLabel),
                    icon: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 10), // Espacement entre le bouton et la liste
                  // Liste horizontale des éléments
                  Expanded(
                    child: ListView.builder(

                      scrollDirection: Axis.horizontal,
                      itemCount: _list.length,
                      itemBuilder: (_, index) {
                        var t = _list.elementAt(index);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.network(
                            t.cover!,
                            width: 100,
                            height: 100,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),))
        ],
      ),
    );
  }

  Future<void> onScan(Barcode barcode) async {
    String barcodeString = barcode.code!;
    barcodeString = barcodeString.trim().replaceAll("-", "");
    bool is13 = barcodeString.length == 13;
    Tome? tome;

    for (var serie in widget.allSeries) {
      try {
        tome = serie.tomes!.firstWhere((tome) => is13 ? (tome.isbn13!.trim().replaceAll("-", "") == barcodeString) : (tome.isbn10!.trim().replaceAll("-", "") == barcodeString),);
      } catch (e) {
        tome = null;
      }
      if (tome != null) {
        break;
      }
    }
    if (tome != null) {
      setState(() {
      _list.add(tome!);
      });

    } else {
    // Loading dialog
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext alertCtx) {
            return SimpleDialog(
              children: <Widget>[
                Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      child: Text(AppLocalizations.of(context)!.isbnScannerPageMangaNotFound),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ElevatedButton(onPressed: () { Navigator.pop(context);}, child: const Text("Ok"))
                  ],
                )
              ],
            );
          });

    }
  }
}