import 'package:flutter/material.dart';
import 'package:manga_library/model/series.dart';

class SeriesDetailsPage extends StatelessWidget {
  final Series series;
  const SeriesDetailsPage({super.key, required this.series});

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
                  series.cover!,
                  width: 100,
                  height: 150,
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(context),
                      SizedBox(
                        height: 10,
                      ),
                      _buildGenresSection(context),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            _buildAuthorsSection(context),
            SizedBox(
              height: 10,
            ),
            Divider(),
            _buildBooksSection(context)
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(context) {
    return Text(
      series.title!,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 0),
    );
  }

  Widget _buildGenresSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Catégories",
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
    for (var genre in series.genresList!) {
      widgetList.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding:
                EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              genre,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
        Text("Contributeurs",
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
    for (var author in series.authorsList!) {
      widgetList.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding:
                EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Text(
                  author.fullName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  author.role,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widgetList;
  }

  Widget _buildBooksSection(context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Éditions",
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          Text('${series.nbBooks!} tomes',
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.grey)),
          SizedBox(
            height: 10,
          ),
          _buildBooks()
        ],
      ),
    );
  }

  Widget _buildBooks() {
    return ListView.builder(
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: series.books.length,
        itemBuilder: (_, index) {
          var i = NetworkImage(series.books[index].cover!,
              headers: {'Access-Control-Allow-Origin': '*'});
          var fullTitle = series.books[index].title ?? 'Titre inconnu';
          var title, tome;
          if (fullTitle.contains(' - ')) {
            var parts = fullTitle.split(' - ');
            title = parts[0];
            tome = parts.length > 1 ? parts[1] : '';
          } else {
            title = fullTitle;
            tome = '';
          }
          var readingStatus = series.books[index].readingStatus!;
          return InkWell(
            onTap: () {
              print(title);
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(12),
              ),
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
                                readingStatus,
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
