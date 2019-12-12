import 'dart:async';

import 'package:briefing/viewmodels/videos_viewmodel.dart';
import 'package:briefing/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';

class VideoList extends StatefulWidget {
  ///The duration to be used for throttling the scroll notification.
  ///Defaults to 200 milliseconds.
  final Duration throttleDuration;

  const VideoList({
    Key key,
    this.throttleDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  VideoViewModel _viewModel = VideoViewModel();
  StreamController<ScrollNotification> _streamController;
  InViewState _inViewState;

  ///The function that is invoked when the list scroll reaches the end
  ///or the [endNotificationOffset] if provided.
  final VoidCallback onListEndReached = () {};

  final double endNotificationOffset = 0.0;
  final int contextCacheCount = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    _initializeInViewState();

    _startListening();
  }

  @override
  void didUpdateWidget(VideoList oldWidget) {
    if (oldWidget.throttleDuration != widget.throttleDuration) {
      //when throttle duration changes, close the existing stream controller if exists
      //and start listening to a stream that is throttled by new duration.
      _streamController?.close();
      _startListening();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _startListening() {
    _streamController = StreamController<ScrollNotification>();

    _streamController.stream
        .transform(throttle(widget.throttleDuration))
        .listen(_inViewState.onScroll);
  }

  void _initializeInViewState() {
    _inViewState = InViewState(
      intialIds: [0],
      isInViewCondition:
          (double deltaTop, double deltaBottom, double viewPortDimension) {
        return deltaTop >= 0;
      },
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _refreshIndicatorKey.currentState?.show();
    });
    await _viewModel.getVideos(isRefresh: true);
  }

  void _onLoadmore() {
    _viewModel.getVideos(isLoadmore: true);
  }

  @override
  void dispose() {
    _inViewState?.dispose();
    _inViewState = null;
    _streamController?.close();
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
            child: Consumer<VideoViewModel>(
              builder: (context, model, child) => (model.listVideos != null &&
                      model.listVideos?.isNotEmpty == true)
                  ? RefreshIndicator(
                      key: _refreshIndicatorKey,
                      displacement: 5.0,
                      backgroundColor: Colors.white,
                      onRefresh: _onRefresh,
                      child: _InheritedInViewWidget(
                          child: NotificationListener<ScrollNotification>(
                              onNotification:
                                  (ScrollNotification notification) {
                                if (!model.busy &&
                                    model.listVideos != null &&
                                    model.listVideos?.isNotEmpty == true &&
                                    notification.metrics.pixels >=
                                        notification.metrics.maxScrollExtent -
                                            100) {
                                  _onLoadmore();
                                }
                                bool isScrollDirection;
                                //the direction of user scroll up, down, left, right.
                                final AxisDirection scrollDirection =
                                    notification.metrics.axisDirection;

                                isScrollDirection =
                                    scrollDirection == AxisDirection.down ||
                                        scrollDirection == AxisDirection.up;

                                final double maxScroll =
                                    notification.metrics.maxScrollExtent;

                                //end of the listview reached
                                if (isScrollDirection &&
                                    maxScroll - notification.metrics.pixels <=
                                        endNotificationOffset) {
                                  if (onListEndReached != null) {
                                    onListEndReached();
                                  }
                                }
                                //when user is not scrolling
                                if (notification is UserScrollNotification &&
                                    notification.direction ==
                                        ScrollDirection.idle) {
                                  //Keeps only the last number contexts provided by user. This prevents overcalculation
                                  //by iterating over non visible widget contexts in scroll listener
                                  _inViewState
                                      .removeContexts(contextCacheCount);

                                  if (!_streamController.isClosed &&
                                      isScrollDirection) {
                                    _streamController.add(notification);
                                  }
                                }

                                if (!_streamController.isClosed &&
                                    isScrollDirection) {
                                  _streamController.add(notification);
                                }
                                return true;
                              },
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 18.0),
                                shrinkWrap: true,
                                itemCount: model.listVideos.length +
                                    (model.canLoadmore ? 1 : 0),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  int size = model.listVideos.length;
                                  return (model.canLoadmore && index == size)
                                      ? Center(
                                          child: Container(
                                          margin: EdgeInsets.all(16.0),
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(),
                                        ))
                                      : AnimatedBuilder(
                                          animation: _inViewState,
                                          builder: (BuildContext context,
                                              Widget child) {
                                            _inViewState?.addContext(
                                                context: context, id: index);
                                            return VideoCard(
                                                article: model.listVideos
                                                    .elementAt(index),
                                              isPlaying: _inViewState?.inView(index),);
                                          });
                                },
                              ))))
                  : model.hasErrorMessage
                      ? Center(
                          child: GestureDetector(
                            onTap: _onRefresh,
                            child:
                                ErrorWidget(message: ['${model.errorMessage}']),
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

//This widget passes down the InViewState down the widget tree;
class _InheritedInViewWidget extends InheritedWidget {
  final InViewState inViewState;
  final Widget child;

  _InheritedInViewWidget({Key key, this.inViewState, this.child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedInViewWidget oldWidget) => false;
}

class _WidgetData {
  final BuildContext context;
  final int id;

  _WidgetData({@required this.context, @required this.id});
}

///Class that stores the context's of the widgets and String id's of the widgets that are
///currently in-view. It notifies the listeners when the list is scrolled.
class InViewState extends ChangeNotifier {
  ///The context's of the widgets in the listview that the user expects a
  ///notification whether it is in-view or not.
  Set<_WidgetData> _contexts;

  ///The String id's of the widgets in the listview that the user expects a
  ///notification whether it is in-view or not. This helps to make recognition easy.
  List<int> _currentInViewIds = [];
  final IsInViewPortCondition isInViewCondition;

  InViewState({List<int> intialIds, this.isInViewCondition}){
    _contexts = Set<_WidgetData>();
    _currentInViewIds.addAll(intialIds);
  }

  ///Number of widgets that are currently in-view.
  int get inViewWidgetIdsLength => _currentInViewIds.length;

  int get numberOfContextStored => _contexts.length;

  ///Add the widget's context and an unique string id that needs to be notified.
  void addContext({@required BuildContext context, @required int id}) {
    _contexts.add(_WidgetData(context: context, id: id));
  }

  ///Keeps the number of widget's contexts the InViewNotifierList should stored/cached for
  ///the calculations thats needed to be done to check if the widgets are inView or not.
  ///Defaults to 10 and should be greater than 1. This is done to reduce the number of calculations being performed.
  void removeContexts(int letRemain) {
    if (_contexts.length > letRemain) {
      _contexts = _contexts.skip(_contexts.length - letRemain).toSet();
    }
  }

  ///Checks if the widget with the `id` is currently in-view or not.
  bool inView(int id) {
    return _currentInViewIds.contains(id);
  }

  ///The listener that is called when the list view is scrolled.
  void onScroll(ScrollNotification notification) {
    // Iterate through each item to check
    // whether it is in the viewport
    final listContext = _contexts.toList();
    listContext.sort((a, b) => a.id.compareTo(b.id));
    for(_WidgetData item in listContext) {
      // Retrieve the RenderObject, linked to a specific item
      final RenderObject renderObject = item.context.findRenderObject();

      // If none was to be found, or if not attached, leave by now
      if (renderObject == null || !renderObject.attached) {
        continue;
      }

      //Retrieve the viewport related to the scroll area
      final RenderAbstractViewport viewport =
          RenderAbstractViewport.of(renderObject);
      final double vpHeight = notification.metrics.viewportDimension;
      final RevealedOffset vpOffset =
          viewport.getOffsetToReveal(renderObject, 0.0);

      // Retrieve the dimensions of the item
      final Size size = renderObject?.semanticBounds?.size;

      //distance from top of the widget to top of the viewport
      final double deltaTop = vpOffset.offset - notification.metrics.pixels;

      //distance from bottom of the widget to top of the viewport
      final double deltaBottom = deltaTop + size.height;
      bool isInViewport = false;

      //Check if the item is in the viewport by evaluating the provided widget's isInViewPortCondition condition.
      isInViewport = isInViewCondition(deltaTop, deltaBottom, vpHeight);

      if (isInViewport) {
        if(_currentInViewIds.contains(item.id)) {
          notifyListeners();
          break;
        }
        _currentInViewIds.clear();
        _currentInViewIds.add(item.id);
        notifyListeners();
        break;
      }
    }
  }
}

///The function that defines the area within which the widgets should be notified
///as inView.
typedef bool IsInViewPortCondition(
  double deltaTop,
  double deltaBottom,
  double viewPortDimension,
);
