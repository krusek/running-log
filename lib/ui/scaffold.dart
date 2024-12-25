import 'package:flutter/material.dart';
import 'package:runninglog/ui/runs.dart';
import 'package:runninglog/ui/shoes.dart';

class TabScaffold extends StatefulWidget {
  @override
  _TabScaffoldState createState() => _TabScaffoldState(builder: (context, index) {
        switch (index) {
          case 0:
            return RunsPage();
          case 1:
            return ShoesPage();
          default:
            return RunsPage();
        }
      }, title: (index) {
        switch (index) {
          case 0:
            print(Colors.green.shade500.toString());
            return 'Running Log';
          case 1:
            return 'Shoes';
          default:
            return 'Running Log';
        }
      }, actions: (context, index) {
        switch (index) {
          default:
            return [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed('add_run');
                },
              ),
            ];
        }
      });
}

class _TabScaffoldState extends State<TabScaffold> {
  int _currentTab = 0;
  final Widget Function(BuildContext, int) builder;
  final String Function(int) title;
  final List<Widget> Function(BuildContext, int) actions;

  _TabScaffoldState({this.builder, this.title, this.actions});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title(_currentTab)),
        actions: actions(context, _currentTab),
      ),
      body: builder(context, _currentTab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (idx) {
          setState(() {
            _currentTab = idx;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), title: Text('runs')),
          BottomNavigationBarItem(icon: Icon(Icons.sports), title: Text('shoes')),
          BottomNavigationBarItem(icon: Icon(Icons.sports), title: Text('runs')),
        ],
      ),
    );
  }
}
