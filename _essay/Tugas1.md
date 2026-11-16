# Tugas 7 

## Pertanyaan Refleksi

> 1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!

Widget adalah bagian terkecil dari elemen UI yang dapat digabungkan dengan berbagai Widget lainnya, seperti halnya Lego _piece_ nya User Interface. Hierarkinya mirip seperti bagaimana HTML menstrukturkan elemen visual (maupun nonvisual) nya yaitu sebagai tree. Jadi, suatu "Parent" node dapat mempunyai dan mengatur "Child" nodenya. 

> 2.Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing! 

- MyApp: Mengatur 'root' dari aplikasi
- MyHomePage: Mengatur halaman (satu satunya) di awal
- InfoCard: Menampilkan data personal saya
- ItemCard: Menampilkan tombol dan logika penekanan tombolnya

> 3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter! 
Material Design adalah sebuah _guideline_ desain dari google untuk mengembangkan aplikasi yang selaras dengan tema aplikasi android (yang terlalu generik menurut saya pribadi). Jadi umumnya, semua aplikasi (android) ingin mengikuti desain ini agar terlihat ""profesional"". MaterialApp dalam flutter menyediakan implementasi widget siap pakai yang sesuai dengan Material Design tersebut.

> 4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget? 

StatelessWidget tidak mempunyai State, dalam arti mereka dapat dibuat dengan 'fungsi' model matematika murni: Input yang sama akan mengeluarkan Output yang sama. Sebelum instansiasi Widget, Parent dari sebuah StatelessWidget akan mengisi dulu apa yang akan ditampilkan pada sebuah StatelessWidget. Saat sudah ter-instansiasi, semua state dari StatelessWidget tidak dapat diubah setelah di-_build_.

StatefulWidget mempunyai State, dalam arti mereka bukanlah sebuah fungsi murni, konfigurasi awal saat instansiasi tidak mengacu pada tampilan akhirnya pada layar, melainkan bergantung pada sebuah State class eksternal. State eksternal ini, ya, mempunyai state yang dapat berubah, juga mempunyai fungsi build yang akan terpanggil setiap kali ada perubahan dalam state class tersebut.

StatelessWidget digunakan apabila kita ingin menetapkan suatu konfigurasi awal yang tidak akan berubah, dan StatefulWidget digunakan apabila kita ingin mengubah tampilan secara dinamis.

> 5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build? 

BuildContext mengirim informasi kepada Child nodes tentang suatu konfigurasi/informasi yang ada pada Parent nodenya. Dalam pengerjaan tugas saya, dalam fungsi build MyApp, terdapat ThemeData yang dimasukkan ke dalam konteks MaterialApp. Theme ini lalu dipakai dalam BackgroundColor dari MyHomePage (yang meng-query themenya dengan Theme.of(context)).

> 6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart? 

Hot reload menampilkan ulang halaman dengan perubahan terkini yang telah dibuat, cepat untuk dilakukan, tetapi State yang sudah diubah tidak di-reset. Sementara Hot Restart me-reset ulang semua State. 

Kita harus melakukan hot restart saat kita ingin mengembalikan ulang ke State awal aplikasi, misalnya "belum pernah login sama sekali", atau "barang belum terbeli". Hot Reload tidak akan mengembalikan ulang state.

## AI Disclosure

Semua kode dan teks dalam tugas 7 ini 100% diketik tanpa menggunakan AI. Saya juga tidak memakai AI untuk mendesain, memberi ide, ataupun mengedit hal-hal tekstual dalam tugas ini.

## Referensi 
- https://medium.com/@ramantank04/understanding-the-widget-tree-in-flutter-19b1c91be989
- https://www.geeksforgeeks.org/flutter/materialapp-class-in-flutter/ 
- https://www.geeksforgeeks.org/flutter/flutter-stateful-vs-stateless-widgets/ 
- https://medium.com/@dihsar/understanding-flutter-buildcontext-a-guide-for-developers-367579309f3a 
- https://www.geeksforgeeks.org/flutter/difference-between-hot-reload-and-hot-restart-in-flutter/  
