import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/models/article.dart';
import 'package:flutter_news/services/article_api.dart';
import 'package:flutter_news/ui/article_item.dart';
import 'package:flutter_news/util/topics.dart';

class NewScreen extends StatefulWidget {
  final ArticleApi articleApi;
  const NewScreen({Key? key, required this.articleApi}) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  late String _topicName;

  @override
  void initState() {
    _topicName = topics[0].name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildTopics(context),
          SizedBox(height: 20),
          _buildArticles(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      title: RichText(
        text: TextSpan(
          text: 'Flutter',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          children: const <TextSpan>[
            TextSpan(
              text: 'News',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildTopics(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: topics.length,
      itemBuilder: (_, index, realIndex) {
        return InkWell(
          onTap: () {
            if (_topicName.toLowerCase() != topics[index].name.toLowerCase()) {
              _topicName = topics[index].name;
              setState(() {});
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 2 / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(topics[index].backgroundUrl),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              topics[index].name,
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        aspectRatio: 2.2,
        autoPlay: true,
        autoPlayAnimationDuration: Duration(seconds: 1),
        autoPlayCurve: Curves.ease,
        autoPlayInterval: Duration(seconds: 2),
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        initialPage: 0,
        scrollDirection: Axis.horizontal,
        pauseAutoPlayOnTouch: true,
        viewportFraction: 0.8,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
      ),
    );
  }

  Widget _buildArticles(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: widget.articleApi.getListArticles(_topicName),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child:
                Text(snapshot.error.toString().replaceFirst('Exception: ', '')),
          );
        }
        List<Article> _list = snapshot.data!;
        if (_list.isEmpty) {
          return Center(
            child: Text('Danh sách rỗng'),
          );
        }
        return Column(
          children: List.generate(_list.length, (index) {
            return ArticleItem(article: _list[index]);
          }),
        );
      },
    );
  }
}
