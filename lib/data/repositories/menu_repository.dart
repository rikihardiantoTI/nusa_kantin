import '../../domain/models/menu_item.dart';

class MenuRepository {
  List<MenuItem> getDaftarMenu() {
    return const [
      MenuItem(
        id: 'm1',
        nama: 'Nasi Ayam Geprek Sambal Matah',
        kategori: 'Makanan Berat',
        harga: 15000,
        deskripsi: 'Nasi putih hangat dengan dada ayam crispy geprek dan topping sambal matah segar khas Bali.',
      ),
      MenuItem(
        id: 'm2',
        nama: 'Mie Goreng Spesial Kampus',
        kategori: 'Makanan Berat',
        harga: 13000,
        deskripsi: 'Mie goreng bumbu kecap manis gurih lengkap dengan telur orak-arik, bakso, sawi, dan kerupuk.',
      ),
      MenuItem(
        id: 'm3',
        nama: 'Soto Ayam Lamongan',
        kategori: 'Makanan Berat',
        harga: 14000,
        deskripsi: 'Kuah kaldu kuning bening kaya rempah dengan suwiran ayam, soun, kol, telur rebus, dan koya.',
      ),
      MenuItem(
        id: 'm4',
        nama: 'Es Teh Manis Jumbo',
        kategori: 'Minuman',
        harga: 5000,
        deskripsi: 'Teh melati seduh segar dengan gula aren cair dan es batu kristal dalam gelas ukuran besar.',
      ),
      MenuItem(
        id: 'm5',
        nama: 'Es Kopi Susu Gula Aren',
        kategori: 'Minuman',
        harga: 12000,
        deskripsi: 'Espresso house blend dipadukan susu full cream dan gula aren organik.',
      ),
      MenuItem(
        id: 'm6',
        nama: 'Cireng Rujak Crispy',
        kategori: 'Camilan',
        harga: 8000,
        deskripsi: '8 potong cireng renyah di luar kenyal di dalam, disajikan dengan bumbu rujak pedas manis.',
      ),
      MenuItem(
        id: 'm7',
        nama: 'Pisang Bakar Cokelat Keju',
        kategori: 'Camilan',
        harga: 10000,
        deskripsi: 'Pisang kepok pilihan dibakar dengan mentega, ditaburi meses cokelat dan parutan keju cheddar.',
      ),
    ];
  }
}
