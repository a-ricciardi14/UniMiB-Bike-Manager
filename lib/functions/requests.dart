import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:unimib_bike_manager/model/bike.dart';
import 'package:unimib_bike_manager/model/bike_list.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/model/rental.dart';
import 'package:unimib_bike_manager/model/ip_address.dart';
import 'package:unimib_bike_manager/model/rack_list.dart';
import 'package:unimib_bike_manager/model/rental_list.dart';



//richiede il noleggio ancora attivo
Future<Rental> fetchActiveRent() async {
  final response = await http.get(UnimibBikeEndpointUtil.activeRentals);

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);

    Rental rental;

    if (map['rental'] != null) {
      rental = Rental.fromJson(map['rental']);
    } else {
      rental = null;
    }

    return rental;
  } else {
    throw Exception('Failed to fetch bike info');
  }
}

//funzione che riceve dal serve le rastrilliere
Future<RackList> fetchRackList() async {
  final response = await http.get(UnimibBikeEndpointUtil.racks);

  if (response.statusCode == 200) {
    return RackList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load rack list');
  }
}

//funzione per fare la richiesta al server riguardo un determinato rack
Future<Rack> fetchRack(String rackId) async {
  String url = UnimibBikeEndpointUtil.racks + rackId + '/';

  final response = await http.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    Map<String, dynamic> rack = map['rack'];

    return Rack.fromJson(rack);
  } else {
    throw Exception('Failed to fetch rack info');
  }
}

//funzione che restituisce le informazioni relative a una bicicletta
Future<Bike> fetchBikeInfo(String bikeId) async {
  String url = UnimibBikeEndpointUtil.bikes + bikeId + '/';

  final response = await http.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    Map<String, dynamic> bike = map['bike'];

    return Bike.fromJson(bike);
  } else {
    throw Exception('Failed to fetch bike info');
  }
}

//funzione che fa il post per l'inizio del noleggio
Future<Rental> postStartRent(String bikeId) async {
  final response = await http.post(UnimibBikeEndpointUtil.rentals,
      body: {'bike_id': bikeId});
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);

    Rental rental = Rental.fromJson(map['rental']);

    return rental;
  } else {
    throw Exception('Failed to start rent');
  }
}

//funzione che fa il put per terminare il noleggio
Future<void> putEndRent(String rentId, String rackId) async {
  String url = UnimibBikeEndpointUtil.rentals + rentId + '/';

  final response = await http.put(url, body: {'rack_id': rackId});

  if (response.statusCode != 200) {
    throw Exception('Failed to end rent');
  }
}

//funzione che ottiene la lista dei noleggi
Future<RentalList> fetchRentalList() async {
  final response = await http.get(UnimibBikeEndpointUtil.rentals);

  if (response.statusCode == 200) {
    return RentalList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load rental list');
  }
}

//funzione che fa il post di un report
Future<void> postReport(String id, String desc) async {
  final response = await http.post(UnimibBikeEndpointUtil.reports,
      body: {'bike_id': id, 'description': desc});
  if (response.statusCode != 200) {
    throw Exception('Unable to post report');
  }
}


//TODO: Implementare richiesta BackEnd --> putLocalDesc(String, String)

//FUNZIONI PER RASTRELLIERE

//funzione che fa il put per modificare il LocationDescription ---NON FUNZIONA---
Future<void> putLocalDesc(String str, String rackId) async {

  String url = UnimibBikeEndpointUtil.racks + rackId + '/';

  final response = await http.put(
      url,
      body: {
        'location_description' : str,
      });

  if (response.statusCode != 200) {
    throw Exception('Failed to change LocalDescr');
  }
}

//TODO: Implementare richiesta BackEnd --> fetchBikeList()
//TODO: Implementare richiesta BackEnd --> fetchRackBikes(String)
//TODO: Implemengtare richiesta BackEnd --> putBike(String, String)
//TODO: Implementare richiesta BackEnd --> deleteBike(String)

//FUNZIONI X BICICLETTE

Future<BikeList> fetchBikeList() async{
  String url = UnimibBikeEndpointUtil.bikes + '/';

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return BikeList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load bike list');
  }
}

//funzione che fa il post() di una nuova biciletta --NON FUNZIONA--
Future<void> postBike(String bikeId, int unCode, String rackId) async {

  String url = UnimibBikeEndpointUtil.bikes + bikeId + '/';
  final response = await http.post(url,
      body: {'unlock_code': unCode, 'rack_id': int.parse(rackId), 'bike_state_id': 1});

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);

    Bike bike = Bike.fromJson(map['bike']);
    return bike;

  } else {
    throw Exception('Failed to add new bike');
  }

}

//funzione che fa il delete() di una bicicletta --NON FUNZIONA--
Future<void> deleteBike(String bikeId) async {

  String url = UnimibBikeEndpointUtil.bikes + bikeId + '/';
  final response = await http.delete(url);

  if (response.statusCode != 200){
    print('Status Code: ' + response.statusCode.toString());
    throw Exception('Failed to delete this bike');
  }

}