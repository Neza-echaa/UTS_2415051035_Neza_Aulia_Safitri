import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  static const String _nameKey = 'profile_name';
  static const String _emailKey = 'profile_email';
  static const String _bioKey = 'profile_bio';
  static const String _photoKey = 'profile_photo';

  String name = 'Pengguna RecipeMate';
  String email = '';
  String bio = 'Pecinta kuliner';
  String? photoBase64;

  bool isLoading = true;

  // READ: Mengambil data profil dari penyimpanan lokal.
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    name = prefs.getString(_nameKey) ?? 'Pengguna RecipeMate';
    email = prefs.getString(_emailKey) ?? '';
    bio = prefs.getString(_bioKey) ?? 'Pecinta kuliner';
    photoBase64 = prefs.getString(_photoKey);

    isLoading = false;
    notifyListeners();
  }

  // CREATE dan UPDATE: Menyimpan informasi profil.
  Future<void> updateProfile({
    required String name,
    required String email,
    required String bio,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    this.name = name;
    this.email = email;
    this.bio = bio;

    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_bioKey, bio);

    notifyListeners();
  }

  // UPDATE: Mengganti foto profil dari galeri.
  Future<bool> pickProfilePhoto() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 700,
    );

    if (image == null) return false;

    final bytes = await image.readAsBytes();
    final encodedImage = base64Encode(bytes);

    final prefs = await SharedPreferences.getInstance();

    photoBase64 = encodedImage;
    await prefs.setString(_photoKey, encodedImage);

    notifyListeners();
    return true;
  }

  // DELETE: Menghapus foto profil.
  Future<void> removeProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();

    photoBase64 = null;
    await prefs.remove(_photoKey);

    notifyListeners();
  }

  // DELETE: Mengembalikan seluruh data profil ke kondisi awal.
  Future<void> resetProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_bioKey);
    await prefs.remove(_photoKey);

    name = 'Pengguna RecipeMate';
    email = '';
    bio = 'Pecinta kuliner';
    photoBase64 = null;

    notifyListeners();
  }
}
