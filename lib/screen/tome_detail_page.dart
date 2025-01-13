import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/model/tome.dart';
import 'package:manga_library/service/firestore_service.dart';

class TomeDetailPage extends StatefulWidget {
  final Tome tome;
  final Serie serie;
  final List<OwnedTome> ownedTome;
  const TomeDetailPage({super.key, required this.tome, required this.serie, required this.ownedTome});

  @override
  State<TomeDetailPage> createState() => _TomeDetailPageState();
}

//readingStatus empty
class _TomeDetailPageState extends State<TomeDetailPage> {
  late bool _isOwned;
  late int _reading_status;
  bool _isWish = false;
  bool _loadingOwn = false;

  @override
  void initState() {
    super.initState();

    _isOwned = widget.ownedTome.any((tome) {
      bool is13 = tome.isbn!.trim().replaceAll("-", "").length == 13;
      return  is13 ? tome.isbn == widget.tome.isbn13 : tome.isbn == widget.tome.isbn10;
    });
    if (_isOwned) {
      _reading_status = widget.ownedTome.firstWhere((tome) {
        bool is13 = tome.isbn!.trim().replaceAll("-", "").length == 13;
        return  is13 ? tome.isbn == widget.tome.isbn13 : tome.isbn == widget.tome.isbn10;
      }).readingStatus!;
    } else {
      _reading_status = 0;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _bodyBuilder(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
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
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageBuilder(context),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.all(18),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.tome.seriesName!,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
              ),
              Text(
                widget.tome.tomeName!,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.grey),
              ),
              if (_reading_status == 1)
                Text(
                  AppLocalizations.of(context)!.currentlyReading,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.grey.shade400),
                ),
              const SizedBox(
                height: 16,
              ),
              _buttonBuilder(context),
              const SizedBox(
                height: 16,
              ),
              _serieButtonBuilder(context),
              const SizedBox(
                height: 16,
              ),
              _synapsysBuilder(context),
              const SizedBox(
                height: 16,
              ),
              _extraDetailBuilder(context)
            ]),
          )
        ],
      ),
    );
  }

  Container _extraDetailBuilder(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.center_focus_strong,
                color: Colors.lightBlue,
                size: 24,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                'ISBN : ${widget.tome.isbn13!}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ));
  }

  Container _synapsysBuilder(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            AppLocalizations.of(context)!.detailTomeSummary,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            widget.tome.summary ?? AppLocalizations.of(context)!.detailTomeNoSummary,
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ]),
      ),
    );
  }

  Center _serieButtonBuilder(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/series-details',
            arguments: {
              'serie' : widget.serie,
              'ownedTomes' : widget.ownedTome
            }
          );
        },
        label: Text(
          AppLocalizations.of(context)!.detailTomeAllCollectionButton,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.lightBlue),
        ),
        icon: const Icon(
          Icons.collections_bookmark,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          iconColor: Colors.lightBlue,
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonBuilder(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (!_isOwned)
            ElevatedButton.icon(
              onPressed: () {
                print("button pressed..");
              },
              icon: Icon(
                _isWish ? Icons.favorite_border : Icons.favorite,
                size: 20,
              ),
              label: Text(
                _isWish ? AppLocalizations.of(context)!.detailTomeWish : AppLocalizations.of(context)!.detailTomeNotWish,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade200,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          if (!_isOwned)
            const SizedBox(
              width: 12,
            ),
          _loadingOwn ?
              CircularProgressIndicator()
          : ElevatedButton.icon(
            onPressed: () async {
              setState(() {
                _loadingOwn = true;
              });

              if (_isOwned) {
                OwnedTome ownedTome = widget.ownedTome.firstWhere((tome) {
                  bool is13 = tome.isbn!.trim().replaceAll("-", "").length == 13;
                  return  is13 ? tome.isbn == widget.tome.isbn13 : tome.isbn == widget.tome.isbn10;
                });
                bool isRemoved = await removeTomeToOwnedList(ownedTome);
                setState(() {
                  if (isRemoved) {
                    widget.ownedTome.remove(ownedTome);
                    _isOwned = false;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Une erreur s'est produite lors de la suppresion du livre dans la base de données, veuillez ressayer")
                      ),
                    );
                  }
                  _loadingOwn = false;
                });
              } else {
                OwnedTome newOwned = OwnedTome(
                    isbn: widget.tome.isbn13 ?? widget.tome.isbn10,
                    readingStatus: 0,
                    serieId: widget.serie.serieId
                );
                bool isAdded = await addTomeToOwnedList(newOwned);
                setState(() {
                  if (isAdded) {
                    widget.ownedTome.add(newOwned);
                    _isOwned = true;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Une erreur s'est produite lors de l'ajout du livre dans la base de données, veuillez ressayer")
                      ),
                    );
                  }
                  _loadingOwn = false;
                });
              }


            },
            icon: Icon(
              _isOwned ?  Icons.check : Icons.add,
              size: 20,
            ),
            label: Text(
              _isOwned ? AppLocalizations.of(context)!.detailTomeOwn : AppLocalizations.of(context)!.detailTomeNotOwn,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade200,
              iconColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          if (_isOwned)
            const SizedBox(
              width: 12,
            ),
          if (_isOwned)
            IconButton(
              onPressed: () async {
                OwnedTome ownedTome = widget.ownedTome.firstWhere((tome) {
                  bool is13 = tome.isbn!.trim().replaceAll("-", "").length == 13;
                  return  is13 ? tome.isbn == widget.tome.isbn13 : tome.isbn == widget.tome.isbn10;
                });
                var newStatus = _reading_status == 0 ? 1 : 0;

                bool isUpdate = await updateTomeReadingStatus(ownedTome.isbn!, newStatus);
                setState(() {
                  if (isUpdate) {
                    for (var tome in widget.ownedTome) {
                      bool is13 = tome.isbn!.trim().replaceAll("-", "").length == 13;
                      if (is13 ? tome.isbn == widget.tome.isbn13 : tome.isbn == widget.tome.isbn10){
                        _reading_status =newStatus;
                        tome.readingStatus = _reading_status;
                        break;
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Une erreur s'est produite lors de l'ajout du livre dans la base de données, veuillez ressayer")
                      ),
                    );
                  }
                });

              },
              icon: Icon(
                _reading_status == 1
                    ? Icons.pause
                    : Icons.play_arrow,
                size: 20,
              ),
              // label: Text(
              //   'Lecture',
              //   style: const TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 18,
              //       color: Colors.white),
              // ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade200,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
        ]);
  }

  Widget _imageBuilder(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 30),
                child: Image.network(
                  widget.tome.cover!,
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.tome.cover!),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }
}
