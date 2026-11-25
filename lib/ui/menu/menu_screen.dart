import 'package:flutter/material.dart';

import '../../domain/models/menu_item.dart';
import '../core/window_size.dart';
import 'menu_view_model.dart';
import 'widgets/menu_detail.dart';
import 'widgets/menu_grid.dart';
import 'widgets/menu_list.dart';

class MenuScreen extends StatelessWidget {
  final MenuViewModel viewModel;
  final VoidCallback? onCartTap;

  const MenuScreen({super.key, required this.viewModel, this.onCartTap});

  void _showDetailBottomSheet(BuildContext context, MenuItem item) {
    viewModel.pilihMenu(item);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return FractionallySizedBox(
              heightFactor: 0.75,
              child: MenuDetail(
                item: item,
                qty: viewModel.getJumlahPesanan(item.id),
                onAdd: () => viewModel.tambahPesanan(item),
                onRemove: () => viewModel.kurangiPesanan(item),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeClass = WindowSizeHelper.of(context);
    final isCompact = sizeClass == WindowSizeClass.compact;
    final horizontalPadding = isCompact ? 16.0 : 24.0;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final menus = viewModel.filteredMenus;
        final selected = viewModel.selectedMenu;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                10,
                horizontalPadding,
                10,
              ),
              color: const Color(0xFFF8F7F2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lokasi kantin',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Color(0xFF174D38),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Gedung Utama • Lantai 1',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: Color(0xFF647069),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE6E8E2)),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF174D38),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: viewModel.cariMenu,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Cari menu favorit',
                      hintStyle: const TextStyle(
                        color: Color(0xFF929A94),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF7D877F),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8EAE4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (viewModel.selectedKategori == 'Semua' &&
                      viewModel.searchQuery.isEmpty)
                    _PromoBanner(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Kategori',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text(
                        '${menus.length} menu',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF879087),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _CategoryRow(viewModel: viewModel),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  isCompact
                      ? MenuList(
                          items: menus,
                          selectedMenu: selected,
                          getQty: viewModel.getJumlahPesanan,
                          onSelect: (item) =>
                              _showDetailBottomSheet(context, item),
                          onAdd: viewModel.tambahPesanan,
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: sizeClass == WindowSizeClass.expanded
                                  ? 3
                                  : 2,
                              child: MenuGrid(
                                items: menus,
                                selectedMenu: selected,
                                getQty: viewModel.getJumlahPesanan,
                                onSelect: viewModel.pilihMenu,
                                onAdd: viewModel.tambahPesanan,
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(
                              flex: 2,
                              child: MenuDetail(
                                item: selected,
                                qty: selected == null
                                    ? 0
                                    : viewModel.getJumlahPesanan(selected.id),
                                onAdd: () {
                                  if (selected != null) {
                                    viewModel.tambahPesanan(selected);
                                  }
                                },
                                onRemove: () {
                                  if (selected != null) {
                                    viewModel.kurangiPesanan(selected);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                  if (isCompact && viewModel.totalItemPesanan > 0)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 12,
                      child: _FloatingCart(
                        viewModel: viewModel,
                        onTap: onCartTap,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.fromLTRB(18, 14, 118, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF174D38), Color(0xFF2F7657)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20174D38),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF7C66A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'MENU FAVORIT',
              style: TextStyle(
                color: Color(0xFF4A3818),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ayam Geprek\nNusantara',
            style: TextStyle(
              color: Colors.white,
              height: 1.05,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final MenuViewModel viewModel;

  const _CategoryRow({required this.viewModel});

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Makanan Berat':
        return Icons.lunch_dining_rounded;
      case 'Minuman':
        return Icons.local_cafe_rounded;
      case 'Camilan':
        return Icons.bakery_dining_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.kategoriList.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = viewModel.kategoriList[index];
          final selected = viewModel.selectedKategori == category;
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => viewModel.pilihKategori(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF174D38) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF174D38)
                      : const Color(0xFFE4E7DF),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconForCategory(category),
                    size: 17,
                    color: selected ? Colors.white : const Color(0xFF647069),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    category,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF4F5953),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FloatingCart extends StatelessWidget {
  final MenuViewModel viewModel;
  final VoidCallback? onTap;

  const _FloatingCart({required this.viewModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF174D38),
      borderRadius: BorderRadius.circular(16),
      elevation: 12,
      shadowColor: const Color(0x66174D38),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    Positioned(
                      right: 3,
                      top: 3,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2A65A),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${viewModel.totalItemPesanan}',
                          style: const TextStyle(
                            color: Color(0xFF4D3517),
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lihat keranjang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${viewModel.totalItemPesanan} item',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                viewModel.totalHargaFormatted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
