import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  Produk? produk;
  ProdukForm({super.key, this.produk});

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK";
        tombolSubmit = "UBAH";
        _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _textKode(),
              _textNama(),
              _textHarga(),
              _buttonSubmit()
            ],
          ),
        ),
      ),
    );
  }

  Widget _textKode() => TextFormField(
        controller: _kodeProdukTextboxController,
        decoration: const InputDecoration(labelText: "Kode Produk"),
        validator: (value) => value!.isEmpty ? "Kode harus diisi" : null,
      );

  Widget _textNama() => TextFormField(
        controller: _namaProdukTextboxController,
        decoration: const InputDecoration(labelText: "Nama Produk"),
        validator: (value) => value!.isEmpty ? "Nama harus diisi" : null,
      );

  Widget _textHarga() => TextFormField(
        controller: _hargaProdukTextboxController,
        decoration: const InputDecoration(labelText: "Harga"),
        keyboardType: TextInputType.number,
        validator: (value) => value!.isEmpty ? "Harga harus diisi" : null,
      );

  Widget _buttonSubmit() => OutlinedButton(
        child: Text(tombolSubmit),
        onPressed: () {
          if (_formKey.currentState!.validate() && !_isLoading) {
            widget.produk != null ? ubah() : simpan();
          }
        },
      );

  simpan() {
    setState(() => _isLoading = true);
    Produk p = Produk(id: null);
    p.kodeProduk = _kodeProdukTextboxController.text;
    p.namaProduk = _namaProdukTextboxController.text;
    p.hargaProduk = int.parse(_hargaProdukTextboxController.text);

    ProdukBloc.addProduk(produk: p).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ProdukPage()));
    }).catchError((_) {
      showDialog(
          context: context,
          builder: (_) =>
              const WarningDialog(description: "Simpan gagal, coba lagi"));
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  ubah() {
    setState(() => _isLoading = true);
    Produk p = Produk(id: widget.produk!.id!);
    p.kodeProduk = _kodeProdukTextboxController.text;
    p.namaProduk = _namaProdukTextboxController.text;
    p.hargaProduk = int.parse(_hargaProdukTextboxController.text);

    ProdukBloc.updateProduk(produk: p).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ProdukPage()));
    }).catchError((_) {
      showDialog(
          context: context,
          builder: (_) =>
              const WarningDialog(description: "Ubah gagal, coba lagi"));
    }).whenComplete(() => setState(() => _isLoading = false));
  }
}
