import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'package:unimib_bike_manager/model/report_list.dart';
import 'model/user.dart';
import 'package:unimib_bike_manager/functions/requests.dart';


//TODO: fetchReportList() non funziona, i report vengono acquisiti dal backEnd, ma non esegue il ReportList.fromJson in model/report_list.


class ReportsPage extends StatefulWidget {
  final User user;
  ReportsPage({Key key, @required this.user}) : super(key: key);
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  User get _user => widget.user;

  Future<ReportList> reportList;

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    reportList = fetchReportsList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text('Lista Segnalazioni'),
      ),
      drawer: MyDrawer(user: _user),
      body: Container(
        child: FutureBuilder<ReportList>(
          future: reportList,
          builder: (context, rackSnap) {
            if (rackSnap.hasData) {
              return RefreshIndicator(
                child: Stack(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: rackSnap.data.reports == null
                          ? 0
                          : rackSnap.data.reports.length,
                      itemBuilder: (context, int index) {
                        return Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                                  title: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "Report: " +
                                      rackSnap.data.reports[index].id,
                                      //style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.description,
                                            color: Colors.grey[600]),
                                        Expanded(
                                          child: Text(
                                              rackSnap.data.reports[index].description,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                onRefresh: () {
                  return _onRefresh();
                },
              );
            } else if (rackSnap.hasError) {
              return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        S.of(context).ops_wrong,
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(S.of(context).service_exception),
                    ],
                  ));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      reportList = fetchReportsList();
    });
  }
}
