import 'package:flutter/material.dart';
import 'package:ukk_2025/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProduk extends StatefulWidget {
  const AddProduk({super.key});

  @override
  State<AddProduk> createState() => _AddProdukState();
}

class _AddProdukState extends State<AddProduk> {
  final _namaproduk = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> prdk() async {
    if (_formkey.currentState!.validate()) {
      final String namaProduk = _namaproduk.text.trim();
      final int? harga = int.tryParse(_harga.text.trim());
      final int? stok = int.tryParse(_stok.text.trim());

    if (harga == null || stok == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harga dan stok harus berupa angka')),
      );
      return;
    }

    final response = await Supabase.instance.client.from('produk').insert({
      'NamaProduk': namaProduk,
      'Harga': harga,
      'Stok': stok,
    });

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomepage()),
          );
    }
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaproduk,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _harga,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: prdk,
                child: const Text('Tambah'),
                )
            ],
          ),
        ),
        ),
    );
  }
}