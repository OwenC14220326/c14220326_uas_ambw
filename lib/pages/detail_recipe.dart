import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailRecipePage extends StatelessWidget {
  const DetailRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final docId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Resep'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').doc(docId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Resep tidak ditemukan.'));
          }

          final doc = snapshot.data!;
          final namaPembuat = doc['nama_pembuat'] ?? 'Anonim';
          final namaResep = doc['nama_resep'] ?? '';
          final deskripsi = doc['deskripsi_resep'] ?? '';
          final fotoUrl = doc['foto_url'];
          final bahanRaw = doc['bahan_resep'] ?? '';
          final bahanList = bahanRaw.toString().split(';').where((e) => e.isNotEmpty).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fotoUrl != null && fotoUrl.toString().isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      fotoUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.broken_image, size: 48)),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  namaResep,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Oleh: $namaPembuat',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                if (deskripsi.isNotEmpty)
                  Text(deskripsi),
                const SizedBox(height: 16),
                if (bahanList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bahan-bahan:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...bahanList.map(
                        (bahan) => Row(
                          children: [
                            const Icon(Icons.check, size: 16, color: Colors.deepOrange),
                            const SizedBox(width: 4),
                            Expanded(child: Text(bahan)),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/edit-recipe',
                        arguments: doc,
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Resep'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
