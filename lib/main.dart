import 'package:briefing/base/base_stateless.dart';
import 'package:briefing/bookmarked_article_list.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/news_list.dart';
import 'package:briefing/video_list.dart';
import 'package:briefing/tv_list.dart';
import 'package:briefing/schedule.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:briefing/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:briefing/base/keep_state.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends BaseStateless {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Báo đây',
        theme: buildAppTheme(),
        navigatorKey: locator<NavigationService>().navigationKey,
        onGenerateRoute: generateRouter,
        initialRoute: Router.Home);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends KeepState<MyHomePage> {
  int _selectedIndex = 0;
  final menus = [Menu.local, Menu.headlines, Menu.favorites, Menu.agencies];

  PageStorage _getNewsScreen() {
    if (_newsScreen == null) {
      _newsScreen = PageStorage(
          bucket: _bucket, child: NewsList(key: PageStorageKey("NewsList")));
    }
    return _newsScreen;
  }

  PageStorage _newsScreen;

  PageStorage _getVideoScreen() {
    if (_videoScreen == null) {
      _videoScreen = PageStorage(
          bucket: _bucket, child: VideoList(key: PageStorageKey("VideoScreen")));
    }
    return _videoScreen;
  }

  PageStorage _videoScreen;

  PageStorage _getLiveScreen() {
    if (_liveScreen == null) {
      _liveScreen = PageStorage(
          bucket: _bucket, child: ScheduleScreen(key: PageStorageKey("LiveScreen")));
    }
    return _liveScreen;
  }

  PageStorage _liveScreen;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static final PageStorageBucket _bucket = PageStorageBucket();
  final PageController _pageController = PageController(keepPage: true);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Theme.of(context).primaryColor,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return PageStorage(
      key: PageStorageKey("Main"),
      bucket: _bucket,
            child: DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        body: PageView(
          controller: _pageController,
          onPageChanged: _pageChanged,
          children: <Widget>[
            _getNewsScreen(),
            _getVideoScreen(),
            BookmarkArticleList(
              key: PageStorageKey("Bookmark"),
            ),
            _getLiveScreen()
          ],
        ),
        appBar: AppBar(
          title: Text("Báo Đây"),
          elevation: 1,
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).accentColor,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).primaryColor,
          selectedFontSize: 12.0,
          unselectedFontSize: 10.0,
          iconSize: 20,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books), title: Text('Tin tức')),
            BottomNavigationBarItem(
                icon: Icon(Icons.personal_video), title: Text('Videos')),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border), title: Text('Đã lưu')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Live TV'))
          ],
        ),
      ),
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
