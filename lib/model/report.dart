class Report {

  int _bikeId;
  String _description;

  Report(this._bikeId,this._description);

  get bikeId => _bikeId;
  set bikeId(value) {_bikeId=value; }

  get description => _description;
  set description(value) {_description=value;}

  @override
  String toString() {

    return 'Report{' +
        'BikeId=' + bikeId +
        ', Description=' + description + '\'' +
        '}';
  }
}