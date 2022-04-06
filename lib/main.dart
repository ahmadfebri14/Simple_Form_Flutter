import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mceasy_submission/cuti/cuti_list.dart';
import 'package:mceasy_submission/cuti/cuti_model.dart';
import 'package:mceasy_submission/cuti/paling_banyak_cuti_list.dart';
import 'package:mceasy_submission/karyawan_modul/karyawan_list.dart';
import 'package:mceasy_submission/model/user.dart';
import 'package:provider/provider.dart';
import 'cuti/sisa_cuti_karyawan.dart';
import 'database_handler.dart';
import 'karyawan_modul/karyawan_baru_list.dart';
import 'karyawan_modul/karyawan_model.dart';

var hour = DateTime.now().hour;

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmployeeModel()),
        // ChangeNotifierProvider(create: (_) => CutiModel()),
        ChangeNotifierProxyProvider<EmployeeModel, CutiModel>(
          update: (context, data, po) => CutiModel(),
          create: (BuildContext context) => CutiModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: Center(
            child: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        )),
      ),
      body: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          (hour < 12) ? const Text("Good Morning,", style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),) : (hour < 17) ? const Text("Good Afternoon,", style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
          )) : const Text("Good Evening,", style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
          )),
          Text("HRD Recruiter", style: const TextStyle(
              fontSize: 18,
          )),
          SizedBox(height: 25,),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KaryawanList(),
                        ),
                      );
                    },
                    child: Container(
                        height: 150,
                        width: double.infinity / 2,
                        margin: EdgeInsets.all(10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/ic_person.png'),
                                height: 64,
                                width: 64,
                              ),
                              Text("Employee Report"),
                            ],
                          ),
                        )),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CutiList(),
                        ),
                      );
                    },
                    child: Container(
                        height: 150,
                        width: double.infinity / 2,
                        margin: EdgeInsets.all(10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/ic_leave.png'),
                                height: 64,
                                width: 64,
                              ),
                              Text("Leave Report"),
                            ],
                          ),
                        )),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SisaCutiList(),
                        ),
                      );
                    },
                    child: Container(
                        height: 150,
                        width: double.infinity / 2,
                        margin: EdgeInsets.all(10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/ic_leave_report.png'),
                                height: 64,
                                width: 64,
                              ),
                              Text("Leave Quota Report"),
                            ],
                          ),
                        )),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PalingBanyakCutiList(),
                        ),
                      );
                    },
                    child: Container(
                        height: 150,
                        width: double.infinity / 2,
                        margin: EdgeInsets.all(10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/ic_report_done.png'),
                                height: 64,
                                width: 64,
                              ),
                              Text(
                                "Leave More Than 1",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )),
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Text(
            "New Nakama",
            style: TextStyle(fontSize: 18),
          ),
          KaryawanBaruList()
        ],
      ),
    );
  }
}

class ListCuti extends StatefulWidget {
  const ListCuti({Key? key}) : super(key: key);

  @override
  _ListCutiState createState() => _ListCutiState();
}

class _ListCutiState extends State<ListCuti> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
