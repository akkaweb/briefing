import 'dart:async';

import 'package:briefing/widget/live_tv_card.dart';
import 'package:briefing/briefing_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:briefing/viewmodels/tv_viewmodel.dart';
import 'package:briefing/base/keep_state.dart';

class ScheduleScreen extends StatefulWidget {
    const ScheduleScreen({Key key}) : super(key: key);

    @override
    _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends KeepState<ScheduleScreen> {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    TVViewModel _viewModel = TVViewModel();

    @override
    void initState() {
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    }

    Future<void> _onRefresh() async {
        setState(() {
            _refreshIndicatorKey.currentState?.show();
        });
        await _viewModel.getTV();
    }

    void _onLoadmore() {
        _viewModel.getTV();
    }

    @override
    void dispose() {
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: ChangeNotifierProvider(
                        builder: (context) => _viewModel,
                        child: Consumer<TVViewModel>(
                            builder: (context, model, child) => (model.listVideos != null && model.listVideos?.isNotEmpty == true)
                                    ? RefreshIndicator(
                                    key: _refreshIndicatorKey,
                                    displacement: 5.0,
                                    backgroundColor: Colors.white,
                                    onRefresh: _onRefresh,
                                    child: NotificationListener<ScrollNotification>(
                                            onNotification: (ScrollNotification scrollInfo) {
                                                if (!model.busy &&
                                                        model.listVideos != null &&
                                                        model.listVideos?.isNotEmpty == true &&
                                                        scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
                                                    _onLoadmore();
                                                }
                                                return false;
                                            },
                                            child: ListView.separated(
                                                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                                shrinkWrap: true,
                                                itemCount: 20,
                                                separatorBuilder: (BuildContext context, int index) {
                                                    return Container(
                                                        height: 10,
                                                    );
                                                },
                                                itemBuilder: (BuildContext context, int index) {
                                                    int size = model.listVideos.length;
                                                    return ListView.separated(itemBuilder: (BuildContext context, int index) {
                                                        return ClipRRect(
                                                            borderRadius: new BorderRadius.circular(5.0),
                                                            child: Container(
                                                                height: 50,
                                                                padding: EdgeInsets.all(5.0),
                                                                child: Text("Phim truyện: số $index"),
                                                            ),
                                                        );
                                                        }, separatorBuilder: (BuildContext context, int index) {
                                                        return Container(
                                                            width: 10,
                                                        );
                                                    }, itemCount: 20, shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,);
                                                },
                                            )))
                                    : model.hasErrorMessage
                                    ? Center(
                                child: GestureDetector(
                                    onTap: _onRefresh,
                                    child: ErrorWidget(message: ['${model.errorMessage}']),
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
                        )));
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
