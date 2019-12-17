import 'rack.dart';


class Bike {
  int _id;
  int _unlockCode;
  String _bikeState;
  Rack _rack;

  Bike(this._id, this._unlockCode, this._bikeState, this._rack);

  factory Bike.fromJson(Map<String, dynamic> json) {

    if (json.containsKey('rack') && json.containsKey('bike_state')) {
      Rack rack = Rack.fromJson(json['rack']);

      Map<String,dynamic> state = json['bike_state'];

      return Bike(
          json['id'],
          json['unlock_code'],
          state['description'],
          rack);
    } else {
      return Bike(json['id'], json['unlock_code'], null, null);
    }
  }

  get id => _id;
  set id(value) {
    _id = value;
  }

  get unlockCode => _unlockCode;
  set unlockCode(value) {
    _unlockCode = value;
  }

  get bikeState => _bikeState;
  set bikeState(value) {
    _bikeState = value;
  }

  get rack => _rack;
  set rack(value) {
    _rack = value;
  }
}
