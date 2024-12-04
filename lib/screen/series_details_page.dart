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
                Image.network(series.cover! , width: 100, height: 150,),
                SizedBox(width: 24,),
                Column(
                  children: [
                    _buildHeaderSection(context),
                    SizedBox(height: 10,),
                    _buildGenresSection(context),
                    SizedBox(height: 10,),
                  ],
                ),
              ],
            ),
            Divider(),
            _buildAuthorsSection(context),
            SizedBox(height: 10,),
            Divider(),
            _buildBooksSection(context)
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(context) {
    return Text(series.title!,                             
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    );
  }

  Widget _buildGenresSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Catégories", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.start,
          verticalDirection: VerticalDirection.down,
          clipBehavior: Clip.none,
          children: _getGenresWidget()
         ),
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
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              genre,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
          ),
        ),
      );
    }

    return widgetList;
  }

  Widget _buildAuthorsSection(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contributeurs", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.start,
          verticalDirection: VerticalDirection.down,
          clipBehavior: Clip.none,
          children: _getGenresWidget()
         ),
      ],
    );;
  }

  Widget _buildBooksSection(context) {
    
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: series.books.length,
        itemBuilder: (_,index) {
          var i = NetworkImage(series.books[index].cover!, headers: {'Access-Control-Allow-Origin':'*'});

          return Container(child: Column(
            children: [
              Image(image: i),
              Text(series.books[index].title!),
            ],
          ),);
        }
      ),
    );
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