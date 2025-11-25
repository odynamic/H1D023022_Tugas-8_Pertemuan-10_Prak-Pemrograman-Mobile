import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';

class ProdukForm extends StatefulWidget {
  Produk? produk;
  ProdukForm({super.key, this.produk});

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();

  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      judul = "UBAH PRODUK";
      tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
      _namaProdukTextboxController.text = widget.produk!.namaProduk!;
      _hargaProdukTextboxController.text =
          widget.produk!.hargaProduk.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Kode Produk"),
                  controller: _kodeProdukTextboxController,
                  validator: (value) =>
                      value!.isEmpty ? "Kode Produk harus diisi" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Nama Produk"),
                  controller: _namaProdukTextboxController,
                  validator: (value) =>
                      value!.isEmpty ? "Nama Produk harus diisi" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number,
                  controller: _hargaProdukTextboxController,
                  validator: (value) =>
                      value!.isEmpty ? "Harga harus diisi" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.produk == null) {
                        Navigator.pop(
                          context,
                          Produk(
                            kodeProduk: _kodeProdukTextboxController.text,
                            namaProduk: _namaProdukTextboxController.text,
                            hargaProduk: int.parse(
                                _hargaProdukTextboxController.text),
                          ),
                        );
                      } else {
                        widget.produk!.kodeProduk =
                            _kodeProdukTextboxController.text;
                        widget.produk!.namaProduk =
                            _namaProdukTextboxController.text;
                        widget.produk!.hargaProduk = int.parse(
                            _hargaProdukTextboxController.text);

                        Navigator.pop(context, widget.produk);
                      }
                    }
                  },
                  child: Text(tombolSubmit),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
