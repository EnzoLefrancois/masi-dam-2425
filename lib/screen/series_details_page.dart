import 'package:flutter/material.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/serie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manga_library/model/tome.dart';

class SeriesDetailsPage extends StatefulWidget {
  final Serie series;
  final List<OwnedTome> ownedTome;
  const SeriesDetailsPage(
      {super.key, required this.series, required this.ownedTome});

  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

class _SeriesDetailsPageState extends State<SeriesDetailsPage> {

  bool _filterOwned = false;
  bool _filterAscending = true;

  late List<Tome> _filterListTome;

  @override
  void initState() {
    super.initState();
    widget.series.tomes!.sort((a, b) {
      return a.key!.compareTo(b.key!);
    });

    _filterListTome = widget.series.tomes!;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _appBarBuilder(context),
      body: _bodyBuilder(context),
    );
  }

  Widget _bodyBuilder(context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  widget.series.mainCover!,
                  width: 100,
                  height: 150,
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(context),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildGenresSection(context),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildAuthorsSection(context),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            _buildBooksSection(context)
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(context) {
    return Text(
      widget.series.name!,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 0),
    );
  }

  Widget _buildGenresSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.categories,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            clipBehavior: Clip.none,
            children: _getGenresWidget()),
      ],
    );
  }

  List<Widget> _getGenresWidget() {
    List<Widget> widgetList = [];
    for (var genre in widget.series.categories!) {
      widgetList.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 10, vertical: 5),
            child: Text(
              genre,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    }

    return widgetList;
  }

  Widget _buildAuthorsSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.author,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            clipBehavior: Clip.none,
            children: _getAuthorsWidget()),
      ],
    );
  }

  List<Widget> _getAuthorsWidget() {
    List<Widget> widgetList = [];
    widgetList.add(
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Text(
                widget.series.author!,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );

    return widgetList;
  }

  Widget _buildBooksSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(AppLocalizations.of(context)!.edition,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                Text('${widget.series.nbVolume!} ${AppLocalizations.of(context)!.tome}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey)),
              ]
            ),
            CheckboxMenuButton(
                value: _filterOwned,
                onChanged: (bool? value) {
                  setState(() {
                    _filterOwned = !_filterOwned;
                    if (_filterOwned) {
                      _filterListTome = [];
                      _filterListTome.addAll( widget.series.tomes!.where((t) {
                        return widget.ownedTome.any((o) {
                          bool is13 = o.isbn!.trim().replaceAll("-", "").length == 13;
                          return  is13 ? o.isbn == t.isbn13 : o.isbn == t.isbn10;
                          });
                        }
                      ).toList());
                    } else {
                      _filterListTome = widget.series.tomes!;
                    }
                  });
                  },
                child: Text(AppLocalizations.of(context)!.detailTomeOwn)),
            PopupMenuButton<int>(
              icon: const Icon(Icons.sort_by_alpha_rounded),
              onSelected: (value) {
                setState(() {
                  if (value == 0) {
                    _filterAscending = true;
                    _filterListTome.sort((a, b) => a.key!.compareTo(b.key!));

                  } else {
                    _filterAscending = false;
                    _filterListTome.sort((a, b) => b.key!.compareTo(a.key!));

                  }
                });
              },
              itemBuilder: (context) => [
                _buildMenuItem(context,0, AppLocalizations.of(context)!.sortByNameAscending,_filterAscending),
                _buildMenuItem(context,1, AppLocalizations.of(context)!.sortByNameDescending,!_filterAscending),
                ]
            ),
       ]),
        const SizedBox(
          height: 10,
        ),
        _buildBooks()
      ],
    );
  }

  PopupMenuItem<int> _buildMenuItem(
      BuildContext context, int value, String text, bool isSelected) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Theme
                  .of(context)
                  .colorScheme
                  .primary
                  : Theme.of(context).primaryColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Icon(Icons.check, color: Theme
                .of(context)
                .colorScheme
                .primary),
        ],
      ),
    );
  }

  Widget _buildBooks() {
    return ListView.builder(
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: _filterListTome.length,
        itemBuilder: (context, index) {
          var i = NetworkImage(_filterListTome[index].cover!,
              headers: {'Access-Control-Allow-Origin': '*'});
          var fullTitle = _filterListTome[index].tomeName ??
              AppLocalizations.of(context)!.unknowTitle;
          String title, tome;
          // if (fullTitle.contains(' - ')) {
          //   var parts = fullTitle.split(' - ');
          //   title = parts[0];
          //   tome = parts.length > 1 ? parts[1] : '';
          // } else {
          //   title = fullTitle;
          //   tome = '';
          // }
          title = fullTitle;

          OwnedTome? serieIsOwned;
          try {
            serieIsOwned = widget.ownedTome.firstWhere((element) {
              bool is13 = element.isbn!.trim().replaceAll("-", "").length == 13;
              return is13
                  ? element.isbn == _filterListTome[index].isbn13
                  : element.isbn == _filterListTome[index].isbn10;
            });
          } catch (e) {
            serieIsOwned = null;
          }

          int readingStatus = serieIsOwned?.readingStatus ?? 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                print(title);
                Navigator.pushNamed(
                  context,
                  '/tome-details',
                  arguments: {
                    'tome': _filterListTome[index],
                    'serie': widget.series,
                    'ownedTomes': widget.ownedTome
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 16, left: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundDecoration: serieIsOwned == null
                    ? BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: Image(
                              image: i,
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 22),
                                ),
                                // Text(
                                //   tome,
                                //   style: const TextStyle(
                                //       fontWeight: FontWeight.w400, fontSize: 18),
                                // ),
                                Text(
                                  readingStatus == 1
                                      ? AppLocalizations.of(context)!
                                          .currentlyReading
                                      : "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w200, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 24,
                  ),
                ]),
              ),
            ),
          );
        });
  }

  AppBar _appBarBuilder(BuildContext context) {
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
      actions: [
        IconButton(
          icon: const Icon(
            Icons.share,
            size: 24,
          ),
          onPressed: () {
            print('share pressed ...');
          },
        ),
      ],
    );
  }
}
