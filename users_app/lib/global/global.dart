import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/user_model.dart';

import '../models/direction_details_info.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = [];
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken ="key=AAAAbkJogsM:APA91bEcb8R9uU16IMEsmHLrTfFe7pbMrw_kp-NJEUU_K_nycZkjLl7X9rrO3UIaEkX10u2poz2QZJkByQaHtPtf6AxBL9WGv7iQopX1519GBoydX9HvbGeRaUOMCN98IzcUvQl4XK_L";
String userDropOffAddress = "";
String driverTrainDetails="";
String driverName="";
String driverPhone="";

