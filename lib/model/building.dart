class Building {
  int _id;
  String _name;

  Building(this._id, this._name);

  get id => _id;
  set id(value) {
    _id = value;
  }

  get name => _name;
  set name(value) {
    _name = value;
  }

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(json['id'], json['name']);
  }

  @override
  String toString() {
    return 'Building{' + 'id=' + id + ', name=' + name + '\'' + '}';
  }
}
