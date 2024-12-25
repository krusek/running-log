import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runninglog/providers/firestore_holder.dart';

class Splash extends StatelessWidget {
  final Widget child;
  Splash({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirestoreHolder>(context);
    return FutureBuilder<bool>(
      future: firestore.loading,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return child;
        }
        return Text('Loading');
      },
    );
  }
}
