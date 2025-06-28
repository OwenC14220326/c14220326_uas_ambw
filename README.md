Simple Recipe Keeper

Aplikasi Flutter untuk menyimpan dan mengelola resep pribadi, menggunakan Firebase Authentication, Firestore Database, dan Hive untuk session persistence.

---

## ✨ Fitur Utama

### ✅ Authentication (20 poin)

- Menggunakan **Firebase Authentication**.
- Fitur:
  - **Sign Up** (pendaftaran pengguna baru).
  - **Sign In** (login pengguna).
  - **Sign Out** (logout).
- Validasi input:
  - Email wajib format valid.
  - Password minimal 6 karakter.
  - Pesan kesalahan tampil jika login/signup gagal.

📂 **Letak Implementasi:**
- `signin_page.dart` dan `signup_page.dart`: Form validasi & autentikasi.
- `homepage.dart`: Logout.
- Semua validasi error via `_errorMessage`.

---

### ✅ Cloud Database (20 poin)

- Menggunakan **Firestore**.
- Data resep tersimpan berdasarkan **UID pengguna**.
- Fitur CRUD Resep:
  - Tambah resep.
  - Edit resep.
  - (Opsional) Hapus resep.
- Filtering resep sesuai UID login.

📂 **Letak Implementasi:**
- `add_recipe_page.dart`:
  ```dart
  'uid_pembuat': FirebaseAuth.instance.currentUser?.uid,
homepage.dart:

dart
Copy
Edit
.where('uid_pembuat', isEqualTo: uid)
✅ Session Persistence (20 poin)
Menggunakan Hive.

Menyimpan informasi login agar pengguna tetap login setelah menutup aplikasi.

Mengecek session saat startup.

📂 Letak Implementasi:

signin_page.dart:

dart
Copy
Edit
final sessionBox = Hive.box('sessionBox');
await sessionBox.put('uid', userCredential.user?.uid);
main.dart:

dart
Copy
Edit
final uid = sessionBox.get('uid');
if (uid != null) {
  // Langsung ke halaman Home
}
✅ Get Started Screen (20 poin)
Halaman Get Started hanya tampil saat pertama kali aplikasi dibuka.

Jika sudah pernah dibuka, langsung ke login/home.

📂 Letak Implementasi:

get_started_page.dart: Tampilan Get Started.

main.dart:

dart
Copy
Edit
final onboardingBox = Hive.box('onboardingBox');
final isFirstTime = onboardingBox.get('isFirstTime', defaultValue: true);
if (isFirstTime) {
  // Tampilkan GetStarted
} else {
  // Langsung ke SignIn atau Home
}
Setelah Get Started:

dart
Copy
Edit
onboardingBox.put('isFirstTime', false);
✅ Desain Navigasi & UI (10 poin)
Navigasi menggunakan Navigator.pushNamed().

Routing konsisten dan rapi.

UI sederhana dan fungsional:

AppBar.

ListTile untuk daftar resep.

TextField untuk input data.

ElevatedButton untuk aksi.

Validasi form input.

📂 Letak Implementasi:

main.dart:

dart
Copy
Edit
routes: {
  '/get-started': (_) => const GetStartedPage(),
  '/signin': (_) => const SignInPage(),
  '/signup': (_) => const SignUpPage(),
  '/home': (_) => const HomePage(),
  '/add-recipe': (_) => const AddRecipePage(),
  '/edit-recipe': (_) => const EditRecipePage(),
  '/detail-recipe': (_) => const DetailRecipePage(),
}
Navigasi antar halaman:

dart
Copy
Edit
Navigator.pushNamed(context, '/edit-recipe', arguments: doc);
📂 Struktur Folder
css
Copy
Edit
lib/
  main.dart
  get_started_page.dart
  signin_page.dart
  signup_page.dart
  home_page.dart
  add_recipe_page.dart
  edit_recipe_page.dart
  detail_recipe_page.dart
🚀 Cara Menjalankan
Clone Repository

bash
Copy
Edit
git clone <repository-url>
cd <repository-folder>
Install Dependencies

bash
Copy
Edit
flutter pub get
Jalankan

bash
Copy
Edit
flutter run
Pastikan sudah menambahkan file google-services.json di folder android/app.