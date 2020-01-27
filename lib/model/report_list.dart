import 'report.dart';

class ReportList{

  List<Report> _reports;

  ReportList(this._reports);

  get reports => _reports;

  factory ReportList.fromJson(Map<String,dynamic> json){
    var list = json['reports'] as List;
    list = list.map((i) => Report.fromJson(i)).toList();

    return ReportList(list);
  }
}