import 'package:cloud_firestore/cloud_firestore.dart';

class Shoe {
  final double miles;
  final String name;
  final String path;
  Shoe.from({this.path, Map<String, dynamic> document})
      : this.miles = document['miles'],
        this.name = document['name'];
}

class Run {
  final double distance;
  final int duration;
  final String shoe;
  final DateTime date;
  final String path;
  Run.from({this.path, Map<String, dynamic> document})
      : this.distance = document['distance'],
        this.duration = document['duration'],
        this.shoe = document['shoe'],
        this.date = document['date']?.toDate();
}

class Extra {
  final double totalDistance;
  final String path;
  Extra.from({this.path, Map<String, dynamic> document}) : this.totalDistance = document['total_distance'];
}
