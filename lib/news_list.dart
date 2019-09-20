import 'dart:async';

import 'package:briefing/bloc/bloc_article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:flutter/material.dart';
import 'package:briefing/util/pair.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:briefing/viewmodels/news_viewmodel.dart';
import 'package:briefing/base/keep_state.dart';

class NewsList extends StatefulWidget {
  const NewsList({Key key}) : super(key: key);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends KeepState<NewsList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  NewsViewModel _viewModel = NewsViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  Future<void> _onRefresh() async {
    setState(() {
      _refreshIndicatorKey.currentState.show();
    });
    await _viewModel.getNews(_viewModel.cateSelected, isRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        displacement: 5.0,
        backgroundColor: Colors.white,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: new Container(
                color: Colors.white,
                child: ChangeNotifierProvider(
                    builder: (context) => _viewModel,
                    child: Consumer<NewsViewModel>(
                        builder: (context, model, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0)),
                                    elevation: 1.0,
                                    child: (model.listCategories?.isNotEmpty !=
                                            true)
                                        ? Center(
                                            child: Container(
                                            margin: EdgeInsets.all(10.0),
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(),
                                          ))
                                        : Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            height: 30.0,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView(
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              children: (model.listCategories ??
                                                      List())
                                                  .map(
                                                    (category) => Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4.0),
                                                      child: ChoiceChip(
                                                          selectedColor:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          label: Text(
                                                              category.name),
                                                          selected: category
                                                                  .id ==
                                                              model
                                                                  .cateSelected,
                                                          onSelected: (val) {
                                                            _refreshIndicatorKey
                                                                .currentState
                                                                .show();
                                                            model.getNews(
                                                                category.id);
                                                          }),
                                                    ),
                                                  )
                                                  .toList(),
                                            ))),
                                model.listNews?.isNotEmpty == true
                                    ? ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 18.0),
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: model.listNews.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider();
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return BriefingCard(
                                              article: model.listNews
                                                  .elementAt(index));
                                        },
                                      )
                                    : model.hasErrorMessage
                                        ? Center(
                                            child: GestureDetector(
                                              onTap: _onRefresh,
                                              child: ErrorWidget(message: [
                                                '${model.errorMessage}'
                                              ]),
                                            ),
                                          )
                                        : Center(
                                            child: Container(
                                              margin: EdgeInsets.all(16.0),
                                              width: 30,
                                              height: 30,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                              ],
                            ))))));
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
