// import 'package:postgresql2/postgresql.dart';

// class PostgreDbService {
//   var uri = 'postgres://agri:agri@10.0.2.2:5433/AgriShopping';
// //var uri = 'postgres://username:password@10.0.2.2:port/database;

//   Future insertUser(name, email, password) async {
//     try {
//       print("db entered");
//       var result = await connect(uri).then((conn) => conn
//           .query(
//               "INSERT INTO agri_usfers (Name, Email, Password, is_active) VALUES (@name, @email, @password, 1)",
//               {
//                 "name": name,
//                 "email": email,
//                 "password": password,
//               })
//           .toList()
//           .whenComplete(() {
//             conn.close();
//           }));
//       print(result);
//       return result;
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }
