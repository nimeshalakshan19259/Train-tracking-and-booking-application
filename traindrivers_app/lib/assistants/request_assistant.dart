import 'dart:convert';

import 'package:http/http.dart' as http;


class RequestAssistant
{
  static Future<dynamic> recieveRequests(String url) async
  {
    http.Response httpResponse = await http.get(Uri.parse(url));


    try
    {
      if(httpResponse.statusCode == 200)
      {
        String responseData = httpResponse.body;

        //json format


        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      }

      else
      {
        return "error try again!";
      }
    }

    catch(exp)
    {
      return exp.toString() + "error try again!";
    }





  }
}