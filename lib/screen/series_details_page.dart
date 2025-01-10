import 'package:flutter/material.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/serie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SeriesDetailsPage extends StatelessWidget {
  final Serie series;
  final List<OwnedTome> ownedTome;
  const SeriesDetailsPage(
      {super.key, required this.series, required this.ownedTome});

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
                  series.mainCover!,
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
      series.name!,
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
    for (var genre in series.categories!) {
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
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
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
                series.author!,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
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
        Text(AppLocalizations.of(context)!.edition,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        Text('${series.nbVolume!} ${AppLocalizations.of(context)!.tome}',
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey)),
        const SizedBox(
          height: 10,
        ),
        _buildBooks()
      ],
    );
  }

  Widget _buildBooks() {
    return ListView.builder(
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: series.tomes!.length,
        itemBuilder: (context, index) {
          var i = NetworkImage(series.tomes![index].cover!,
              headers: {'Access-Control-Allow-Origin': '*'});
          var fullTitle = series.tomes![index].tomeName ??
              AppLocalizations.of(context)!.unknowTitle;
          String title, tome;
          if (fullTitle.contains(' - ')) {
            var parts = fullTitle.split(' - ');
            title = parts[0];
            tome = parts.length > 1 ? parts[1] : '';
          } else {
            title = fullTitle;
            tome = '';
          }

          OwnedTome? serieIsOwned;
          try {
            serieIsOwned = ownedTome.firstWhere((element) {
              bool is13 = element.isbn!.trim().replaceAll("-", "").length == 13;
              return is13
                  ? element.isbn == series.tomes![index].isbn13
                  : element.isbn == series.tomes![index].isbn10;
            });
          } catch (e) {
            serieIsOwned = null;
          }

          int readingStatus = serieIsOwned?.readingStatus ?? 0;

          return InkWell(
            onTap: () {
              print(title);
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 16, left: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundDecoration: serieIsOwned == null
                  ? BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
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
                              Text(
                                tome,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                              ),
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
