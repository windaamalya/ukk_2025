import 'package:flutter/material.dart';
import 'package:ukk_2025/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPenjualan extends StatefulWidget {
  const AddPenjualan({super.key});

  @override
  State<AddPenjualan> createState() => _AddPenjualanState();
}

class _AddPenjualanState extends State<AddPenjualan> {

final _totalharga = TextEditingController();
final _pelangganid = TextEditingController();
final _formkey = GlobalKey<FormState>();



Future<void> prodk() async {
  if (_formkey.currentState!.validate()) {

    final String TotalHarga = _totalharga.text;
    final String PelangganID = _pelangganid.text;

    final response = await Supabase.instance.client.from('penjualan').insert(
      {
        'TotalHarga': TotalHarga,
        'PelangganID': PelangganID,

      }
    );
    if (response == null) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => AdminHomepage()),
        );
    } else {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => AdminHomepage())
        );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penjualan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _totalharga,
                decoration: const InputDecoration(
                  labelText: 'Total Harga',
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _pelangganid,
                decoration: const InputDecoration(
                  labelText: 'Pelanggan ID',
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: prodk,
                 child: const Text('Tambah'),
                 )
            ],
          ),
        ),
        ),
    );
  }
}