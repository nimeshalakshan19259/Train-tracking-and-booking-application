import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users_app/assistants/assistant_methods.dart';

import 'package:users_app/global/global.dart';


class SelectNearestActiveDriversScreen extends StatefulWidget
{

  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  _SelectNearestActiveDriversScreenState createState() => _SelectNearestActiveDriversScreenState();
}
class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen>
{
  String fareAmount = "";

  getFareAmountAccordingToVehicleType(int index)
  {
    if(tripDirectionDetailsInfo != null)
    {
      if(dList[index]["train_details"]["type"].toString() == "shorttrip")
      {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) / 2).toStringAsFixed(1);
      }
      if(dList[index]["train_details"]["type"].toString() == "longtrip")
          {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2).toStringAsFixed(1);
      }
      if(dList[index]["train_details"]["type"].toString() == "mail")
          {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)).toString();
      }
    }
    return fareAmount;
  }





  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Available Trains",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
              Icons.close, color: Colors.white
          ),
          onPressed: ()
          {

            widget.referenceRideRequest!.remove();
            //delete/remove the ride request from database

            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index)
        {
          return GestureDetector(
            onTap: ()
            {
              setState(() {
                chosenDriverId =  dList[index]["id"].toString();
              });
              Navigator.pop(context, "driverchoosed");



            },
            child: Card(
              color: Colors.blue,
              elevation: 3,
              shadowColor: Colors.green,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "images/" + dList[index]["train_details"]["type"].toString() + ".png",
                    width: 70,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["train_details"]["train_name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      dList[index]["train_details"]["train_destination"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),


                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "රු " + getFareAmountAccordingToVehicleType(index),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 12
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.distance_text! : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
