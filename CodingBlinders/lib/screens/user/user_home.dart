import 'package:codingblinders/screens/models/doctormodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  late List<Doctor>? doctorModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    doctorModel = (await ApiService().getUsers())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:doctorModel == null || doctorModel!.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: doctorModel!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => {
              print(doctorModel![index].userUid)
            },
            child:  Card(
              child: Padding(padding: EdgeInsets.all(10.00),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset('assets/icons/female-doctor.jpg',height: 155,),
                      Text(doctorModel![index].name),
                      Row(
                        children: [
                          Text(doctorModel![index].specialization),
                          SizedBox(width: 200,),
                          Container(color: Colors.green,
                          height: 30,
                          width: 100,
                          child: Center(child: Text('Avaliable')),)
                        ],

                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
class ApiService {
  Future<List<Doctor>?> getUsers() async {
    try {
      var url = Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/admin/all/:doctor');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Doctor> _model = DoctormodelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class DoctormodelfromJson {

}