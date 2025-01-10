import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manga_library/model/book.dart';
import 'package:manga_library/model/series.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TomeDetailPage extends StatefulWidget {
  final Book tome;
  final Series serie;
  const TomeDetailPage({super.key, required this.tome, required this.serie});

  @override
  State<TomeDetailPage> createState() => _TomeDetailPageState();
}

//readingStatus empty
class _TomeDetailPageState extends State<TomeDetailPage> {
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
                widget.tome.mainTitle!,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
              ),
              Text(
                widget.tome.title!,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.grey),
              ),
              if (widget.tome.readingStatus!.isNotEmpty)
                Text(
                  widget.tome.readingStatus!,
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
                'ISBN : ${widget.tome.iSBN!}',
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
            AppLocalizations.of(context)!.detailTomeSynopsis,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            widget.tome.synopsis!,
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
            arguments: widget.serie,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              print("button pressed..");
            },
            icon: const Icon(
              Icons.favorite_border,
              size: 20,
            ),
            label: Text(
              AppLocalizations.of(context)!.detailTomeWish,
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
          const SizedBox(
            width: 12,
          ),
          ElevatedButton.icon(
            onPressed: () {
              print('Button pressed ...');
            },
            icon: const Icon(
              Icons.check,
              size: 20,
            ),
            label: Text(
              AppLocalizations.of(context)!.detailTomeOwn,
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
          const SizedBox(
            width: 12,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (widget.tome.readingStatus!.isNotEmpty) {
                  widget.tome.readingStatus = "";
                } else {
                  widget.tome.readingStatus =
                      AppLocalizations.of(context)!.currentlyReading;
                }
              });
            },
            icon: Icon(
              widget.tome.readingStatus!.isNotEmpty
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
