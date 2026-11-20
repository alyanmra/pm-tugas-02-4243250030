import 'dart:io';

void main() {
  final Map<String, ({String nama, String kategori, int harga})> katalog = {
    'P01': (nama: 'Kopi Sidikalang 250 g', kategori: 'Kopi', harga: 45000),
    'P02': (nama: 'Kopi Gayo 250 g', kategori: 'Kopi', harga: 55000),
    'P03': (nama: 'Teh Kayu Aro 100 g', kategori: 'Teh', harga: 25000),
    'P04': (nama: 'Gula Aren 500 g', kategori: 'Pemanis', harga: 30000),
    'P05': (nama: 'Bolu Meranti', kategori: 'Makanan', harga: 80000),
  };

  String rupiah(int n) =>
      'Rp${n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';

  print('KATALOG TOKO');
  print('${'Kode'.padRight(6)}${'Nama'.padRight(24)}${'Harga'.padLeft(12)}');
  print('-' * 42);
  katalog.forEach((kode, p) {
    print('${kode.padRight(6)}${p.nama.padRight(24)}${rupiah(p.harga).padLeft(12)}');
  });
  print('-' * 42);

  stdout.write('Pesanan (contoh: P01x2, P03x1): ');
  final String input = stdin.readLineSync() ?? '';

  final List<({String kode, int jumlah})> valid = [];
  final List<String> ditolak = [];

  for (final bagian in input.split(',')) {
    final item = bagian.trim();
    if (item.isEmpty) continue;

    final pecah = item.toUpperCase().split('X');
    if (pecah.length != 2) {
      ditolak.add('$item (format salah)');
      continue;
    }

    final kode = pecah[0].trim();
    final jumlah = int.tryParse(pecah[1].trim()); 
    final produk = katalog[kode]; 

    if (produk == null) {
      ditolak.add('$item (kode tidak ada)');
      continue;
    }
    if (jumlah == null || jumlah <= 0) {
      ditolak.add('$item (jumlah tidak valid)');
      continue;
    }
    valid.add((kode: kode, jumlah: jumlah));
  }

  if (valid.isEmpty) {
    print('\nTidak ada pesanan yang valid.');
    if (ditolak.isNotEmpty) print('Ditolak: ${ditolak.join(', ')}');
    return;
  }

  final baris = valid.map((v) {
    final p = katalog[v.kode]!; 
    return (
      nama: p.nama,
      kategori: p.kategori,
      jumlah: v.jumlah,
      harga: p.harga,
      subtotal: p.harga * v.jumlah,
    );
  }).toList();

  final int total = baris.fold<int>(0, (sum, b) => sum + b.subtotal);
  final int diskon = total >= 100000 ? total ~/ 10 : 0;
  final int bayar = total - diskon;
  final Set<String> kategori = baris.map((b) => b.kategori).toSet();

  print('\n=== STRUK BELANJA ===');
  for (final b in baris) {
    print('${b.nama.padRight(24)}${b.jumlah.toString().padLeft(3)} x '
        '${rupiah(b.harga).padLeft(9)} = ${rupiah(b.subtotal).padLeft(10)}');
  }
  print('-' * 52);
  print('${'Total'.padRight(40)}${rupiah(total).padLeft(12)}');
  print('${'Diskon 10%'.padRight(40)}${('-${rupiah(diskon)}').padLeft(12)}');
  print('${'Jumlah bayar'.padRight(40)}${rupiah(bayar).padLeft(12)}');
  print('\nKategori dibeli : ${kategori.join(', ')}');
  if (ditolak.isNotEmpty) {
    print('Item ditolak    : ${ditolak.join(', ')}');
  }
}