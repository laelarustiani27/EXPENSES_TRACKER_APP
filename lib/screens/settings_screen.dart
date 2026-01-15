import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Positioned(
            bottom: -200,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B0000).withValues(alpha: 0.4),
                    const Color(0xFF4A0000).withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context,
                            title: 'Update information',
                            onTap: () {
                              Navigator.pushNamed(context, '/update-info');
                            },
                          ),
                          const SizedBox(height: 8),

                          _buildMenuItem(
                            context,
                            title: 'Profile',
                            onTap: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Mata Uang',
                            subtitle: 'IDR (Rupiah)',
                            onTap: () {
                              _showCurrencyDialog(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Bahasa',
                            subtitle: 'Indonesia',
                            onTap: () {
                              _showLanguageDialog(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildSwitchItem(
                            title: 'Notifikasi',
                            value: true,
                            onChanged: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Notifikasi ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),

                          _buildMenuItem(
                            context,
                            title: 'Kelola Data',
                            onTap: () {
                              _showDataManagementDialog(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Pengaturan Budget',
                            subtitle: 'Atur batas pengeluaran bulanan',
                            onTap: () {
                              _showBudgetDialog(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Ekspor Data',
                            subtitle: 'Unduh laporan keuangan',
                            onTap: () {
                              _showExportDialog(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Keamanan',
                            subtitle: 'Ubah password & autentikasi',
                            onTap: () {
                              _showSecurityDialog(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Pengingat',
                            subtitle: 'Atur pengingat pembayaran',
                            onTap: () {
                              _showReminderDialog(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Kelola Kategori',
                            subtitle: 'Tambah/edit kategori transaksi',
                            onTap: () {
                              _showCategoryDialog(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Tentang Aplikasi',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      backgroundColor: const Color(0xFF1A1A1A),
                                      title: const Text(
                                        'Tentang Aplikasi',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: const Text(
                                        'Aplikasi pengelolaan keuangan pribadi.\nVersi 1.0.0',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text(
                                            'Tutup',
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            context,
                            title: 'Logout',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logout berhasil (dummy).'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            isDanger: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    width: 140,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDanger ? Colors.redAccent : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDanger ? Colors.redAccent : Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Pilih Mata Uang',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'IDR (Rupiah)',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Pilih Bahasa',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Indonesia',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  void _showDataManagementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Kelola Data',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Fitur kelola data belum diimplementasi.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _showBudgetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Pengaturan Budget',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Fitur pengaturan budget belum diimplementasi.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Ekspor Data',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Fitur ekspor data belum diimplementasi.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Keamanan',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Fitur keamanan belum diimplementasi.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Pengingat',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Fitur pengingat belum diimplementasi.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Kelola Kategori',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Fitur kelola kategori belum diimplementasi.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }
}
