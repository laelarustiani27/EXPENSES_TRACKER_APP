import 'package:intl/intl.dart';

class Strings {
  static const String appName = 'Expense Tracker';

  static const String dashboard = 'Dashboard';
  static const String availableBalance = 'Saldo Tersedia';
  static const String spent = 'Terpakai';
  static const String earned = 'Diterima';
  static const String recentTransactions = 'Transaksi Terbaru';

  static const String transactions = 'Transaksi';
  static const String expense = 'Pengeluaran';
  static const String income = 'Pemasukan';

  static const String travel = 'Perjalanan';
  static const String food = 'Makanan';
  static const String shopping = 'Belanja';
  static const String entertainment = 'Hiburan';
  static const String bills = 'Tagihan';
  static const String other = 'Lainnya';

  static const String indigoTicket = 'Tiket Indigo';
  static const String groceries = 'Belanja kebutuhan';
  static const String movieTicket = 'Tiket bioskop';
  static const String electricity = 'Tagihan listrik';
  static const String salary = 'Gaji';

  static const String addTransaction = 'Tambah Transaksi';
  static const String viewAll = 'Lihat Semua';

  static const List<String> months = [
    'JAN','FEB','MAR','APR','MEI','JUN',
    'JUL','AGT','SEP','OKT','NOV','DES'
  ];

  static String getMonthYear(DateTime date) {
    return '${months[date.month - 1]} ${date.year}';
  }

  static String formatCurrency(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}