import 'building.dart';

class BuildingList {

  List<Building> _buildings;

  BuildingList(this._buildings);

  get buildings => _buildings;

  factory BuildingList.fromJson(List<dynamic> json){

    List<Building> list = List<Building>();

    list = json.map((i) => Building.fromJson(i)).toList();

    return BuildingList(list);
  }
}