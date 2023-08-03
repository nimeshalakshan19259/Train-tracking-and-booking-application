import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:traindrivers_app/authentication/login_screen.dart';
import 'package:traindrivers_app/authentication/train_info_screen.dart';
import 'package:traindrivers_app/global/global.dart';
import 'package:traindrivers_app/widgets/progress_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController nicTextEditingController = TextEditingController();
  TextEditingController srilankarailwayidTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 Characters.");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number is required.");
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 Characters.");
    } else {
      saveDriverInfoNow();
    }
  }

  saveDriverInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => TrainInfoScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/traindriver.png"),
              ),
              const SizedBox(
                height: 1,
              ),
              const Text(
                "Register As a Train Driver",
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "name",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2196F3)),
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
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "email",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2196F3)),
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "Phone",
                    hintText: "phone number",
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
                controller: nicTextEditingController,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "NIC",
                    hintText: "NIC",
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
                controller: srilankarailwayidTextEditingController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "RailwayID",
                    hintText: "RailwayID",
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
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                ),
                decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "password",
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
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => TrainInfoScreen()));
                    validateForm();

                  },
                  style: ElevatedButton.styleFrom(
                    primary:  Color(0xFF2196F3),
                    padding:  EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 18,
                    ),
                  )),
              TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(0.20),
                  child: Text(
                    "Already Registered? Login here !",
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
              ),
            ]),
          ),
        ));
  }
}
