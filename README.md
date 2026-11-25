# NusaKantin

Aplikasi pemesanan menu kantin kampus yang responsif untuk Android, tablet, dan desktop.

## Fitur

- Pencarian dan filter kategori menu
- Detail menu dan pemilihan jumlah pesanan
- Keranjang pesanan dengan ringkasan harga
- Navigasi mobile dan desktop
- Dukungan orientasi landscape serta teks berukuran besar

## Hasil Widget Test Responsivitas

Pengujian ukuran layar menggunakan `tester.view.physicalSize`:

- **HP:** `Size(390, 844)` menampilkan `NavigationBar` dan `ListView`
- **Tablet/desktop:** `Size(900, 700)` menampilkan `NavigationRail`, `GridView`, dan panel detail

Perintah pengujian:

```bash
flutter test test/widget/responsive_layout_test.dart
```

Hasil: **4 dari 4 widget test lulus**.
