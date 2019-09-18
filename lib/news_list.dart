import 'dart:async';

import 'package:briefing/bloc/bloc_article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:flutter/material.dart';
import 'package:briefing/util/pair.dart';

class NewsList extends StatefulWidget {
  final Menu menu;

  const NewsList({Key key, this.menu}) : super(key: key);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ArticleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ArticleListBloc();
    _bloc.getCategory();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  Future<void> _onRefresh() async {
    await _bloc.refresh();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        StreamBuilder<Pair<List<Category>, int>>(
          stream: _bloc.categoryListObservable,
          initialData: Pair(List(), _bloc.categorySelected),
          builder: (context, snapshot) {
            return Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                elevation: 1.0,
                child: snapshot.data.first.isEmpty
                    ? Center(
                        child: Container(
                        margin: EdgeInsets.all(5.0),
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ))
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 12.0),
                        height: 30.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.first
                              .map(
                                (category) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ChoiceChip(
                                      selectedColor:
                                          Theme.of(context).accentColor,
                                      label: Text(category.name),
                                      selected:
                                          category.id == _bloc.categorySelected,
                                      onSelected: (val) {
                                        _refreshIndicatorKey.currentState
                                            .show();
                                        _bloc.categorySink.add(category.id);
                                      }),
                                ),
                              )
                              .toList(),
                        )));
          },
        ),
        StreamBuilder<List<Article>>(
            stream: _bloc.newsListObservable,
            initialData: List(),
            builder: (context, snapshot) {
              debugPrint("!!!snapshot state: ${snapshot.connectionState}!!!");
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                displacement: 5.0,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                child: snapshot.hasData && snapshot.data.length > 0
                    ? ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 18.0),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return BriefingCard(
                              article: snapshot.data.elementAt(index));
                        },
                      )
                    : snapshot.hasError
                        ? Center(
                            child: GestureDetector(
                              onTap: _onRefresh,
                              child:
                                  ErrorWidget(message: ['${snapshot.error}']),
                            ),
                          )
                        : Center(
                            child: Container(
                              margin: EdgeInsets.all(16.0),
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
              );
            }),
      ]),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final List<String> message;

  const ErrorWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 92.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.cloud_off, size: 55.0),
          Text('Woops...',
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center),
          Text(
            message.join('\n'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final Stream<bool> _isLoading;

  const LoadingWidget(this._isLoading);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _isLoading,
      initialData: true,
      builder: (context, snapshot) {
        debugPrint("_bloc.isLoading: ${snapshot.data}");
        return snapshot.data
            ? Center(
                child: Container(
                  margin: EdgeInsets.only(top: 92.0),
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
