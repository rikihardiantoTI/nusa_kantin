import 'package:flutter/material.dart';

import '../core/window_size.dart';
import '../menu/menu_view_model.dart';

class PesananScreen extends StatelessWidget {
  final MenuViewModel viewModel;

  const PesananScreen({super.key, required this.viewModel});

  String _formatRupiah(int nominal) {
    final str = nominal.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeClass = WindowSizeHelper.of(context);
    final isSideBySide =
        orientation == Orientation.landscape ||
        sizeClass != WindowSizeClass.compact;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final entries = viewModel.daftarPesanan.entries.toList();

        if (entries.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F8F4),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE1F2E8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 54,
                        color: Color(0xFF1F7A4D),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Keranjang masih kosong',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pilih makanan atau minuman favoritmu\ndari halaman Menu.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF747B75),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final listSection = ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = entries[index].key;
            final qty = entries[index].value;
            final subtotal = item.harga * qty;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE7EBE6)),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: item.kategori == 'Minuman'
                          ? const Color(0xFFDCECE6)
                          : const Color(0xFFFFDFC6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.kategori == 'Minuman'
                          ? Icons.local_drink
                          : Icons.restaurant,
                      color: const Color(0xFF1F7A4D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nama,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatRupiah(subtotal),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF1F7A4D),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F5F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => viewModel.kurangiPesanan(item),
                          icon: const Icon(Icons.remove, size: 18),
                          tooltip: 'Kurangi',
                        ),
                        Text(
                          '$qty',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        IconButton(
                          onPressed: () => viewModel.tambahPesanan(item),
                          icon: const Icon(Icons.add, size: 18),
                          tooltip: 'Tambah',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );

        final summarySection = _buildSummaryCard(context);

        if (isSideBySide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    Expanded(child: listSection),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: summarySection,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _buildHeader(context),
            Expanded(child: listSection),
            const Divider(height: 1),
            Padding(padding: const EdgeInsets.all(16), child: summarySection),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pesanan Saya',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${viewModel.totalItemPesanan} item dalam keranjang',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: const Color(0xFF879087)),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE6E8E2)),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFF174D38),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF257D50), Color(0xFF155F3A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x262F7A51),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ringkasan Pesanan',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total item',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.78)),
              ),
              Text(
                '${viewModel.totalItemPesanan}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0x33FFFFFF)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Flexible(
                child: Text(
                  viewModel.totalHargaFormatted,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F7A4D),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              viewModel.hapusSemuaPesanan();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: const Text('Pesanan berhasil dikirim ke kantin!'),
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text(
              'Konfirmasi Pesanan',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
