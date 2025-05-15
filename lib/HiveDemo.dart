import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDemo extends StatefulWidget {
  const HiveDemo({super.key});

  @override
  State<HiveDemo> createState() => _HiveDemoState();
}

class _HiveDemoState extends State<HiveDemo> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController controller = TextEditingController();
  String msg = '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: controller,
          ),
          ElevatedButton(
              onPressed: () {
                String data = controller.text;
                hiveInit(data);
              },
              child: Text('Save')),
          SizedBox(height: 50),
          Text(msg),
          ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text('fetch')),
        ],
      ),
    );
  }

  Future<void> hiveInit(String data) async {
    Box box = await Hive.openBox('first');
    box.put('name', data);
    box.close();
    setState(() {});
  }

  Future<void> fetchData() async {
    // Box box = Hive.box('first');
    Box box = await Hive.openBox('first');
    msg = box.get('name');
    box.close();
    setState(() {});
  }
}
