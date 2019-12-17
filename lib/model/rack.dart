import 'building.dart';
import 'building_list.dart';

class Rack {
  int _id;
  int _availableStands;
  int _availableBikes;
  double _latitude;
  double _longitude;
  String _addressLocality;
  String _streetAddress;
  String _locationDescription;
  List<Building> _buildings;
  double _distance;

  Rack(
      this._id,
      this._availableStands,
      this._availableBikes,
      this._latitude,
      this._longitude,
      this._addressLocality,
      this._streetAddress,
      this._locationDescription,
      this._buildings);


  get id => _id;
  set id(value) {
    this._id = value;
  }

  get availableStands => _availableStands;
  set availableStands(value) {
    this._availableStands = value;
  }

  get availableBikes => _availableBikes;
  set availableBikes(value) {
    this._availableBikes = value;
  }

  get latitude => _latitude;
  set latitude(value) {
    this._latitude = value;
  }

  get longitude => _longitude;
  set longitude(value) {
    this._longitude = value;
  }

  get addressLocality => _addressLocality;
  set addressLocality(value) {
    this._addressLocality = value;
  }

  get streetAddress => _streetAddress;
  set streetAddress(value) {
    this._streetAddress = value;
  }

  get locationDescription => _locationDescription;
  set locationDescription(value) {
    this._locationDescription = value;
  }

  get distance => _distance;
  set distance(value) {
    this._distance = value;
  }

  get buildings => _buildings;
  set buildings(value) {
    this._buildings = value;
  }

  factory Rack.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('buildings')) {
      var list = json['buildings'] as List;
      BuildingList buildingList = BuildingList.fromJson(list);

      return Rack(
          json['id'],
          json['available_stands'],
          json['available_bikes'],
          double.parse(json['latitude']),
          double.parse(json['longitude']),
          json['address_locality'],
          json['street_address'],
          json['location_description'],
          buildingList.buildings);
    } else {
      return Rack(
          json['id'],
          json['available_stands'],
          json['available_bikes'],
          double.parse(json['latitude']),
          double.parse(json['longitude']),
          json['address_locality'],
          json['street_address'],
          json['location_description'],
          null);
    }
  }

  @override
  String toString() {
    String str = 'Rack{' +
        'id=' +
        id +
        ', availableStands=' +
        availableStands +
        ', availableBikes=' +
        availableStands +
        ', latitude=' +
        latitude +
        ', longitude=' +
        longitude +
        ', addressLocality=' +
        addressLocality +
        '\'' +
        ', streetAddress=' +
        streetAddress +
        '\'' +
        ', locationDescription=' +
        locationDescription +
        '\'';
    if (buildings != null) {
      str += ', buildings=' + buildings.toString();
    }
    str += ', distance=' + distance + '}';

    return str;
  }

}
