import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traindrivers_app/main.dart';
import 'package:traindrivers_app/push_notifications/push_notification_system.dart';
import '../assistants/assistant_methods.dart';
import '../assistants/black_theme_google_map.dart';
import '../global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}



class _HomeTabPageState extends State<HomeTabPage>
{
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;



  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;







  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(driverCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);
  }


  readCurrentDriverInformation() async
  {
    currentFirebaseUser = fAuth.currentUser;
    
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((snap)
    {
     if(snap.snapshot.value != null)
     {
       onlineDriverData.id =  (snap.snapshot.value as Map)["id"];
       onlineDriverData.name = (snap.snapshot.value as Map)["name"];
       onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
       onlineDriverData.email = (snap.snapshot.value as Map)["email"];
       onlineDriverData.train_destination =(snap.snapshot.value as Map)["train_details"]["train_destination"];
       onlineDriverData.train_model = (snap.snapshot.value as Map)["train_details"]["train_model"];
       onlineDriverData.train_name =(snap.snapshot.value as Map)["train_details"]["train_name"];

       driverTrainType =(snap.snapshot.value as Map)["train_details"]["type"];

       print("train details ::::::::");
       print(onlineDriverData.train_destination);
       print(onlineDriverData.train_model);
       print(onlineDriverData.train_name);

     }


    });
    
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generatingAndGetToken();
  }


  @override
  void initState()
  {
    super.initState();

    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller)
      {
        _controllerGoogleMap.complete(controller);
        newGoogleMapController = controller;

        //black theme google map
        blackThemeGoogleMap(newGoogleMapController);

        locateDriverPosition();
      },
    ),
      //traindriver online status

        statusText != "Now Online" ? Container(

          height: MediaQuery.of(context).size.height ,
          width: double.infinity,
          color: Colors.white60,
        ) : Container(),

         //online offline status button

        Positioned(
          top: statusText != "Now Online" ? MediaQuery.of(context).size.height * 0.70 : 25,
          left: 0,
          right: 0,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: ()
                {




                 if(isDriverActive != true)
                 {

                   driverIsOnlineNow();


                   updateDriversLocationAtRealTime();


                   setState(() {
                       statusText = "Now Online";
                       isDriverActive = true;
                       buttonColor = Colors.transparent;

                   });
                          Fluttertoast.showToast(msg: "Train Started journey");

                 }

                 else
                 {
                   driverIsOffLineNow();
                   setState(() {
                     statusText = "Now Offline";
                     isDriverActive = false;
                     buttonColor = Color(0xFFF44335);

                   });

                   Fluttertoast.showToast(msg: "Train Arrived to the destination");
                 }





                },

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  )
                ),
                child: statusText != "Now Online" ? Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ) : const Icon(
                  Icons.phonelink_ring,
                  color: Colors.white,
                  size: 26,
                ) ,
              ),
            ],
          
          
          ),
        ),




        ],
      );
    }


    driverIsOnlineNow() async
    {

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      driverCurrentPosition = pos;
      Geofire.initialize("activeDrivers");
      Geofire.setLocation(currentFirebaseUser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus");


      ref.set("idle"); //ready to drive
      ref.onValue.listen((event) { });
      
    }
    updateDriversLocationAtRealTime()
    {
         streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position)
         {
           driverCurrentPosition = position;
           if(isDriverActive == true)
           {
             Geofire.setLocation(currentFirebaseUser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
           }

           LatLng latLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude,);

           newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));




         });
    }
    
  driverIsOffLineNow()
  {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 2000),()
    {
      //SystemChannels.platform.invokeListMethod("SystemNavigator.pop");
      MyApp.restartApp(context);
    });


  }


  }

