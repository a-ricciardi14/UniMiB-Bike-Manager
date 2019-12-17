abstract class UnimibBikeEndpointUtil{

  static final String address = 'http://192.168.10.102:8000/api/';

  static final String activeRentals = address + 'rentals/?active=yes';
  static final String racks = address + 'racks/';
  static final String bikes = address + 'bikes/';
  static final String rentals = address + 'rentals/';
  static final String reports = address + 'reports/';
}