

import 'package:flutter/material.dart';
import 'package:ukk_2025/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProdukDetailPage extends StatefulWidget {
  final Map<String, dynamic> produk;
  const ProdukDetailPage({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  int JumlahPesanan = 0;
  int TotalHarga = 0;
  int stokakhir = 0;
  int stokawal = 0;
  int? selectedPelangganID;
  List<Map<String, dynamic>> pelangganlist = [];

@override
void initState(){
  super.initState();
  stokawal = widget.produk['stok'] ?? 0;
  stokakhir = stokawal;
  print("DEBUG: Stok awal produk = $stokawal");
  fetchpelanggan();
}
bool isLoading = false;

Future<void> fetchpelanggan() async {
  if (isLoading) return;
  setState(() {
    isLoading = true;
  });
  final supabase = Supabase.instance.client;
  try {
    final response = await supabase.from('pelanggan').select('PelangganID, NamaPelanggan');
    if (response.isNotEmpty) {
      setState(() {
        pelangganlist = List<Map<String, dynamic>>.from(response);
        selectedPelangganID = pelangganlist.isNotEmpty ? pelangganlist.first['PelangganID'] : null;
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content : Text('Gagal mengambil data pelanggan: $e')),
  
      );
  } 
}

void updateJumlahPesanan(int harga, int delta) {
  setState(() {
    if (delta > 0 && JumlahPesanan >= stokawal) return;
    if (delta < 0 && JumlahPesanan == 0) return;

    JumlahPesanan += delta;
    stokakhir = stokawal - JumlahPesanan;

    print("DEBUG: stokawal = $stokawal, JumlahPesanan, stokakhir = $stokakhir");
    TotalHarga = JumlahPesanan * harga;
  });
}

Future<void> simpan() async {
  final supabase = Supabase.instance.client;
  final produkid = widget.produk['ProdukID'];

 
if (produkid == null || selectedPelangganID == null || JumlahPesanan <= 0) {
  ScaffoldMessenger.of( context).showSnackBar(
    SnackBar(content: Text('Semua wajib diisi')),
  );
  return;
} 



  try {
    final penjualan = await supabase.from('penjualan').insert({
      'TotalHarga': TotalHarga,
      'PelangganID': selectedPelangganID,
    }).select().single();

    if (penjualan.isNotEmpty) {
      final PenjualanID = penjualan['PenjualanID'];
      await supabase.from('detailpenjualan').insert({
        'PenjualanID': PenjualanID,
        'ProdukID': produkid,
        'JumlahProduk': JumlahPesanan,
        'SubTotal': TotalHarga,
      }).select().single();

      await supabase.from('produk').update({
        'Stok' : stokakhir,
      }).match({'ProdukID': produkid});

      setState(() {
        stokawal -= JumlahPesanan;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil disimpan')),
      );

      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AdminHomepage()));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final harga = produk['Harga'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
               ),
               child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Produk: ${produk['NamaProduk'] ?? 'Tidak Tersedia'}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Text('Harga: $harga', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Text('Stok: $stokawal', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedPelangganID,
                      items: pelangganlist.map((pelanggan){
                        return DropdownMenuItem<int>(
                          value: pelanggan['PelangganID'],
                          child: Text(pelanggan['NamaPelanggan']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPelangganID = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Pilih Pelanggan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => updateJumlahPesanan(harga, 1),
                          icon: const Icon(Icons.remove),
                          ),
                          Text('$JumlahPesanan', style: const TextStyle(fontSize: 20)),
                          IconButton(
                            onPressed: () => updateJumlahPesanan(harga, -1),
                            icon: const Icon(Icons.add), 
                            ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup', style: TextStyle(fontSize: 20)),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              if (JumlahPesanan > 0) {
                                await simpan();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Jumlah pesanan harus lebih dari 0')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade300,
                            ),
                            child: Text('Pesan ($TotalHarga)', style: const TextStyle(fontSize: 20)),
                          ),
                      ],
                    ),
                  ],
                ),
                ),
          ),
          ),
      ),
    );
  }
}