import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/global.dart';
import '../widgets/info_design_ui.dart';



class ProfileTabPage extends StatefulWidget
{


  const ProfileTabPage({Key? key}) : super(key: key);


  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}




class _ProfileTabPageState extends State<ProfileTabPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Text(
              onlineDriverData!.name!,
              style: const TextStyle(
                fontSize: 50.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
            ),

            const SizedBox(height: 38.0,),

            //phone
            InfoDesignUIWidget(
              textInfo: onlineDriverData!.phone!,
              iconData: Icons.phone_iphone,
            ),

            //email
            InfoDesignUIWidget(
              textInfo: onlineDriverData!.email!,
              iconData: Icons.email,

            ),


            InfoDesignUIWidget(
              textInfo: onlineDriverData.train_name! + "" + onlineDriverData.train_model! + " " +  onlineDriverData.train_model!,
              iconData: Icons.train_sharp,

            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: ()
              {
                fAuth.signOut();
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white54,
              ),
              child: const Text(
                "LOGOUT",
                style: TextStyle(color: Colors.white),
              ),
            )

          ],
        ),
      ),
    );
  }
}
