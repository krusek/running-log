import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:runninglog/model/shoe.dart';
import 'package:runninglog/providers/firestore_holder.dart';

class ShoesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final holder = FirestoreHolder.of(context);
    return StreamBuilder<List<Shoe>>(
      initialData: [],
      stream: holder.shoes,
      builder: (context, data) {
        if (!data.hasData) return Container();
        return ListView.builder(
          itemCount: data.data.length,
          itemBuilder: (context, idx) {
            final item = data.data[idx];
            return ListTile(
              title: Text(item.name),
              subtitle: Text('${item.miles} miles'),
              trailing: Icon(
                FlutterIcons.foot_print_mco,
                color: item.color,
              ),
            );
          },
        );
      },
    );
  }
}
