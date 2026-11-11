import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../providers/saved_recipe_provider.dart';
import '../providers/app_settings_provider.dart';
import '../widgets/profile_info_tile.dart';

import 'dart:convert';

import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showThemeSettings(BuildContext context, AppSettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tema Aplikasi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              RadioGroup<ThemeMode>(
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    settings.setThemeMode(value);
                  }
                },
                child: Column(
                  children: [
                    _themeOption(
                      ThemeMode.light,
                      'Terang',
                      'Gunakan tampilan terang',
                      Icons.light_mode_outlined,
                    ),
                    _themeOption(
                      ThemeMode.dark,
                      'Gelap',
                      'Gunakan tampilan gelap',
                      Icons.dark_mode_outlined,
                    ),
                    _themeOption(
                      ThemeMode.system,
                      'Mengikuti Perangkat',
                      'Sesuaikan dengan tema perangkat',
                      Icons.settings_brightness_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _themeOption(
    ThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return RadioListTile<ThemeMode>(
      value: mode,
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      activeColor: const Color(0xFFE8873A),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showLanguageSettings(
    BuildContext context,
    AppSettingsProvider settings,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bahasa Aplikasi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: settings.locale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    settings.setLanguage(value);
                    Navigator.pop(sheetContext);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'id',
                      title: Text('Bahasa Indonesia'),
                      secondary: Text('🇮🇩'),
                      activeColor: Color(0xFFE8873A),
                    ),
                    RadioListTile<String>(
                      value: 'en',
                      title: Text('English'),
                      secondary: Text('🇬🇧'),
                      activeColor: Color(0xFFE8873A),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInfo(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showEditProfile(
    BuildContext context,
    ProfileProvider profile,
    bool isEnglish,
  ) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);
    final bioController = TextEditingController(text: profile.bio);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEnglish ? 'Edit Profile' : 'Edit Profil'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: isEnglish ? 'Name' : 'Nama',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return isEnglish
                            ? 'Name cannot be empty'
                            : 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                          .hasMatch(value.trim())) {
                        return isEnglish
                            ? 'Invalid email address'
                            : 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: isEnglish ? 'Bio' : 'Tentang Saya',
                      prefixIcon: const Icon(Icons.edit_note),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(isEnglish ? 'Cancel' : 'Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE8873A),
              ),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                await profile.updateProfile(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  bio: bioController.text.trim(),
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(isEnglish ? 'Save' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showPhotoOptions(
    BuildContext context,
    ProfileProvider profile,
    bool isEnglish,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFFE8873A),
                  ),
                  title: Text(
                    isEnglish ? 'Choose from Gallery' : 'Pilih dari Galeri',
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    try {
                      await profile.pickProfilePhoto();
                    } catch (e) {
                      debugPrint('ERROR PILIH FOTO: $e');

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal memilih foto: $e'),
                            duration: const Duration(seconds: 8),
                          ),
                        );
                      }
                    }
                  },
                ),
                if (profile.photoBase64 != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: Text(isEnglish ? 'Remove Photo' : 'Hapus Foto'),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      await profile.removeProfilePhoto();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmResetProfile(
    BuildContext context,
    ProfileProvider profile,
    bool isEnglish,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEnglish ? 'Reset Profile?' : 'Reset Profil?'),
        content: Text(
          isEnglish ? 'All profile information and photo will be reset.' : 'Semua informasi dan foto profil akan dikembalikan ke kondisi awal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(isEnglish ? 'Cancel' : 'Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await profile.resetProfile();

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(isEnglish ? 'Reset' : 'Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedProvider = context.watch<SavedRecipeProvider>();
    final recipeProvider = context.watch<RecipeProvider>();
    final settings = context.watch<AppSettingsProvider>();
    final profile = context.watch<ProfileProvider>();

    final savedCount = savedProvider.savedRecipes.length;
    final favoriteCount = recipeProvider.favoriteRecipes.length;

    final isEnglish = settings.locale.languageCode == 'en';

    final themeLabel = settings.themeMode == ThemeMode.light
        ? (isEnglish ? 'Light' : 'Terang')
        : settings.themeMode == ThemeMode.dark
        ? (isEnglish ? 'Dark' : 'Gelap')
        : (isEnglish ? 'Follow device' : 'Ikuti perangkat');

    final languageLabel = isEnglish ? 'English' : 'Bahasa Indonesia';

    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text(isEnglish ? 'Profile' : 'Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu profil pengguna
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xFFFFE0C2),
                        backgroundImage: profile.photoBase64 != null
                            ? MemoryImage(base64Decode(profile.photoBase64!))
                            : null,
                        child: profile.photoBase64 == null
                            ? const Icon(
                                Icons.person,
                                size: 55,
                                color: Color(0xFFE8873A),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () =>
                              _showPhotoOptions(context, profile, isEnglish),
                          child: const CircleAvatar(
                            radius: 17,
                            backgroundColor: Color(0xFFE8873A),
                            child: Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  if (profile.email.isNotEmpty)
                    Text(
                      profile.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.65),
                        fontSize: 13,
                      ),
                    ),

                  const SizedBox(height: 5),

                  Text(
                    profile.bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.65),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          _showEditProfile(context, profile, isEnglish),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(isEnglish ? 'Edit Profile' : 'Edit Profil'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE8873A),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatistic(
                          Icons.menu_book,
                          savedCount.toString(),
                          isEnglish ? 'My Recipes' : 'Resepku',
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 1,
                        color: Colors.grey.shade400,
                      ),
                      Expanded(
                        child: _buildStatistic(
                          Icons.favorite,
                          favoriteCount.toString(),
                          isEnglish ? 'Favorites' : 'Favorit',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            _sectionTitle(isEnglish ? 'Settings' : 'Pengaturan'),
            const SizedBox(height: 12),

            ProfileInfoTile(
              icon: Icons.palette_outlined,
              title: isEnglish ? 'App Theme' : 'Tema Aplikasi',
              subtitle: themeLabel,
              onTap: () => _showThemeSettings(context, settings),
            ),

            ProfileInfoTile(
              icon: Icons.language,
              title: isEnglish ? 'Language' : 'Bahasa',
              subtitle: languageLabel,
              onTap: () => _showLanguageSettings(context, settings),
            ),

            Card(
              elevation: 0,
              color: surfaceColor,
              margin: const EdgeInsets.only(bottom: 10),
              child: SwitchListTile(
                secondary: const CircleAvatar(
                  backgroundColor: Color(0xFFFFE0C2),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFFE8873A),
                  ),
                ),
                title: Text(isEnglish ? 'Notifications' : 'Notifikasi'),
                subtitle: Text(
                  settings.notificationsEnabled
                      ? (isEnglish ? 'Enabled' : 'Aktif')
                      : (isEnglish ? 'Disabled' : 'Nonaktif'),
                ),
                activeThumbColor: const Color(0xFFE8873A),
                value: settings.notificationsEnabled,
                onChanged: settings.setNotifications,
              ),
            ),

            const SizedBox(height: 18),

            _sectionTitle(isEnglish ? 'Help' : 'Bantuan'),
            const SizedBox(height: 12),

            ProfileInfoTile(
              icon: Icons.help_outline,
              title: isEnglish ? 'User Guide' : 'Panduan Penggunaan',
              subtitle: isEnglish
                  ? 'How to use RecipeMate'
                  : 'Cara menggunakan fitur RecipeMate',
              onTap: () {
                _showInfo(
                  context,
                  isEnglish ? 'User Guide' : 'Panduan RecipeMate',
                  isEnglish
                      ? 'Home: view recipe recommendations.\n\n'
                            'Explore: search and filter recipes.\n\n'
                            'My Recipes: add, edit, and delete your recipes.\n\n'
                            'Favorites: view recipes you like.\n\n'
                            'Profile: manage app settings.'
                      : 'Beranda: melihat rekomendasi resep.\n\n'
                            'Jelajahi: mencari dan memfilter resep.\n\n'
                            'Resepku: menambahkan, mengedit, dan menghapus resep.\n\n'
                            'Favorit: melihat resep yang disukai.\n\n'
                            'Profil: mengatur aplikasi.',
                );
              },
            ),

            ProfileInfoTile(
              icon: Icons.info_outline,
              title: isEnglish ? 'About RecipeMate' : 'Tentang RecipeMate',
              subtitle: isEnglish
                  ? 'Application information'
                  : 'Informasi mengenai aplikasi',
              onTap: () {
                _showInfo(
                  context,
                  isEnglish ? 'About RecipeMate' : 'Tentang RecipeMate',
                  isEnglish
                      ? 'RecipeMate is a recipe exploration and personal '
                            'recipe management application.'
                      : 'RecipeMate adalah aplikasi eksplorasi dan '
                            'penyimpanan resep masakan. Aplikasi ini membantu '
                            'pengguna menemukan inspirasi masakan serta '
                            'mengelola resep pribadi dengan mudah.',
                );
              },
            ),
            ProfileInfoTile(
              icon: Icons.restart_alt,
              title: isEnglish ? 'Reset Profile' : 'Reset Profil',
              subtitle: isEnglish
                  ? 'Restore profile data to default'
                  : 'Kembalikan data profil ke kondisi awal',
              onTap: () => _confirmResetProfile(context, profile, isEnglish),
            ),

            const SizedBox(height: 24),

            // Informasi aplikasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8D5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.restaurant_menu,
                    size: 34,
                    color: Color(0xFFE8873A),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'RecipeMate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE8873A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isEnglish
                        ? 'Discover recipes, create delicious meals!'
                        : 'Temukan resep, ciptakan hidangan!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versi 1.0.0',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStatistic(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE8873A), size: 25),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
