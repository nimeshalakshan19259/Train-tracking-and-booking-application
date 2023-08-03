import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel
{
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? train_details;
  String? driverName;

  TripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.train_details,
    this.driverName,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    train_details = (dataSnapshot.value as Map)["train_details"];
    driverName = (dataSnapshot.value as Map)["driverName"];
  }
}