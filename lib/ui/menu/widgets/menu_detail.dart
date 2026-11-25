import 'package:flutter/material.dart';

import '../../../domain/models/menu_item.dart';
import 'menu_visual.dart';

class MenuDetail extends StatelessWidget {
  final MenuItem? item;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const MenuDetail({
    super.key,
    required this.item,
    required this.qty,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Pilih menu untuk melihat detail'),
        ),
      );
    }

    // Menggunakan LayoutBuilder untuk menyesuaikan tata letak berdasarkan lebar induk
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWidePanel = constraints.maxWidth >= 360;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE6EAE5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuVisual(
                      name: item!.nama,
                      category: item!.kategori,
                      height: isWidePanel ? 180 : 150,
                    ),
                    const SizedBox(height: 14),
                    Chip(
                      label: Text(item!.kategori),
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item!.nama,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item!.hargaFormatted,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Deskripsi Menu',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                item!.deskripsi,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              if (isWidePanel)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Jumlah di Keranjang: $qty',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    _buildCounterControls(context),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Jumlah di Keranjang: $qty',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    _buildCounterControls(context),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCounterControls(BuildContext context) {
    if (qty == 0) {
      return FilledButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Tambah ke Pesanan'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IconButton.outlined(
          onPressed: onRemove,
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$qty',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton.filled(onPressed: onAdd, icon: const Icon(Icons.add)),
      ],
    );
  }
}
