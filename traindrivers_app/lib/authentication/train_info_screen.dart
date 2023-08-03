import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:traindrivers_app/global/global.dart';
import 'package:traindrivers_app/splashScreen/splash_screen.dart';

class TrainInfoScreen extends StatefulWidget {
  @override
  State<TrainInfoScreen> createState() => _TrainInfoScreenState();
}

class _TrainInfoScreenState extends State<TrainInfoScreen> {
  TextEditingController TrainModelTextEditingController =
      TextEditingController();
  TextEditingController TrainNameEditingController = TextEditingController();
  TextEditingController TrainDestinationsTextEditingController =
      TextEditingController();

  List<String> trainTypesList = ["longtrip", "shorttrip", "mail"];
  String? selectedTrainType;

  saveTrainInfo() {
    Map drivertraininfoMap = {
      "train_model": TrainModelTextEditingController.text.trim(),
      "train_name": TrainNameEditingController.text.trim(),
      "train_destination": TrainDestinationsTextEditingController.text.trim(),
      "type" : selectedTrainType,
    };

    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child("drivers");
    driversRef
        .child(currentFirebaseUser!.uid)
        .child("train_details")
        .set(drivertraininfoMap);
    Fluttertoast.showToast(msg: "Train Details has been Saved");
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/train01.png"),
              ),
              const SizedBox(
                height: 1,
              ),
              const Text(
                "Enter Your Train Details",
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: TrainModelTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "Model",
                    hintText: "model",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2196F3),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 14,
                    )),
              ),
              TextField(
                controller: TrainNameEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "name",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 14,
                    )),
              ),
              TextField(
                controller: TrainDestinationsTextEditingController,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "Destination",
                    hintText: "destination",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 14,
                    )),
              ),
              
              
              DropdownButton(
                hint:  const Text(
                  "Please choose Train Type",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,


                  ),
                ),
                value: selectedTrainType,
                onChanged: (newValue)
                {
                  setState(() {
                    selectedTrainType = newValue.toString();
                  });
                },
                items: trainTypesList.map((train){
                  return DropdownMenuItem(
                    child: Text(
                      train,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    value: train,
                  );
                }).toList(),
              ),
              
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (TrainModelTextEditingController.text.isNotEmpty &&
                        TrainNameEditingController.text.isNotEmpty &&
                        TrainDestinationsTextEditingController
                            .text.isNotEmpty && selectedTrainType != null) {
                      saveTrainInfo();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary:  Color(0xFF2196F3),
                    padding:  EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(
                      20.0,
                    ),
                    child: Text(
                      "Save Details",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
