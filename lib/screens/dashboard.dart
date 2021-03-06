import 'package:dvhacks/screens/indicator.dart';
import 'package:dvhacks/screens/logger.dart';
import 'package:dvhacks/screens/login.dart';
import 'package:dvhacks/screens/mldetection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(Dashboard());
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      home: dashboard(),
    );
  }
}

class dashboard extends StatefulWidget {
  dashboard({Key key, this.title}) : super(key: key);
  final String title;
  @override
  dashboardScreen createState() => dashboardScreen();
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class dashboardScreen extends State<dashboard> {
  List<FlSpot> line_chart = List<FlSpot>();
  String fat = '';
  String protein = '';
  String fiber = '';
  @override
  void initState() {
    super.initState();
    getData();
    getPieChartData();
  }

  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Dashboard',
      style: optionStyle,
    ),
    Text(
      'Index 1: Logger',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _selectedIndex = 0;
        Navigator.push(
            context, MyCustomRoute(builder: (context) => dashboard()));
      } else {
        _selectedIndex = 1;
        Navigator.push(context, MyCustomRoute(builder: (context) => logger()));
      }
    });
  }

  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  CollectionReference firebase = Firestore.instance.collection("protein");
  CollectionReference firebaseUser = Firestore.instance.collection("users");
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> getData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return firebase
        .document(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      Map<String, dynamic> temp_list = documentSnapshot.data;
      print("goes through here");
      setState(() {
        for (int i = 0; i < documentSnapshot.data.length; i++) {
          line_chart.add(FlSpot(
              double.parse((2 * i).toString()),
              (double.parse(
                      documentSnapshot.data["protein" + (i + 1).toString()])) /
                  10));
        }
      });
      print(temp_list);
    });
  }

  Future<void> getPieChartData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return firebaseUser
        .document(uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      setState(() {
        protein = documentSnapshot.data["protein"];
        fiber = documentSnapshot.data["fiber"];
        fat = documentSnapshot.data["fat"];
      });
    });
  }

  List<Color> gradientColors = [
    const Color(0xFF424359),
    const Color(0xFF666882),
  ];
  int touchedIndex1;
  int touchedIndex2;
  bool showAvg = false;
  @override
  Widget build(BuildContext context) {
    double sizeheight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double sizewidth(BuildContext context) => MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: const Color(0xff66D5C1),
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () async {
                    print("pressed");
                    await FirebaseAuth.instance.signOut().then((value) =>
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => login())));
                  },
                  child: Icon(
                    Icons.portrait_rounded,
                    color: Colors.black,
                  )))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xFF424359),
        selectedItemColor: Colors.black26,
        backgroundColor: const Color(0xff66D5C1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.apps,
              ),
              label: "Dashboard"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Information Center",
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/dashboardbg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (line_chart.length == 0 ||
            protein == '' ||
            fat == '' ||
            fiber == '') ...{
          new Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(const Color(0xff66D5C1)),
            ),
          )
        } else ...{
          new Container(
            decoration: BoxDecoration(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      height: sizeheight(context) * 0.25,
                      width: sizewidth(context) * 0.9,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(
                          top: sizeheight(context) * 0.02,
                          left: sizewidth(context) * 0.04,
                          right: sizewidth(context) * 0.04),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetectionPortal()));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image(
                                image: AssetImage('lib/assets/dashboard.png'),
                              )))),
                  Container(
                    margin: EdgeInsets.only(top: sizeheight(context) * 0.02),
                    alignment: Alignment.center,
                    child: Text("Proportions",
                        style: TextStyle(fontSize: 21, color: Colors.white)),
                  ),
                  Container(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: sizewidth(context) * 0.05,
                            right: sizewidth(context) * 0.05,
                            top: sizeheight(context) * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xff66D5C1),
                        ),
                        height: sizeheight(context) * 0.2,
                        width: sizewidth(context) * 0.6,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                sizewidth(context) * 0.03,
                                sizeheight(context) * 0.01,
                                0,
                                0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: sizeheight(context) * 0.01,
                                        left: sizewidth(context) * 0.07),
                                    child: PieChart(
                                      PieChartData(
                                          pieTouchData: PieTouchData(
                                              touchCallback:
                                                  (pieTouchResponse) {
                                            setState(() {
                                              if (pieTouchResponse.touchInput
                                                      is FlLongPressEnd ||
                                                  pieTouchResponse.touchInput
                                                      is FlPanEnd) {
                                                touchedIndex1 = -1;
                                              } else {
                                                touchedIndex1 = pieTouchResponse
                                                    .touchedSectionIndex;
                                              }
                                            });
                                          }),
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 20,
                                          sections: showingSections1()),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: sizewidth(context) * 0.26),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Color(0xff03989E),
                                          text: 'Protein',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Color(0xff5CE1E6),
                                          text: 'Fat',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Color(0xff4BC6B0),
                                          text: 'Fiber',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Color(0xff666882),
                                          text: 'Other',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 18,
                                        ),
                                      ],
                                    ),
                                  )
                                ]))),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: sizeheight(context) * 0.02),
                    child: Text(
                      "Protein Consumed",
                      style: TextStyle(fontSize: 21, color: Colors.white),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: sizeheight(context) * 0.02),
                      height: sizeheight(context) * 0.23,
                      width: sizewidth(context) * 0.9,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        color: const Color(0xFf66D5C1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 1.0, left: 1.0, top: 24, bottom: 12),
                        child: LineChart(
                          linechart(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        }
      ]),
    );
  }

  List<PieChartSectionData> showingSections1() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex1;
      final double radius = 60;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff03989E),
            value: double.parse(protein),
            title: '',
            radius: radius,
            titleStyle: TextStyle(fontSize: 16, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff5CE1E6),
            value: double.parse(fat),
            title: '',
            radius: radius,
            titleStyle: TextStyle(fontSize: 16, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff4BC6B0),
            value: double.parse(fiber),
            title: '',
            radius: radius,
            titleStyle: TextStyle(fontSize: 16, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff666882),
            value: 100 -
                (double.parse(fat) +
                    double.parse(fiber) +
                    double.parse(protein)),
            title: '',
            radius: radius,
            titleStyle: TextStyle(fontSize: 16, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }

  LineChartData linechart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '1';
              case 4:
                return '2';
              case 6:
                return '3';
              case 8:
                return '4';
              case 10:
                return '5';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10%';
              case 2:
                return '20%';
              case 3:
                return '30%';
              case 4:
                return '40%';
              case 5:
                return '50%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: line_chart,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}

int num = 10;
