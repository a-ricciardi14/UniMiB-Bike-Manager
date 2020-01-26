import 'dart:convert';

class Report {

  int _id;
  String _description;
  DateTime _createdOn;
  int _userId;
  int _bikeId;
  String _image;


  Report(this._id, this._description, this._createdOn, this._userId, this._bikeId, this._image);

  factory Report.fromJson(Map<String, dynamic> json){
    if(!json.containsKey('image')){
      return Report(
        json['id'],
        json['description'],
        json['created_on'],
        json['user_id'],
        json['bike_id'],
        null,
      );
    }else{
      return Report(
        json['id'],
        json['description'],
        json['created_on'],
        json['user_id'],
        json['bike_id'],
        base64.encode(json['image']),
      );
    }
  }

  get id => _id;
  set id(value) {_id=value;}

  get description => _description;
  set description(value) {_description=value;}

  get createdOn  => _createdOn;
  set createdOn(value) {_createdOn=value;}

  get userId  => _userId;
  set userId(value) {_userId=value;}

  get bikeId => _bikeId;
  set bikeId(value) {_bikeId=value; }

  get image => _image;
  set image(value) {_image=value;}

  @override
  String toString() {

    return 'Report{' +
        'ReportId=' + id +
        ', Description=' + description +
        ', CreatedOn=' + createdOn +
        ', BikeId=' + bikeId +
        ', UserId=' + userId +
        ', Image=' + image + '\'' +
        '}';
  }

}