import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pelanggan/insert.dart';
import 'package:ukk_2025/pelanggan/update.dart';

class pelangganTab extends StatefulWidget {
   @override
  State<pelangganTab> createState() => _pelangganTabState();
}

class _pelangganTabState extends State<pelangganTab> {
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

@ override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletepelanggan(int PelangganID) async {
    try {
      await Supabase.instance.client.from('pelanggan').delete().eq('PelangganID', PelangganID);
      fetchPelanggan();
    } catch (e) {
      print('Error deleting pelanggan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      pelanggan.isEmpty
      ? Center(
        child: Text(
          'Tidak ada pelanggan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
      :ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: pelanggan.length,
        itemBuilder: (context, index) {
          final langgan = pelanggan[index];
          return Card(
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
                      langgan['NamaPelanggan'] ?? 'Pelanggan tidak tersedia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      langgan['Alamat'] ?? 'Alamat tidak tersedia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      langgan['NomorTelepon'] ?? 'Tidak tersedia',
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
                            final PelangganID = langgan['PelangganID'] ?? 0;
                            if (PelangganID != 0) {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => EditPelanggan(PelangganID: PelangganID),
                                  ),
                                );
                            } else {
                              print('ID Pelanggan tidak valid');
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,color: Colors.redAccent ),
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Hapus Pelanggan'),
                                  content: const Text('Apakah anda yakin ingin menghapus pelanggan ini?'),
                                  actions: [
                                    TextButton(
                                     onPressed: () => Navigator.pop(context),
                                     child: const Text('Batal'), 
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deletepelanggan(langgan['PelangganID']);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                );
                              }
                              );
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPelanggan()),
          );
        },
         backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}