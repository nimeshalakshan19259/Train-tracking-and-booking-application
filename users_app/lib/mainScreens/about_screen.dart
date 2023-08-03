import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AboutScreen extends StatefulWidget
{
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}




class _AboutScreenState extends State<AboutScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView(

        children: [

          //image
           Container(
            height: 200,
            child: Center(
              child: Image.asset(
                "images/rail.png",
                width: 230,
              ),
            ),
          ),


          const SizedBox(
            height: 50,
          ),


          Column(
            children: [

              //company name
              const Text(
                "RAILBOOK",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //about you & your company - write some info
              const Text(
                "RAILBOOK train tracking and booking application developed by Peragolle Peragolla, "
                "Srilanka's First train tracking and booking application. "
                "Still under development",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                "This app has been developed by Muhammad Ali, "
                    "This is the world number 1 ride sharing app. Available for all. "
                    "20M+ people already use this app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              //close
              ElevatedButton(
                onPressed: ()
                {
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white54,
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
              ),

            ],
          ),

        ],

      ),
    );
  }
}
