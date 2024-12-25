import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:runninglog/model/shoe.dart';
import 'package:runninglog/providers/firestore_holder.dart';

class RunsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final months = ['2020-09', '2020-08', '2020-07'];
    return ListView.builder(
      itemCount: months.length * 2,
      itemBuilder: (context, index) {
        final idx = (index / 2).floor();
        if (index % 2 == 0) {
          return _title(months[idx]);
        }
        return RunList(month: months[idx]);
      },
    );
  }

  Widget _title(String month) {
    final format = DateFormat('MMMM yyyy');
    final date = DateTime.parse(month + '-01');
    return Container(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(format.format(date)),
      ),
    );
  }
}

class RunList extends StatelessWidget {
  final String month;
  RunList({this.month});

  @override
  Widget build(BuildContext context) {
    final holder = FirestoreHolder.of(context);
    return StreamBuilder<List<Run>>(
      initialData: [],
      stream: holder.runs(month: month),
      builder: (context, data) {
        if (!data.hasData) return Container();
        return ListViewWithEmpty(
          shrinkWrap: true,
          itemCount: data.data.length,
          empty: _empty,
          itemBuilder: (context, idx) {
            final run = data.data[idx];
            print(run.shoes);
            final shoe = holder.shoe(reference: run.shoes);
            final title = run.duration != 0 ? '${run.distance} miles @ ${run.paceString}' : '${run.distance} miles';
            final format = DateFormat('MMMM d');
            return ListTile(
              leading: ShoeIcon(path: run.shoes.path),
              title: Text(title),
              subtitle: Text(format.format(run.date)),
              trailing: FutureBuilder<Shoe>(
                future: shoe,
                builder: (context, snapshot) {
                  final child = snapshot.hasData ? Text(snapshot.data.name) : Text('loading');
                  return AnimatedOpacity(
                    opacity: snapshot.hasData ? 1 : 0,
                    duration: Duration(milliseconds: 100),
                    child: child,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _empty(BuildContext context) {
    return ListTile(
      title: Text('No Runs'),
    );
  }
}

class ListViewWithEmpty extends StatelessWidget {
  final int itemCount;
  final bool shrinkWrap;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext) empty;
  ListViewWithEmpty({this.itemCount, this.shrinkWrap, this.itemBuilder, this.empty});

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return this.empty(context);
    }
    return ListView.builder(
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      shrinkWrap: shrinkWrap,
    );
  }
}

class ShoeIcon extends StatelessWidget {
  final Shoe shoe;
  final String path;
  ShoeIcon({this.shoe, this.path});

  @override
  Widget build(BuildContext context) {
    if (this.shoe != null) {
      return _icon(this.shoe.color);
    }

    final holder = FirestoreHolder.of(context);
    final shoe = holder.shoe(path: path);
    return Container(
      decoration: new BoxDecoration(
        color: Colors.black12.withAlpha(20),
        shape: BoxShape.circle,
      ),
      width: 80,
      height: 80,
      child: FutureBuilder<Shoe>(
        future: shoe,
        builder: (context, snapshot) {
          final child = snapshot.hasData ? _icon(snapshot.data.color) : _icon(Colors.black12);
          return AnimatedOpacity(
            opacity: snapshot.hasData ? 1 : 0,
            duration: Duration(milliseconds: 100),
            child: child,
          );
        },
      ),
    );
  }

  Widget _icon(Color color) {
    return Icon(FlutterIcons.foot_print_mco, color: color);
  }
}
