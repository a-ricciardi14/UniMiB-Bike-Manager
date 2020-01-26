import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:unimib_bike_manager/model/bike.dart';
import 'package:unimib_bike_manager/model/bike_list.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/model/rental.dart';
import 'package:unimib_bike_manager/model/ip_address.dart';
import 'package:unimib_bike_manager/model/rack_list.dart';
import 'package:unimib_bike_manager/model/report_list.dart';


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

////funzione che fa il post per l'inizio del noleggio
//Future<Rental> postStartRent(String bikeId) async {
//  final response = await http.post(UnimibBikeEndpointUtil.rentals,
//      body: {'bike_id': bikeId});
//  if (response.statusCode == 200) {
//    Map<String, dynamic> map = json.decode(response.body);
//
//    Rental rental = Rental.fromJson(map['rental']);
//
//    return rental;
//  } else {
//    throw Exception('Failed to start rent');
//  }
//}

//funzione che fa il put per terminare il noleggio
Future<void> putEndRent(String rentId, String rackId) async {
  String url = UnimibBikeEndpointUtil.rentals + rentId + '/';

  final response = await http.put(url, body: {'rack_id': rackId});

  if (response.statusCode != 200) {
    throw Exception('Failed to end rent');
  }
}

////funzione che ottiene la lista dei noleggi
//Future<RentalList> fetchRentalList() async {
//  final response = await http.get(UnimibBikeEndpointUtil.rentals);
//
//  if (response.statusCode == 200) {
//    return RentalList.fromJson(json.decode(response.body));
//  } else {
//    throw Exception('Failed to load rental list');
//  }
//}

//funzione che fa il post di un report

Future<void> postReport(String id, String desc, String _uMail) async {
  final response = await http.post(UnimibBikeEndpointUtil.reports,
      body: {'bike_id': id, 'description': desc, 'userId': _uMail});
  if (response.statusCode != 200) {
    throw Exception('Unable to post report');
  }
}

//FUNZIONE X REPORT
Future<ReportList> fetchReportsList() async {
  String url = UnimibBikeEndpointUtil.reports;

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return ReportList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load report list');
  }
}


//TODO: Implementare richiesta BackEnd --> addRAck(int, int, String) #funzione non testata.

//FUNZIONI PER RASTRELLIERE

Future<void> setRacksParameters(var key, Rack _rack) async {
  String url = UnimibBikeEndpointUtil.racks + _rack.id.toString() + '/';

  if(key is String){
    final response = await http.put(
        url,
        body: {
          'locationDescription' : key,
        });

    if (response.statusCode != 200) {
      throw Exception('Failed to change LocalDescr');
    }
  }else if(key is int){
    final response = await http.put(
        url,
        body: {
          'capacity' : key,
        });

    if (response.statusCode != 200) {
      throw Exception('Failed to change capacity');
    }
  }
}

Future<void> addRack(int _rackId, int _capacity, String _locatDesc) async {
  String url = UnimibBikeEndpointUtil.racks;

  final response = await http.post(
    url,
    body: {
      'id' : _rackId,
      'capacity' : _capacity,
      'locationDescription' : _locatDesc,
      'latitude' : null,
      'longitude' : null,
      'streetAddress' : '',
      'addressLocality' : '',
    }
  );

  if(response.statusCode != 200){
    throw Exception('Failed to post Rack');
  }
}

Future<void> deleteRack(String _rackId) async {

  String url = UnimibBikeEndpointUtil.racks + _rackId + '/';
  final response = await http.delete(url);

  if (response.statusCode != 200){
    print('Status Code: ' + response.statusCode.toString());
    throw Exception('Failed to delete this rack');
  }

}



//FUNZIONI X BICICLETTE

Future<void> setBikeUnCode(int _unCod, Bike _bike) async {
  String url = UnimibBikeEndpointUtil.bikes + _bike.id.toString() + '/';


    final response = await http.put(
        url,
        body: {
          'unlock_code' : _unCod,
        });

    if (response.statusCode != 200) {
      throw Exception('Failed to change UnlockCode');
    }
}

Future<void> setBikeDisp(int _disp, Bike _bike) async {
  String url = UnimibBikeEndpointUtil.bikes + _bike.id.toString() + '/';

  final response = await http.put(
      url,
      body: {
        'bike_state_id' : _disp,
      });

  if (response.statusCode != 200) {
    throw Exception('Failed to change UnlockCode');
  }
}

Future<BikeList> fetchBikeList() async{
  String url = UnimibBikeEndpointUtil.bikes;

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return BikeList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load bike list');
  }
}

//funzione che fa il post() di una nuova biciletta
Future<void> addBike(String bikeId, int unCode, String rackId) async {

  var _bikeList = await fetchBikeList();

  for(int i=0; i<_bikeList.bikes.length; i++){
    if(bikeId == _bikeList.bikes[i].id){
      throw Exception("Id bicicletta già esistente");
    }
  }

  String url = UnimibBikeEndpointUtil.bikes;

  final response = await http.post(
      url,
      body: {
        'id' : bikeId,
        'unlock_code': unCode,
        'rack_id': int.parse(rackId),
      });

  if (response.statusCode != 200){
    print('Status Code: ' + response.statusCode.toString());
    throw Exception('Failed to add this bike');
  }

}

//funzione che fa il delete() di una bicicletta
Future<void> deleteBike(String bikeId) async {

  String url = UnimibBikeEndpointUtil.bikes + bikeId + '/';
  final response = await http.delete(url);

  if (response.statusCode != 200){
    print('Status Code: ' + response.statusCode.toString());
    throw Exception('Failed to delete this bike');
  }

}