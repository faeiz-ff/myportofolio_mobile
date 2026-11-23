# Tugas 8

## Pertanyaan Refleksi

> 1. Jelaskan perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama. 

.push(...) akan mengganti halaman terkini menjadi apapun yang menjadi argumen dari pemanggilan fungsi .push(...), dan argumen tersebut menambah tumpukan "sejarah" halaman yang telah dikunjungi. Lalu pemanggilan .pop() akan mengganti halaman terkini menjadi halaman sebelumnya pada tumpukan "sejarah" halaman. Fungsi .pushReplacement(...) berperilaku sama seperti .push(...), tetapi halaman terbaru akan menggantikan tumpukan teratas "sejarah" halaman, bukan ditambahkan.

Metode .pushReplacement(...) digunakan untuk membuka formulir dari kartu aksi. Opsi home di drawer memanggil fungsi .pushReplacement() juga dengan mengganti halaman terkini dengan MyHomePage().

> 2. Bagaimana susunan Scaffold, AppBar, dan Drawer membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman. 

Scaffold memberi struktur Bar atas dan integrasi Drawer, jadi cukup pakai Widget Scaffold dengan parameter yang sama pada tiam halaman, dan halaman akan konsisten. 

Warna tema dikirim melalui main.dart dari Widget atau _provider_ theme yaitu ThemeData. ThemeData ini dikirim melalui context dari seluruh "anak" yang dibangun dengan fungsi build. Contoh penggunaannya ada pada background color dari AppBar menu.dart.

> 3. Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas. 

Collumn akan "overflow", yaitu keluar batas layar, apabila _children_nya menempati ruang layar diluar dari ukuran layar saat ini. SingleChildScrollView mengatasi ini dengan otomatis menggulir layar. 

> 4. Apa peran GlobalKey<FormState>, validator, dan validate() saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup. 

GlobalKey untuk FormState akan membuat suatu instansi global terhadap _state_ atau keadaan dari formulir terkini, yang dapat diakses dimanapun dari hirarki struktur widget. Disini widget Form() dalam experience_form atau project_form diberi key GlobalKey agar dapat direferensi oleh anak-anaknya.

Validator dalam field mengecek validitas sebuah field dengan logika tersendiri, menghasilkan null jika tidak ada error. validate() saat tombol Simpan ditekan sebenarnya di-invoke terhadap _formKey yaitu sebuah referensi terhadap form saat ini, yang selanjutnya akan meng-invoke semua validator untuk semua input yang ada pada setiap field.

Contoh nilai yang ditolak adalah string kosong atau string yang berisikan _whitespace_ saja. Memilih jenis input belumlah cukup karena mungkin ada beberapa hal yang kita ingin validasikan sebelum data diproses, misalnya menetapkan ketepatan sebuah format input, atau menolak data yang tidak masuk akal seperti string kosong pada sebuah nama proyek.

## AI Disclosure

Semua kode dan teks dalam tugas 8 ini 100% diketik tanpa menggunakan AI. Saya juga tidak memakai AI untuk mendesain, memberi ide, ataupun mengedit hal-hal tekstual dalam tugas ini.

## Referensi
- https://docs.flutter.dev/cookbook/navigation/navigation-basics
- https://api.flutter.dev/flutter/material/Scaffold-class.html
- https://medium.com/@basriumar/scaffold-dan-appbar-membuat-struktur-aplikasi-flutter-part-10-43cb93d145a2 
- https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html 
- https://mailharshkhatri.medium.com/understanding-keys-in-flutter-valuekey-uniquekey-and-globalkey-faf9216e1af8

