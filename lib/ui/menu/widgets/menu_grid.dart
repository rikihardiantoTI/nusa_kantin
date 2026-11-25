import 'package:flutter/material.dart';

import '../../../domain/models/menu_item.dart';
import 'menu_visual.dart';

class MenuGrid extends StatelessWidget {
  final List<MenuItem> items;
  final MenuItem? selectedMenu;
  final int Function(String menuId) getQty;
  final ValueChanged<MenuItem> onSelect;
  final ValueChanged<MenuItem> onAdd;

  const MenuGrid({
    super.key,
    required this.items,
    required this.selectedMenu,
    required this.getQty,
    required this.onSelect,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    // Menyesuaikan tinggi sel agar aman saat skala teks 200%
    final mainAxisExtent = textScale > 1.3 ? 410.0 : 350.0;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: mainAxisExtent,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final qty = getQty(item.id);
        final isSelected = selectedMenu?.id == item.id;

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onSelect(item),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuVisual(name: item.nama, category: item.kategori),
                  const SizedBox(height: 10),
                  Text(
                    item.kategori,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.deskripsi,
                    maxLines: textScale > 1.3 ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF747B75),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.hargaFormatted,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => onAdd(item),
                        tooltip: 'Tambah pesanan',
                        icon: Badge(
                          isLabelVisible: qty > 0,
                          label: Text('$qty'),
                          child: const Icon(Icons.add_shopping_cart, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
