import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/model/user.dart';

//TODO: Aggiungere a Card Segnalazioni --> onTap() Lista Segnalazioni.
//TODO: Creare pagina per visualizzare la Lista Segnalazioni.

class HomePage extends StatefulWidget {

  final User user;

  HomePage({Key key, @required this.user}) : assert (user != null), super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User get _user => widget.user;

  PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 1
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      backgroundColor: Colors.grey[300],

      body: PageView.builder(
        itemCount: 3,
          onPageChanged: (value){
          setState(() {
            currentPage = value;
            });
          },
          controller: _pageController,
          itemBuilder: (context, index) => animateItemBuilder(index)),

      drawer: MyDrawer(user: _user),
    );
  }

  animateItemBuilder(int index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child){
        return Center(
          child: SizedBox(
            width: 3000,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: index == 0
            ? Card(
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 300.0,
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red[800],
                    width: 4,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'GESTIONE BICICLETTE',
                        style: TextStyle(fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      //Racks Management --> #1 Icon-Button
                      Container(
                        child: RawMaterialButton(
                          onPressed: (){
                            setState(() {
                              Navigator.pushNamed(context, '/bike_list');
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.settings, size: 60.0, color: Colors.grey[800],),
                              Padding(

                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text("Gestisci Biciclette",
                                  style: TextStyle(
                                      fontSize: 18.0
                                  ),
                                ),
                              )
                            ],
                          ),
                          elevation: 2.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18.0),
                              )
                          ),
                          fillColor: Colors.grey[300],
                          padding: EdgeInsets.all(15.0),
                        ),
                      ),

                      //Racks Management --> #2 Icon-Button
                      Container(
                        child: RawMaterialButton(
                          onPressed: (){
                            setState(() {
                              Navigator.pushNamed(context, '/bike_add');
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.add_circle_outline, size: 60.0, color: Colors.green[600],),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text("Aggiungi Bicicletta",
                                  style: TextStyle(
                                      fontSize: 18.0
                                  ),
                                ),
                              )
                            ],
                          ),
                          elevation: 2.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18.0),
                              )
                          ),
                          fillColor: Colors.grey[300],
                          padding: EdgeInsets.all(15.0),
                        ),
                      ),

                      //Racks Management --> #3 Icon-Button
                      Container(
                        child: RawMaterialButton(
                          onPressed: (){
                            setState(() {
                              Navigator.pushNamed(context, '/bike_remove');
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.remove_circle_outline, size: 60.0, color: Colors.red[800],),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text("Rimuovi Bicicletta",
                                  style: TextStyle(
                                      fontSize: 18.0
                                  ),
                                ),
                              )
                            ],
                          ),
                          elevation: 2.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18.0),
                              )
                          ),
                          fillColor: Colors.grey[300],
                          padding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
            : ( index == 1
                ? Card(
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 300.0,
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red[800],
                    width: 4,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'GESTIONE RASTRELLIERE',
                        style: TextStyle(fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //Racks Management --> #1 Icon-Button
                      Container(
                          child: RawMaterialButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(context, '/rack_list');
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.settings, size: 60.0, color: Colors.grey[800],),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text("Gestisci Rastrelliera",
                                    style: TextStyle(
                                        fontSize: 18.0
                                    ),
                                  ),
                                )
                              ],
                            ),
                            elevation: 2.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                )
                            ),
                            fillColor: Colors.grey[300],
                            padding: EdgeInsets.all(15.0),
                          )
                      ),

                      //Racks Management --> #2 Icon-Button
                      Container(
                          child: RawMaterialButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(context, '/rack_add');
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.add_circle_outline, size: 60.0, color: Colors.green[600],),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text("Aggiungi Rastrelliera",
                                    style: TextStyle(
                                        fontSize: 18.0
                                    ),
                                  ),
                                )
                              ],
                            ),
                            elevation: 2.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                )
                            ),
                            fillColor: Colors.grey[300],
                            padding: EdgeInsets.all(15.0),
                          )
                      ),

                      //Racks Management --> #2 Icon-Button
                      Container(
                          child: RawMaterialButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(context, '/rack_remove');
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.remove_circle_outline, size: 60.0, color: Colors.red[800],),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text("Rimuovi Rastrelliera",
                                    style: TextStyle(
                                        fontSize: 18.0
                                    ),
                                  ),
                                )
                              ],
                            ),
                            elevation: 2.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                )
                            ),
                            fillColor: Colors.grey[300],
                            padding: EdgeInsets.all(15.0),
                          )
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
                : Card(
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0,),
              Container(
                width: 300.0,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red[800],
                    width: 4,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'GESTIONE SEGNALAZIONI',
                        style: TextStyle(fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //Reports Management --> #1
                      Container(
                          child: RawMaterialButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(context, '/report_page');
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.list, size: 60.0, color: Colors.grey[800],),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text("Lista Segnalazioni",
                                    style: TextStyle(
                                        fontSize: 18.0
                                    ),
                                  ),
                                )
                              ],
                            ),
                            elevation: 2.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                )
                            ),
                            fillColor: Colors.grey[300],
                            padding: EdgeInsets.all(15.0),
                          )
                      ),
                      //Reports Management --> #1 Icon-Button
                      Container(
                          child: RawMaterialButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(context, '/racks_report');
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.report_problem, size: 60.0, color: Colors.red[700],),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text("Segnala Rastrelliera",
                                    style: TextStyle(
                                        fontSize: 18.0
                                    ),
                                  ),
                                )
                              ],
                            ),
                            elevation: 2.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                )
                            ),
                            fillColor: Colors.grey[300],
                            padding: EdgeInsets.all(15.0),
                          )
                      ),
                      //Reports Management --> #2 Icon-Button
                      Container(
                          child: RawMaterialButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(context, '/bikes_report');
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.report_problem, size: 60.0, color: Colors.red[700],),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text("Segnala Bicicletta",
                                    style: TextStyle(
                                        fontSize: 18.0
                                    ),
                                  ),
                                )
                              ],
                            ),
                            elevation: 2.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                )
                            ),
                            fillColor: Colors.grey[300],
                            padding: EdgeInsets.all(15.0),
                          )
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
            ),
      ),
    );
  }


}
