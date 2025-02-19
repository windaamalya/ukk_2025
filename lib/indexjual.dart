import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class detailpenjualanTab extends StatefulWidget {
  const detailpenjualanTab({super.key});

  @override
  State<detailpenjualanTab> createState() => _detailpenjualanTabState();
}

class _detailpenjualanTabState extends State<detailpenjualanTab> {
  List<Map<String, dynamic>> penjualanlist = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchdetail();
  }

  Future<void>fetchdetail() async{
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
        .from('detailpenjualan')
        .select('*,penjualan(*,pelanggan(*)), produk(*)');
      setState(() {
        penjualanlist = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? Center(child: CircularProgressIndicator())
        : penjualanlist.isEmpty
        ?Center(child: Text('Tidak ada data detail penjualan'))
        :ListView.builder(
        itemCount: penjualanlist.length,
        itemBuilder: (context, index) {
          final detail = penjualanlist[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: SizedBox(

              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Detail ID: ${detail['DetailID']?.toString() ?? 'tidak tersedia'}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 28),
                        Text('Penjualan ID: ${detail['penjualan']['pelanggan']['NamaPelanggan']?.toString() ?? 'tidaktersedia'}',
                        style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 28),
                        Text('Produk ID: ${detail['NamaProduk']?.toString() ?? 'tidak tersedia'}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 28),
                        Text('Jumlah Produk: ${detail['JumlahProduk']?.toString() ?? 'tidak tersedia'}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 28),
                        Text('SubTotal: ${detail['SubTotal']?.toString() ?? 'tidak tersedia'}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ), 
              ),
            ),
          );
        },
      ),
    );
  }
}