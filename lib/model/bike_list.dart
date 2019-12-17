import 'bike.dart';

class BikeList{
  List<Bike> _bikes;

  BikeList(this._bikes);

  get bikes => _bikes;

  factory BikeList.fromJson(Map<String,dynamic> json){
    var list = json['bikes'] as List;

    list = list.map((i) => Bike.fromJson(i)).toList();

    return BikeList(list);
  }
}