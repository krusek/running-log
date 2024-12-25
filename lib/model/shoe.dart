import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Shoe {
  final double miles;
  final String name;
  final String path;
  final Color color;
  Shoe.from({this.path, Map<String, dynamic> document})
      : this.miles = document['miles'],
        this.name = document['name'],
        this.color = Color(int.parse(document['color'].toString().substring(2), radix: 16));
}

class Run {
  final double distance;
  final int duration;
  final DocumentReference shoes;
  final DateTime date;
  final String path;
  Run.from({this.path, Map<String, dynamic> document})
      : this.distance = document['distance'],
        this.duration = document['duration'],
        this.shoes = document['shoes'],
        this.date = document['date']?.toDate();

  String get durationString {
    if (distance >= 60 * 60) {
      final hours = (duration / 3600).floor().toString();
      return '$hours:${_distanceMinutes(duration % 3600, forcePadding: true)}';
    } else {
      return _distanceMinutes(duration);
    }
  }

  String _distanceMinutes(int seconds, {bool forcePadding = false}) {
    var minutes = (seconds / 60).floor().toString();
    minutes = forcePadding ? minutes.padLeft(2, '0') : minutes;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$s';
  }

  String get paceString {
    if (duration == 0) return '--';
    final time = (duration / distance).floor();
    return _distanceMinutes(time);
  }
}

class Extra {
  final double totalDistance;
  final String path;
  Extra.from({this.path, Map<String, dynamic> document}) : this.totalDistance = document['total_distance'];
}
