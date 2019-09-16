import 'package:briefing/base/base_stateless.dart';
import 'package:briefing/bookmarked_article_list.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/news_list.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:briefing/theme/theme.dart';
import 'package:briefing/video_list.dart';
import 'package:briefing/widget/main_sliverappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final menus = [Menu.local, Menu.headlines, Menu.favorites, Menu.agencies];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Theme.of(context).primaryColor,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    Widget getScreen() {
      if (menus[_selectedIndex] == Menu.favorites) {
        return BookmarkArticleList();
      }
      if (menus[_selectedIndex] == Menu.local) {
        return NewsList(menu: menus[0]);
      }
      if (menus[_selectedIndex] == Menu.headlines) {
        return VideoList();
      }
      return SliverList(
          delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Center(
            child: Text('Agencies(sources) comming soon...',
                style: TextStyle(fontSize: 22)),
          ),
        )
      ]));
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Theme.of(context).primaryColor,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            MainSliverAppBar(title: 'Báo Đây'),
            getScreen(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey[100],
                  offset: Offset(-2.0, 2.0),
                  blurRadius: 2.0,
                  spreadRadius: 2.0)
            ]),
            height: 60.0,
            child: BottomNavigationBar(
              selectedItemColor: Theme.of(context).accentColor,
              currentIndex: _selectedIndex,
              onTap: (val) => _onItemTapped(val),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).primaryColor,
              selectedFontSize: 14.0,
              unselectedFontSize: 12.0,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_books), title: Text('Tin tức')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.personal_video), title: Text('Videos')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_border), title: Text('Đã lưu')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('Cài đặt'))
              ],
              elevation: 5.0,
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
//    Navigator.pop(context);
  }
}
