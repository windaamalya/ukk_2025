import 'package:flutter/material.dart';
import 'package:ukk_2025/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProduk extends StatefulWidget {
  final int ProdukID;

  const EditProduk({super.key,required this.ProdukID});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _namaproduk = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
 void initState(){
  super.initState();
  _loadProdukData();
 }

 Future<void> _loadProdukData() async {
  final data = await Supabase.instance.client
  .from('produk')
  .select()
  .eq('ProdukID', widget.ProdukID)
  .single();

setState(() {
  _namaproduk.text = data['NamaProduk'] ?? '';
  _harga.text = (data['Harga'] ?? 0).toString();
  _stok.text = (data['Stok'] ?? 0).toString();
});
 }

 Future<void> updateProduk() async {
  if (_formkey.currentState!.validate()) {

    await Supabase.instance.client.from('produk').update({
      'NamaProduk': _namaproduk.text,
      'Harga': _harga.text,
      'Stok': _stok.text,
    }).eq('ProdukID', widget.ProdukID);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminHomepage()), 
      );
  }
 }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
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
                validator: (value){
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateProduk,
                child: const Text('Update'),
                )
            ],
          ),
        )
        ),
    );
  }
}