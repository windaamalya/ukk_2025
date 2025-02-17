// import 'package:flutter/material.dart';
// import 'package:ukk_2025/indexjual.dart';
// import 'package:ukk_2025/pelanggan/index.dart';
// import 'package:ukk_2025/penjualan/index.dart';
// import 'package:ukk_2025/produk/index.dart';
// import 'package:ukk_2025/register.dart';
// import 'login.dart';

// class AdminHomepage extends StatefulWidget {
//   const AdminHomepage({super.key});

// @override
// State<AdminHomepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<AdminHomepage>{
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(length: 4, child: 
//     Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue[200],
//         bottom: TabBar(
//           tabs: [
//             Tab(icon: Icon(Icons.inventory), text: 'Produk'),
//             Tab(icon: Icon(Icons.people), text: 'Pelanggan'),
//             Tab(icon: Icon(Icons.shopping_cart), text: 'Penjualan'),
//             Tab(icon: Icon(Icons.drafts), text: 'Detail Penjualan'),
//           ]
//         )
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 100,
//               child: DrawerHeader(
//                 child: ListTile(
//                   leading: Icon(Icons.arrow_back),
//                   title: Text(
//                     'Pengaturan',
//                     style: TextStyle(
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) =>AdminHomepage()),
//                       );
//                   },
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.arrow_back),
//               title: Text('Log Out'),
//               onTap: (){
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginPage()),
//               );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.app_registration),
//               title: Text('User'),
//               onTap: () {
//                 Navigator.push(
//                   context, 
//                   MaterialPageRoute(builder: (context) => Register()),
//                   );
//               },
//             )
//           ],
//         ),
//       ),
//       body: TabBarView(
//         children: [
//           produkTab(),
//           pelangganTab(),
//           penjualanTab(),
//           detailpenjualanTab(),
//         ],
//       ),
//      )
//     );
//   }
//   }