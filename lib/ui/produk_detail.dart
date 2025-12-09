import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/widget/success_dialog.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;
  const ProdukDetail({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProdukForm(produk: widget.produk)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Kode: ${widget.produk.kodeProduk ?? ''}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Nama: ${widget.produk.namaProduk ?? ''}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Harga: ${widget.produk.hargaProduk}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Hapus'),
              content: const Text('Yakin ingin menghapus produk ini?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _delete();
                    },
                    child: const Text('Hapus'))
              ],
            ));
  }

  void _delete() {
    setState(() => _isLoading = true);
    ProdukBloc.deleteProduk(id: int.parse(widget.produk.id!)).then((success) {
      if (success) {
        showDialog(context: context, barrierDismissible: false, builder: (context) => SuccessDialog(description: 'Produk berhasil dihapus', okClick: () {
          Navigator.pop(context); // dialog
          Navigator.pop(context); // detail
        }));
      } else {
        showDialog(context: context, barrierDismissible: false, builder: (context) => const WarningDialog(description: 'Gagal hapus produk'));
      }
    }, onError: (error) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => const WarningDialog(description: 'Gagal hapus produk'));
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
}
