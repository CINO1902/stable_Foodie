// import 'dart:async';

// import 'package:connectivity/connectivity.dart';
// import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';


//   class paymentservice {
//   // Create our public controller
//   StreamController<ConnectivityStatus> connectionStatusController = StreamController();

//  Stream<paymentstatus> get secondCountStream => connectionStatusController.stream;
//   ConnectivityService() {
//     // Subscribe to the connectivity Chanaged Steam
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       // Use Connectivity() here to gather more info if you need t

//       connectionStatusController.add(_getStatusFromResult(result));
//     });
//   }
  
//   // Convert from the third part enum to our own enum
//   paymentstatus _getStatusFromResult1(ConnectivityResult result) {
//     switch (result) {
//       case ConnectivityResult.mobile:
//         return ConnectivityStatus.Cellular;
//       case ConnectivityResult.wifi:
//         return ConnectivityStatus.WiFi;
//       case ConnectivityResult.none:
//         return ConnectivityStatus.Offline;
//       default:
//         return ConnectivityStatus.Offline;
//     }
//   }
// }
