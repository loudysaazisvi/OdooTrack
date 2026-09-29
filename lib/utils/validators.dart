// lib/utils/validators.dart
// Langkah C: Fungsi validasi form yang bisa dipakai ulang di seluruh screen.
// Validator dipisahkan dari screen agar kode lebih bersih (sesuai instruksi).

class Validators {
  // Validasi field wajib (tidak boleh kosong)
  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null; // null = valid
  }

  // Validasi format email
  static String? email(String? value) {
    final requiredCheck = required(value, 'Email');
    if (requiredCheck != null) return requiredCheck;

    // Regex sederhana untuk cek format email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi password (minimal 6 karakter)
  static String? password(String? value) {
    final requiredCheck = required(value, 'Password');
    if (requiredCheck != null) return requiredCheck;

    if (value!.trim().length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }
}
