import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for the UI
  String flag; // url to an asset flag icon
  String url; //  location url for the api endpoint
  late String time; // The time in that location
  late bool isDaytime; // identify day or night

  WorldTime({ required this.location, required this.flag, required this.url });

  Future<void> getTime() async{

    try {
      //make the request
      Response response = await get(
          Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);

      //get the properties from the data
      String datetime = data['datetime'];
      String offset_hours = data['utc_offset'].substring(1, 3);
      String offset_minutes = data['utc_offset'].substring(4, 6);

      //create Datatime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset_hours), minutes: int.parse(offset_minutes)));

      isDaytime = (now.hour > 6 && now.hour < 20) ? true : false;
      time = DateFormat.jm().format(now); //set the time property
    }
    catch(e){
      print('Caught error: $e');
      time = 'Could not get the time';
    }
  }
}

