import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/progress_dialog.dart';

import '../assistants/request_assistant.dart';


class PlacePredictionTileDesign extends StatefulWidget {


  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeID, context) async
  {

    showDialog(context: context, builder: (BuildContext context) => ProgressDialog(
      message: "setting up Destination",
    ),

    );



   String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapKey";

  var responseApi = await RequestAssistant.recieveRequest(placeDirectionDetailsUrl);


  Navigator.pop(context);


  if(responseApi == "error try again!")
  {
    return;
  }
   if (responseApi["status"] == "OK")
   {
     Directions directions = Directions();
     directions.locationName = responseApi["result"]["name"];
     directions.locationId = placeID;
     directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
     directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];


    Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

    setState(() {
    userDropOffAddress =   directions.locationName!;
    });


    Navigator.pop(context, "obtainedDropoff");


     print("\nlocation name = " + directions.locationName!);
     print("\nlocation lat = " + directions.locationLatitude!.toString());
     print("\nlocation lng = " + directions.locationLongitude!.toString());




   }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton
      (
      onPressed: ()
      {
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);


      },




      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          children: [
          const  Icon(
              Icons.add_location,
              color: Colors.white,

            ),

            const SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0,),
                  Text(
                    widget.predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white54,

                    ),

                  ),

                  const SizedBox(height: 2.0,),
                  Text(
                    widget.predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,

                    ),

                  ),

                  const SizedBox(height: 8.0,),

                ],

              ),
            ),
          ],
        ),
      ),
    );
  }
}
