import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/detailpenjualan.dart';
import 'package:ukk_2025/produk/insert.dart';
import 'package:ukk_2025/produk/update.dart';

class produkTab extends StatefulWidget {
  const produkTab({super.key});

  @override
  State<produkTab> createState() => _produkTabState();
}

class _produkTabState extends State<produkTab> {
   List<Map<String, dynamic>> produk = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error deleting produk: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteproduk(int ProdukID) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukID', ProdukID);
      fetchProduk();
    } catch (e) {
      print('Error deleting produk: $e');
    }
  }


 @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: 
    produk.isEmpty
    ? Center(
      child: Text(
        'Tidak ada produk',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), 
      ),
    )
    : ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: produk.length,
      itemBuilder: (context, index) {
        final roduk = produk[index];
        return InkWell(
          onTap: () {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => ProdukDetailPage(produk: roduk)));
          },
          child: 
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roduk['NamaProduk']?.toString()?? 'Produk tidak tersedia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    roduk['Harga']?.toString()?? 'Tidak tersedia',
                    style: TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 15, color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    roduk['Stok']?.toString()?? 'Tidak tersedia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          final ProdukID =
                          roduk['ProdukID'] ?? 0;
                          if (ProdukID != 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProduk(ProdukID: ProdukID),
                              ),
                            );
                          } else {
                            print('ID produk tidak valid');
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Hapus produk'),
                                content: const Text('Apakah anda yakin akan menghapus produk ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteproduk(roduk['ProdukID']);
                                      if (context.mounted) {
                                      Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              ),
          )
        );
      },
    ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddProduk()),
        );
       },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
    ),
     floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
  );
 }
}

