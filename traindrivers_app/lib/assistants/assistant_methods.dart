import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traindrivers_app/assistants/request_assistant.dart';

import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/direction_details_info.dart';
import '../models/directions.dart';
import '../models/user_model.dart';


class AssistantMethods {


  static Future<String> searchAddressForGeographicCoOrdinates(Position position,
      context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position
        .latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";
    var requestResponse = await RequestAssistant.recieveRequests(apiUrl);
    if (requestResponse != "error try again!") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(
          userPickUpAddress);
    }
    return humanReadableAddress;
  }


  static void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
        print("name = " + userModelCurrentInfo!.name.toString());
        print("email = " + userModelCurrentInfo!.email.toString());
      }
    });
  }

  static Future<
      DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(
      LatLng originPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition
        .latitude},${originPosition.longitude}&destination=${destinationPosition
        .latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.recieveRequests(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "error try again!") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
    responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    directionDetailsInfo.distants_text =
    responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
    responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];


    directionDetailsInfo.duration_text =
    responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
    responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }


  static pauseLiveLocationUpdate() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdate() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(
        currentFirebaseUser!.uid, driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude);
  }

  static double calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo
        .duration_value! / 600) * 0.1;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo
        .duration_value! / 1000) * 0.1;

    // price in srilankan rupee
    double totalFareAmount = timeTraveledFareAmountPerMinute +
        distanceTraveledFareAmountPerKilometer;
    double localCurrencyTotalFare = totalFareAmount * 320;


    if (driverTrainType == "mail") {
      double resultFareAmount = (totalFareAmount.truncate()) / 2.0;
      return resultFareAmount;
    }

    else if (driverTrainType == "shorttrip") {
      return totalFareAmount.truncate().toDouble();
    }

    else if (driverTrainType == "longtrip") {
      double resultFareAmount = (totalFareAmount.truncate()) * 2.0;
      return resultFareAmount;
    }

    else {
      return totalFareAmount.truncate().toDouble();
    }
  }
}