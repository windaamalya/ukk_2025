import 'package:flutter/material.dart';
import 'package:ukk_2025/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPelanggan extends StatefulWidget {
  final int PelangganID;

  const EditPelanggan({super.key,required this.PelangganID});

  @override
  State<EditPelanggan> createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPelanggan> {
  final _namapelanggan = TextEditingController();
  final _alamat = TextEditingController();
  final _notlp = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _loadPelangganData();
  }


  Future<void> _loadPelangganData() async {
    final data = await Supabase.instance.client
    .from('pelanggan')
    .select()
    .eq('PelangganID', widget.PelangganID)
    .single();

    setState(() {
      _namapelanggan.text = data['NamaPelanggan'] ?? '';
      _alamat.text = data['Alamat'] ?? '';
      _notlp.text = data['NomorTelepon'] ?? '';
    });
  }

  Future<void> updatePelanggan() async {
    if (_formkey.currentState!.validate()) {

      await Supabase.instance.client.from('pelanggan').update({
        'NamaPelanggan': _namapelanggan.text,
        'Alamat': _alamat.text,
        'NomorTelepon': _notlp.text,
    }).eq('PelangganID', widget.PelangganID);


    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => AdminHomepage(),)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pelanggan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
         key: _formkey,
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _namapelanggan,
              decoration: const InputDecoration(
                labelText: 'Nama Pelanggan',
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
              controller: _alamat,
              decoration: const InputDecoration(
                labelText: 'Alamat',
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
            TextFormField(
              controller: _notlp,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor telepon tdak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: updatePelanggan, 
              child: const Text('Update'),
              ),
          ],
         ),
         ),
        ), 
    );
  }
}