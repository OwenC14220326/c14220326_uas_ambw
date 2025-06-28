## DUMMY
**Dummy 1**
- email: nichocage@gmail.com
- password: 123456

**Dummy 2**
- email: keanowen@gmail.com
- password: 123456

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
![image](https://github.com/user-attachments/assets/3cd1f826-838a-4753-8cb1-7fcd67b0e2ea)
![image](https://github.com/user-attachments/assets/663de39b-88e4-4acd-b954-331494ac2d4b)
![image](https://github.com/user-attachments/assets/6f2639a9-13a3-4c80-800e-52a0c3fd8a97)


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
