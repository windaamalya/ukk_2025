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
  int jumlahPesanan = 0;
  int totalHarga = 0;
  int stokAwal = 0;
  int stokSisa = 0;
  int? selectedPelangganID;
  List<Map<String, dynamic>> pelangganList = [];

  @override
  void initState() {
    super.initState();
    stokAwal = widget.produk['Stok'] ?? 0;
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('pelanggan').select('PelangganID, NamaPelanggan');
      if (response.isNotEmpty) {
        setState(() {
          pelangganList = List<Map<String, dynamic>>.from(response);
          selectedPelangganID = pelangganList.first['PelangganID'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pelanggan: $e')),
      );
    }
  }

  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      if (delta > 0 && jumlahPesanan >= stokAwal) return;
      jumlahPesanan += delta;
      if (jumlahPesanan < 0) jumlahPesanan = 0;
      stokSisa = stokAwal - jumlahPesanan;
      totalHarga = jumlahPesanan * harga;
    });
  }

  Future<void> simpan() async {
    final supabase = Supabase.instance.client;
    final produkID = widget.produk['ProdukID'];

    if (produkID == null || selectedPelangganID == null || jumlahPesanan <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua wajib diisi')),
      );
      return;
    }

    try {
      final penjualan = await supabase.from('penjualan').insert({
        'TotalHarga': totalHarga,
        'PelangganID': selectedPelangganID,
      }).select().single();

      if (penjualan.isNotEmpty) {
        final penjualanID = penjualan['PenjualanID'];
        await supabase.from('detailpenjualan').insert({
          'PenjualanID': penjualanID,
          'ProdukID': produkID,
          'JumlahProduk': jumlahPesanan,
          'SubTotal': totalHarga,
        }).select().single();

        await supabase.from('produk').update({
          'Stok': stokAwal - jumlahPesanan,
        }).match({'ProdukID': produkID});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil disimpan')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomepage()),
        );
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
          padding: const EdgeInsets.all(16),
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
                  Text('Harga: $harga', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  Text('Stok: $stokAwal', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedPelangganID,
                    items: pelangganList.map((pelanggan) {
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
                        onPressed: () => updateJumlahPesanan(harga, -1),
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$jumlahPesanan', style: const TextStyle(fontSize: 20)),
                      IconButton(
                        onPressed: () => updateJumlahPesanan(harga, 1),
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
                        onPressed: jumlahPesanan > 0 ? simpan : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                        ),
                        child: Text('Pesan ($totalHarga)', style: const TextStyle(fontSize: 20)),
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