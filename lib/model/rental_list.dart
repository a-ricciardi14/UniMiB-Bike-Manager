import 'rental.dart';

class RentalList{
  List<Rental> _rentals;

  RentalList(this._rentals);

  get rentals => _rentals;

  factory RentalList.fromJson(Map<String,dynamic> json){

    var list = json['rentals'] as List;

    list = list.map((i) => Rental.fromJson(i)).toList();

    return RentalList(list);
  }
}