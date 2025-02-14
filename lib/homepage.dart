import 'package:flutter/material.dart';
import 'login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

@override
State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 4, child: 
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.inventory), text: 'Produk'),
            Tab(icon: Icon(Icons.people), text: 'Pelanggan'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Penjualan'),
            Tab(icon: Icon(Icons.drafts), text: 'Detail Penjualan'),
          ]
        )
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                child: ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text(
                    'Pengaturan',
                    style: TextStyle(
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>Homepage()),
                      );
                  },
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('Log Out'),
              onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              },
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [
          produkTab(),
          pelangganTab(),
          penjualanTab(),
          detailpenjualanTab(),
        ],
      ),
     )
    );
  }
}

Widget produkTab() {
  return Center(child: Text('Halaman Produk'));
}

Widget pelangganTab() {
  return Center(child: Text('Halaman pelanggan'));
}

Widget penjualanTab(){
  return Center(child: Text('Halaman Penjualan'));
}

Widget detailpenjualanTab (){
  return Center(child: Text('Halaman Detail Penjualan'));
}