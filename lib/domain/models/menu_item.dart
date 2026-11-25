class MenuItem {
  final String id;
  final String nama;
  final String kategori;
  final int harga;
  final String deskripsi;

  const MenuItem({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.deskripsi,
  });

  String get hargaFormatted {
    final str = harga.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }
}
