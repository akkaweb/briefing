import 'dart:async';
import 'package:briefing/base/base_stateless.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:flutter/material.dart';
import 'package:briefing/util/pair.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:briefing/viewmodels/news_viewmodel.dart';
import 'package:briefing/base/keep_state.dart';
import 'package:briefing/widget/news_widget.dart';
import 'package:briefing/theme/theme.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';

class NewsByCategoryPage extends BaseStateless {
  int _id;
  bool isCategory = true;
  String title = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: this.title,
      theme: buildAppTheme(),
      home: NewsByCategory(_id, title: this.title, isCategory: isCategory),
    );
  }

  NewsByCategoryPage(this._id, {this.isCategory, this.title});
}

class NewsByCategory extends StatefulWidget {
  int _id;
  bool isCategory = true;
  String title = "";

  NewsByCategory(this._id, {this.isCategory = true, this.title, Key key}) : super(key: key);

  @override
  _NewsByCategoryState createState() => _NewsByCategoryState(this._id, isCategory: this.isCategory);
}

class _NewsByCategoryState extends KeepState<NewsByCategory> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  NewsViewModel _viewModel;
  int _id;
  bool isCategory = true;
  String title = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationService _navigationService = locator<NavigationService>();

  _NewsByCategoryState(this._id, {this.isCategory = true, this.title}) {
    _viewModel = NewsViewModel(isNeedLoadCategory: false, id: _id);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
  }

  Future<void> _onRefresh() async {
    setState(() {
      _refreshIndicatorKey?.currentState?.show();
    });
    await _viewModel.getNews(_id, isRefresh: true);
  }

  void _onLoadmore() {
    _viewModel.getNews(_id, isLoadmore: true);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ChangeNotifierProvider(
            builder: (context) => _viewModel,
            child: Consumer<NewsViewModel>(
                builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle(
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                      statusBarColor: Theme.of(context).primaryColor,
                      systemNavigationBarColor: Colors.white,
                      systemNavigationBarIconBrightness: Brightness.dark,
                    ),
                    child: Scaffold(
                        appBar: AppBar(
                          title: Text(
                            widget.title,
                            style:
                                Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          leading: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              semanticLabel: 'back',
                            ),
                            onPressed: () {
                              _navigationService.goBack();
                            },
                          ),
                        ),
                        key: _scaffoldKey,
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: RefreshIndicator(
                              key: _refreshIndicatorKey,
                              displacement: 5.0,
                              backgroundColor: Colors.white,
                              onRefresh: _onRefresh,
                              child: model.listNews?.isNotEmpty == true
                                  ? NotificationListener<ScrollNotification>(
                                      onNotification: (ScrollNotification scrollInfo) {
                                        if (!model.busy &&
                                            model.listNews?.isNotEmpty == true &&
                                            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
                                          _onLoadmore();
                                        }
                                        return false;
                                      },
                                      child: ListView.separated(
                                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                        itemCount: model.listNews.length + (model.canLoadmore ? 1 : 0),
                                        separatorBuilder: (BuildContext context, int index) {
                                          return Divider();
                                        },
                                        itemBuilder: (BuildContext context, int index) {
                                          int size = model.listNews.length;
                                          return (model.canLoadmore && index == size)
                                              ? LoadingView()
                                              : BriefingCard(article: model.listNews.elementAt(index));
                                        },
                                      ))
                                  : model.hasErrorMessage
                                      ? Center(
                                          child: GestureDetector(
                                            onTap: _onRefresh,
                                            child: ErrorWidget(message: ['${model.errorMessage}']),
                                          ),
                                        )
                                      : LoadingView(),
                            ))
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
          Text('Woops...', style: Theme.of(context).textTheme.subhead, textAlign: TextAlign.center),
          Text(
            message.join('\n'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.w600),
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
