import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:traindrivers_app/assistants/assistant_methods.dart';
import 'package:traindrivers_app/global/global.dart';
import 'package:traindrivers_app/mainScreens/new_trip_screen.dart';
import 'package:traindrivers_app/models/user_ride_request_information.dart';



class NotificationDialogBox extends StatefulWidget
{
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}




class _NotificationDialogBoxState extends State<NotificationDialogBox>
{
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 14,),

            Image.asset(
              "images/passenger.png",
              width: 160,
            ),

            const SizedBox(height: 10,),

            //title
            const Text(
              "New passenger waiting",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blue
              ),
            ),

            const SizedBox(height: 14.0),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            //addresses origin destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //origin location with icon
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 14,),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  //destination location with icon
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 14,),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            const Divider(
              height: 3,
              thickness: 3,
            ),

            //buttons cancel accept
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: ()
                    {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      //cancel the rideRequest
                      FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!
                          .rideRequestId!)
                          .remove().then((value)
                      {
                        FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus").set("idle");
                      }).then((value)
                      {
                        FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("tripsHistory").child(widget.userRideRequestDetails!.rideRequestId!).remove();
                      }).then((value)
                      {
                        Fluttertoast.showToast(msg: "Travel Cancelled. Restart App Now");
                      });

                      Future.delayed(const Duration(milliseconds: 2000), ()
                      {
                        SystemNavigator.pop();
                      });


                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: ()
                    {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      //accept the rideRequest

                      acceptRideRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context)
  {
    String getRideRequestId="";
    FirebaseDatabase.instance.ref().child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap)
    {
     if(snap.snapshot.value  != null)
     {
       getRideRequestId =  snap.snapshot.value.toString();
     }
     else
     {
       Fluttertoast.showToast(msg: "this request not available");


     }


     if(getRideRequestId == widget.userRideRequestDetails!.rideRequestId)
     {
       FirebaseDatabase.instance.ref().child("drivers")
           .child(currentFirebaseUser!.uid)
           .child("newRideRequest").set("accepted");


       AssistantMethods.pauseLiveLocationUpdate();


       Navigator.push(context, MaterialPageRoute(builder: (c)=>NewTripScreen(userRideRequestDetails: widget.userRideRequestDetails, )));


     }

     else
     {
       Fluttertoast.showToast(msg: "this ride request do not exist");
     }


    });
  }
}
