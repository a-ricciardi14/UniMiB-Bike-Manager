import 'rack.dart';

class RackList {
  List<Rack> _racks;

  RackList(this._racks);

  get racks => _racks;

  factory RackList.fromJson(Map<String,dynamic> json){
    var list = json['racks'] as List;

    list = list.map((i) => Rack.fromJson(i)).toList();

    return RackList(list);
  }
}