import 'package:flutter/foundation.dart';

import '../../data/repositories/menu_repository.dart';
import '../../domain/models/menu_item.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuRepository _repository;

  late final List<MenuItem> _allMenus;
  String _selectedKategori = 'Semua';
  String _searchQuery = '';
  MenuItem? _selectedMenu;
  final Map<String, int> _pesanan = {};

  MenuViewModel(this._repository) {
    _allMenus = _repository.getDaftarMenu();
    if (_allMenus.isNotEmpty) {
      _selectedMenu = _allMenus.first;
    }
  }

  List<String> get kategoriList {
    final set = <String>{'Semua'};
    for (final item in _allMenus) {
      set.add(item.kategori);
    }
    return set.toList();
  }

  String get selectedKategori => _selectedKategori;

  List<MenuItem> get filteredMenus {
    return _allMenus.where((item) {
      final matchesCategory =
          _selectedKategori == 'Semua' || item.kategori == _selectedKategori;
      final query = _searchQuery.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          item.nama.toLowerCase().contains(query) ||
          item.kategori.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  String get searchQuery => _searchQuery;

  MenuItem? get selectedMenu => _selectedMenu;

  Map<MenuItem, int> get daftarPesanan {
    final result = <MenuItem, int>{};
    for (final entry in _pesanan.entries) {
      final menu = _allMenus.firstWhere((m) => m.id == entry.key);
      result[menu] = entry.value;
    }
    return result;
  }

  int get totalItemPesanan => _pesanan.values.fold(0, (sum, qty) => sum + qty);

  int get totalHargaPesanan {
    int total = 0;
    for (final entry in _pesanan.entries) {
      final menu = _allMenus.firstWhere((m) => m.id == entry.key);
      total += menu.harga * entry.value;
    }
    return total;
  }

  String get totalHargaFormatted {
    final str = totalHargaPesanan.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  int getJumlahPesanan(String menuId) => _pesanan[menuId] ?? 0;

  void pilihKategori(String kategori) {
    _selectedKategori = kategori;
    final list = filteredMenus;
    if (list.isNotEmpty &&
        (_selectedMenu == null || !list.contains(_selectedMenu))) {
      _selectedMenu = list.first;
    }
    notifyListeners();
  }

  void cariMenu(String query) {
    _searchQuery = query.trim();
    final list = filteredMenus;
    if (list.isNotEmpty &&
        (_selectedMenu == null || !list.contains(_selectedMenu))) {
      _selectedMenu = list.first;
    }
    notifyListeners();
  }

  void pilihMenu(MenuItem item) {
    _selectedMenu = item;
    notifyListeners();
  }

  void tambahPesanan(MenuItem item) {
    _pesanan[item.id] = (_pesanan[item.id] ?? 0) + 1;
    notifyListeners();
  }

  void kurangiPesanan(MenuItem item) {
    final current = _pesanan[item.id] ?? 0;
    if (current > 1) {
      _pesanan[item.id] = current - 1;
    } else {
      _pesanan.remove(item.id);
    }
    notifyListeners();
  }

  void hapusSemuaPesanan() {
    _pesanan.clear();
    notifyListeners();
  }
}
