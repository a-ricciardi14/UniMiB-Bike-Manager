import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/model/rack_list.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';

//TODO: Implementare DropDownMenù per visualizzare la lista di rastrelliere.

class RemoveRack extends StatefulWidget {

  final User user;

  RemoveRack({Key key, @required this.user}) :
        assert (user != null),
        super(key: key);

  @override
  _RemoveRackState createState() => _RemoveRackState();
}

class _RemoveRackState extends State<RemoveRack> {
  User get _user => widget.user;

  final _formKey = GlobalKey<FormState>();
  Future<RackList> rackList;
  bool _request = false;

  TextEditingController _controller = new TextEditingController();

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    rackList = fetchRackList();
    _request = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text(S.of(context).remove_rack),
      ),
      drawer: MyDrawer(user: _user),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: new Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 100.0,
                  child: RaisedButton(
                      color: Colors.red[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)
                      ),
                      child: Text('Salva', style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
