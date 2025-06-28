import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditRecipePage extends StatefulWidget {
  const EditRecipePage({super.key});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _fotoUrlController = TextEditingController();
  final _bahanController = TextEditingController();

  final List<String> _bahanList = [];
  bool _isLoading = false;
  String? _errorMessage;
  late DocumentSnapshot _recipeDoc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recipeDoc = ModalRoute.of(context)?.settings.arguments as DocumentSnapshot;

    _namaController.text = _recipeDoc['nama_resep'] ?? '';
    _deskripsiController.text = _recipeDoc['deskripsi_resep'] ?? '';
    _fotoUrlController.text = _recipeDoc['foto_url'] ?? '';
    final bahanRaw = _recipeDoc['bahan_resep'] ?? '';
    _bahanList.clear();
    _bahanList.addAll(bahanRaw.toString().split(';').where((e) => e.isNotEmpty));
  }

  Future<void> _updateRecipe() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_bahanList.isEmpty) {
      setState(() {
        _errorMessage = 'Minimal masukkan 1 bahan.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(_recipeDoc.id)
          .update({
        'nama_resep': _namaController.text.trim(),
        'deskripsi_resep': _deskripsiController.text.trim(),
        'foto_url': _fotoUrlController.text.trim().isEmpty
            ? null
            : _fotoUrlController.text.trim(),
        'bahan_resep': _bahanList.join(';'),
      });

      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Resep berhasil diperbarui!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memperbarui resep: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addBahan() {
    final text = _bahanController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _bahanList.add(text);
      _bahanController.clear();
    });
  }

  void _removeBahan(int index) {
    setState(() {
      _bahanList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Resep'),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fastfood),
                        labelText: 'Nama Resep',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Nama resep wajib diisi'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _deskripsiController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        labelText: 'Deskripsi Resep',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Deskripsi wajib diisi'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _fotoUrlController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.image),
                        labelText: 'Foto URL (Opsional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bahanController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.kitchen),
                              labelText: 'Tambah Bahan',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addBahan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 12),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_bahanList.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bahan:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ..._bahanList.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final bahan = entry.value;
                                return Row(
                                  children: [
                                    const Icon(Icons.check,
                                        size: 16, color: Colors.deepOrange),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(bahan)),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          size: 20, color: Colors.red),
                                      onPressed: () => _removeBahan(index),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _updateRecipe,
                        icon: const Icon(Icons.save),
                        label: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Simpan Perubahan'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
