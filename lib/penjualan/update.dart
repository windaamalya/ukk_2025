import 'package:flutter/material.dart';
import 'package:ukk_2025/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPenjualan extends StatefulWidget {
 final int PenjualanID;

 const EditPenjualan({super.key,required this.PenjualanID});

  @override
  State<EditPenjualan> createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPenjualan> {

  final _totalharga =  TextEditingController();
  final _pelangganid = TextEditingController();
  final _formkey = GlobalKey<FormState>();

@override
void initState(){
  super.initState();
  _loadPenjualanData();
}


Future<void> _loadPenjualanData() async {
  final data = await Supabase.instance.client
  .from('penjualan')
  .select()
  .eq('PenjualanID', widget.PenjualanID)
  .single();

  setState(() {


    _totalharga.text = data['TotalHarga']?.toString() ?? '';
    _pelangganid.text = data['PelangganID']?.toString() ?? '';
  });
}

Future<void> updatePenjualan() async {

  try {
    if (_formkey.currentState!.validate()) {

      await Supabase.instance.client.from('penjualan').update({
        'TotalHarga': _totalharga.text,
        'PelangganID': _pelangganid.text,
      }).eq('PenjualanID', widget.PenjualanID);


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomepage()),
      );
    }
  } catch (e){
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
                controller: _totalharga,
                decoration: const InputDecoration(
                  labelText: 'Total Harga',
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
                controller: _pelangganid,
                decoration: const InputDecoration(
                  labelText: 'Pelanggan ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value ==  null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updatePenjualan,
                 child: const Text('Update'),
                 )
            ],
          ),
        ),
        ),
    );
  }
}