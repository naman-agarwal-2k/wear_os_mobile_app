// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const BleScan());
//   }
// }
//
// class BleScan extends StatefulWidget {
//   const BleScan({super.key});
//
//   @override
//   BleScanState createState() => BleScanState();
// }
//
// class BleScanState extends State<BleScan> {
//   late BluetoothService service;
//   int scanDuration = 10; // seconds
//
//   @override
//   void initState() {
//     FlutterBlue.instance.startScan(timeout: Duration(seconds: scanDuration));
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     FlutterBlue.instance.stopScan();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//       ),
//       body: Column(
//         children: <Widget>[
//           Center(
//             child: Container(
//               alignment: Alignment.center,
//               child: const Text('Search again if not detected'),
//             ),
//           ),
//           StreamBuilder<List<ScanResult>>(
//               stream: FlutterBlue.instance.scanResults,
//               initialData: const [],
//               builder: (c, snapshot) {
//                 print(snapshot.data?.length);
//
//                 return Column(
//                   children: snapshot.data!
//                       .map(
//                         (r) => Text(
//                           r.device.name,
//                           style: const TextStyle(
//                               fontSize: 24,
//                               color: Colors.purple,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       )
//                       .toList(),
//                 );
//               }),
//           const Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               StreamBuilder<bool>(
//                 stream: FlutterBlue.instance.isScanning,
//                 initialData: false,
//                 builder: (c, snapshot) {
//                   // if (snapshot.data == null) {
//                   //   return Container();
//                   // } else {
//                   return FloatingActionButton.extended(
//                     icon: const Icon(Icons.search),
//                     label: const Text('Search again'),
//                     onPressed: () {
//                       // Start scanning
//                       FlutterBlue.instance
//                           .startScan(timeout: const Duration(seconds: 4));
//
//                       FlutterBlue.instance.scanResults.listen((results) {
//                         // do something with scan results
//                         for (ScanResult r in results) {
//                           print('${r.device.name} found! rssi: ${r.rssi}');
//                         }
//                       });
//                       FlutterBlue.instance.stopScan();
//                       FlutterBlue.instance
//                           .startScan(timeout: Duration(seconds: scanDuration));
//                     },
//                   );
//                   // }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

import 'ble_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLE SCANNER"),
        centerTitle: true,
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<List<ScanResult>>(
                    stream: controller.scanResults,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Text(data.device.name),
                                  subtitle: Text(data.device.id.id),
                                  trailing: Text(data.rssi.toString()),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Text("No Device Found"),
                        );
                      }
                    }),
                ElevatedButton(
                    onPressed: () => controller.scanDevices(),
                    child: Text("Scan")),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
