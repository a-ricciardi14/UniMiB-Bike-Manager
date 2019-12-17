import 'bike.dart';
import 'rack.dart';

class Rental {
  int _id;
  Bike _bike;
  String _startedOn;
  String _completedOn;
  Rack _startRack;
  Rack _endRack;

  Rental(this._id,this._bike, this._startedOn, this._completedOn, this._startRack,
      this._endRack);

  factory Rental.fromJson(Map<String, dynamic> json) {

    if(json.containsKey('end_rack')){
      //richiesta di tutti i noleggi (anche quelli in corso)

      Map<String,dynamic> endRack = json['end_rack'];
      
      if(endRack == null){
        //noleggio ancora in corso
        return Rental(
            json['id'],
            Bike.fromJson(json['bike']),
            json['started_on'],
            json['completed_on'],
            Rack.fromJson(json['start_rack']),
            null);
      }else{
        return Rental(
          //noleggio concluso
            json['id'],
            Bike.fromJson(json['bike']),
            json['started_on'],
            json['completed_on'],
            Rack.fromJson(json['start_rack']),
            Rack.fromJson(json['end_rack']));
      }

    }else{

      //usato quando si inizia un nuovo noleggio (end rack non è presente)
      return Rental(
          json['id'],
          Bike.fromJson(json['bike']),
          json['started_on'],
          null,
          Rack.fromJson(json['start_rack']),
          null);

    }
  }

  get id => _id;
  set id(value) {
    _id = value;
  }

  get bike => _bike;
  set bike(value) {
    _bike = value;
  }

  get startedOn => _startedOn;
  set startedOn(value) {
    _startedOn = value;
  }

  get completedOn => _completedOn;
  set completedOn(value) {
    _completedOn = value;
  }

  get startRack => _startRack;
  set startRack(value) {
    _startRack = value;
  }

  get endRack => _endRack;
  set endRack(value) {
    _endRack = value;
  }

  //ritorna il giorno del noleggio
  String getDay() {
    List<String> split;

    split = startedOn.split(' ');

    return split[0];
  }

  //ritorna l'ora di inizio e l'ora di fine del noleggio
  String getHours() {
    List<String> split;
    String str;

    split = startedOn.split(' ');
    split = split[1].split(':');

    str = split[0] + ':' + split[1];

    split = completedOn.split(' ');
    split = split[1].split(':');

    str += ' - ' + split[0] + ':' + split[1];

    return str;
  }

  String getStartHour() {
    List<String> split;
    String str;

    split = startedOn.split(' ');
    split = split[1].split(':');

    str = split[0] + ':' + split[1];

    return str;
  }
}
