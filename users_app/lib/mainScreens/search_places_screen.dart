import 'package:flutter/material.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {


  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {


  List<PredictedPlaces> placesPredictedList = [];





  void findPlaceAutoCompleteSearch(String inputText) async
  {
    if(inputText.length > 1)
    {
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:LK";

      var responseAutoCompleteSearch = await RequestAssistant.recieveRequest(urlAutoCompleteSearch);


      if(responseAutoCompleteSearch == "error try again!")
      {
        return;
      }

      if(responseAutoCompleteSearch["status"] == "OK")
      {
       var placesPredictions = responseAutoCompleteSearch["predictions"];


      var placePredictionList =  (placesPredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();



                     setState(() {
                       placesPredictedList =  placePredictionList;
                     });


      }

    }

  }


  @override
  Widget build(BuildContext context)

  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search place page ui
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.blue,
              boxShadow:
              [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,

                  ),
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [

                  const SizedBox(height: 30.0),

                  Stack(
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),

                     const Center(
                        child: Text(
                          "Select Location",
                          style: TextStyle(
                            fontSize: 24.0, color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 20.0),

                  Row(
                    children: [
                     const Icon(
                          Icons.adjust_sharp,
                        color: Colors.white,
                      ),

                    const SizedBox(width: 10.0,),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            onChanged:(valueTyped)
                            {
                              findPlaceAutoCompleteSearch(valueTyped);

                            } ,
                           decoration: const InputDecoration(
                             hintText: "Search",
                             fillColor: Colors.white54,
                             filled: true,
                             border: InputBorder.none,
                             contentPadding: EdgeInsets.only(
                               left: 11.0,
                                   top: 8.0,
                               bottom: 8.0,
                             )

                           ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),


          ),

          //Results of place predictions


          (placesPredictedList.length > 0) ? Expanded(
            child: ListView.separated(
              itemCount: placesPredictedList.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index)
              {
                return PlacePredictionTileDesign(
                  predictedPlaces : placesPredictedList[index],
                );




              },
              separatorBuilder: (BuildContext, int index)
              {
               return const Divider(
                  height: 1,
                  color: Colors.grey,
                  thickness: 1,
                );
              },

            ) ,
          ) : Container(),


        ],
      ),
    );
  }
}
