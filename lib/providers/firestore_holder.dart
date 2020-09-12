import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:runninglog/model/shoe.dart';
import 'package:rxdart/rxdart.dart';

/// In order for the firestore to work the file `assets/firestore.json`
/// needs to be provided. See [FirestoreHolder._load] to see what is
/// expected in that json file.
class FirestoreHolder {
  FirebaseFirestore _firestore;
  Future _loader;

  final BehaviorSubject<List<Shoe>> _shoes = BehaviorSubject();
  StreamSubscription _shoeSubscription;
  final BehaviorSubject<List<Run>> _runs = BehaviorSubject();
  StreamSubscription _runSubscription;
  final BehaviorSubject<Extra> _extra = BehaviorSubject();
  StreamSubscription _extraSubscription;

  FirestoreHolder();

  Future<void> _load(BuildContext context) async {
    FirebaseApp app = await Firebase.initializeApp();
    print(app.name);
    _firestore = FirebaseFirestore.instance;
    final shoes = _firestore.collection('users/korben/shoes');
    _shoeSubscription = shoes.snapshots().listen((event) {
      final shoes = event.docs.map((e) => Shoe.from(path: e.reference.path, document: e.data())).toList();
      _shoes.add(shoes);
    });

    final runs = _firestore.collection('users/korben/runs');
    _runSubscription = runs.snapshots().listen((event) {
      final runs = event.docs.map((e) => Run.from(path: e.reference.path, document: e.data())).toList();
      _runs.add(runs);
    });

    final extra = _firestore.doc('users/korben/extra/extra');
    _extraSubscription = extra.snapshots().listen((event) {
      final extra = Extra.from(path: event.reference.path, document: event.data());
      _extra.add(extra);
    });
  }

  FirebaseFirestore get instance => _firestore;

  Future loader(BuildContext context) {
    if (_loader != null) return _loader;
    _loader = _load(context);
    return _loader;
  }

  Stream<List<Shoe>> get shoes => _shoes.stream;
  Stream<List<Run>> get runs => _runs.stream;
  Stream<Extra> get extra => _extra.stream;

  dispose() {
    _shoeSubscription?.cancel();
    _runSubscription?.cancel();
    _extraSubscription?.cancel();
  }
}
