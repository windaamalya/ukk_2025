import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class pelangganTab extends StatefulWidget {
  const pelangganTab({super.key});

  @override
  State<pelangganTab> createState() => _pelangganTabState();
}

class _pelangganTabState extends State<pelangganTab> {
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;
@override
  void initState(){
    super.initState();
    fatchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false,
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}