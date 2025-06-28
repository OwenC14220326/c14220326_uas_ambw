## SIMPLE RECIPE KEEPER

---

## Keterangan Aplikasi Simple Recipe Keeper

### Authentication

Menggunakan **Firebase Auth**.

**Fitur:**

* Sign Up, Sign In, Sign Out
* Validasi input & pesan error

**Letak Implementasi:**

* `signin_page.dart`

  * Form login dengan validasi email & password
  * Error handling (`_errorMessage`)
* `signup_page.dart`

  * Form pendaftaran dengan validasi
* `home_page.dart`

  * Tombol logout:

    ```dart
    FirebaseAuth.instance.signOut()
    ```

---

### Cloud Database

Menggunakan **Firestore**.

**Fitur:**

* Menyimpan resep berdasarkan UID pengguna yang login
* Hanya menampilkan resep pribadi user tersebut

**Letak Implementasi:**

* `add_recipe_page.dart`:

  ```dart
  'uid_pembuat': FirebaseAuth.instance.currentUser?.uid
  ```
* `home_page.dart`:

  ```dart
  .where('uid_pembuat', isEqualTo: uid)
  ```

**Firestore Collections:**

* `users` (untuk autentikasi)
* `recipes` (untuk data resep)

**Screenshot contoh data:**
![image](https://github.com/user-attachments/assets/8623afc5-31d1-46fe-9db8-373b8e643f9f)
![image](https://github.com/user-attachments/assets/a99bcc35-2f65-4449-a68e-d98f155fa456)
![image](https://github.com/user-attachments/assets/d1667209-6886-4ddf-b44e-64f954342cd1)

---

### Session Persistence

Menggunakan **Hive** untuk menyimpan sesi login.
Simpan informasi login agar user tidak perlu login ulang.

**Letak Implementasi:**

* `signin_page.dart`:

  ```dart
  final box = Hive.box('sessionBox');
  await box.put('uid', userCredential.user?.uid);
  ```
* `main.dart`:

  ```dart
  Hive.box('sessionBox').get('uid')
  ```

  * Jika ada UID: langsung ke HomePage
  * Jika tidak: ke SignIn

---

### Get Started Screen

Tampil hanya saat pertama kali aplikasi dibuka.
Jika sudah pernah dibuka, langsung ke login/home.

**Letak Implementasi:**

* `get_started_page.dart`
* `main.dart`:

  ```dart
  final onboardingBox = Hive.box('onboardingBox');
  final isFirstTime = onboardingBox.get('isFirstTime', defaultValue: true);
  ```

  * Jika `isFirstTime == true`, tampilkan Get Started
  * Setelah selesai:

    ```dart
    onboardingBox.put('isFirstTime', false);
    ```
  * Tidak muncul lagi

---

### Desain Navigasi & UI

Navigasi antar halaman rapi dan intuitif menggunakan **Navigator**.
UI sederhana namun fungsional.

**Letak Implementasi:**

* `main.dart`:

  ```dart
  MaterialApp(
    routes: {
      '/signin': (_) => const SignInPage(),
      '/signup': (_) => const SignUpPage(),
      '/home': (_) => const HomePage(),
      '/add-recipe': (_) => const AddRecipePage(),
      '/edit-recipe': (_) => const EditRecipePage(),
      '/detail-recipe': (_) => const DetailRecipePage(),
    },
  )
  ```
* Navigasi konsisten:

  ```dart
  Navigator.pushNamed(context, '/edit-recipe', arguments: doc);
  ```
* UI komponen:

  * `TextField`
  * `ListTile`
  * `ElevatedButton`

---

### Fitur Tambahan
* edit_recipe.dart: Edit resep agar pengguna bisa mengubah resep yang sudah ditambahkan.
* detail_recipe.dart: Detail resep agar pengguna bisa membaca resep di home page dengan mudah dan bisa melihat detail resepnya ketika resep dipencet.
* dalam detail_recipe.dart: Delete resep agar pengguna bisa menghapus resep yang sudah ditambahkan.
* Atribut tambahan seperti foto_url dan nama_pembuat pada collection recipes.
* Atribut tambahan nama_lengkap pada collection users.

---

## Struktur Folder

```
lib/
  main.dart
  firebase_options.dart
  pages/
    get_started.dart
    signin_page.dart
    signup_page.dart
    home_page.dart
    add_recipe.dart
    edit_recipe.dart
    detail_recipe.dart
```

---

## Petunjuk Build & Jalankan

1. **Clone repository**

   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Tambahkan kredensial Firebase**

   * Unduh file `google-services.json` dari Firebase Console.
   * Letakkan di:

     ```text
     android/app/google-services.json
     ```

4. **Pastikan konfigurasi `build.gradle.kts`**

   ```kotlin
   ndkVersion = "27.0.12077973" // tergantung versi Android
   defaultConfig {
       minSdkVersion(23)
       targetSdkVersion(34)
   }
   ```

5. **Jalankan aplikasi**

   ```bash
   flutter run
   ```

---
## Teknologi yang Digunakan

### **Firebase**

* **Authentication**: Sign Up, Sign In, Sign Out dengan validasi email/password.
* **Firestore**: Simpan data resep real-time berdasarkan UID pengguna.

---

### **Hive**

* **Session Persistence**: Simpan UID login agar tidak perlu login ulang.
* **Onboarding Tracking**: Cek apakah pengguna sudah lewat halaman Get Started.

---

### **Flutter**

* **UI & Navigasi**: MaterialApp, Navigator, widget standar (TextField, ElevatedButton).
* **State Management**: `StatefulWidget` + `setState`.

---

### **Dependencies utama**

* `firebase_core`, `firebase_auth`, `cloud_firestore`
* `hive_flutter`, `path_provider`

---

## DUMMY
**Dummy 1**
- email: nichocage@gmail.com
- password: 123456

**Dummy 2**
- email: keanowen@gmail.com
- password: 123456

---
