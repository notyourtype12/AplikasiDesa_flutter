part of 'auth.dart'; 


class Loginregis extends StatelessWidget {
  const Loginregis({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 115, 164),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          children: [
            Image.asset(
              'assets/images/logosplash.png',
              height: 333,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 15),
            Text(
              "Selamat Datang",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Kami Siap Mempermudah Anda",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 2 * defaultMargin,
              child: ElevatedButton(
                onPressed: () {
                  // Menampilkan modal register
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent, // untuk meghilngkn bg white
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          // Variabel untuk menyimpan data
                          String selectedGender = 'Laki-laki'; 
                          bool isPasswordVisible = false;
                          TextEditingController dateController = TextEditingController();

                          return Wrap(
                            children: [
                              // MODAL REGIS
                              Container(
                                color: Colors.transparent, // agar Latar belakang transparan
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 159, 155, 117), // mengatur modal 
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40),
                                    ),
                                  ),
                                  // container untuk text
                                  child: Container( 
                                    margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // Untuk rata kiri
                                      children: [
                                        SizedBox(height: 25), // Jarak
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start, // Untuk rata kiri
                                              children: [
                                                Text(
                                                  "Hello World",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  "Registrasi",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            // Jika ingin menambahkan tombol close
                                            // Image.asset(
                                            //   'assets/images/closex.png',
                                            //   height: 30,
                                            //   width: 30,
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: 25), // Jarak

                                        // Text fields
                                        TextField(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.person),
                                            labelText: 'Nama Panjang',
                                            hintText: 'Masukkan nama panjang anda',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        TextField(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.person),
                                            labelText: 'Username',
                                            hintText: 'Masukkan username anda',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        TextField(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.email),
                                            labelText: 'Email',
                                            hintText: 'Masukkan email anda',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        // Password  visibility
                                        TextField(
                                          obscureText: !isPasswordVisible, // hide password
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.lock),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPasswordVisible = !isPasswordVisible; // Toggle visibility
                                                });
                                              },
                                              icon: Icon(
                                                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                              ),
                                            ),
                                            labelText: 'Password',
                                            hintText: 'Masukkan Password Anda',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        // Date picker
                                        TextField(
                                          controller: dateController,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.calendar_month),
                                            labelText: 'Tanggal Lahir',
                                            hintText: 'Pilih Tanggal Lahir',
                                            border: OutlineInputBorder(),
                                          ),
                                          readOnly: true, // buat enabled biar ga bida edit
                                          onTap: () async {
                                            // Menampilkan date picker
                                            DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                            );

                                            if (pickedDate != null) {
                                              // Format tanggal dan set ke controller
                                              String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                              dateController.text = formattedDate;
                                            }
                                          },
                                        ),
                                        SizedBox(height: 20),

                                        // Dropdown untuk jenis kelamin
                                        DropdownButtonFormField<String>(
                                          value: selectedGender,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.woman),
                                            labelText: 'Jenis Kelamin',
                                            border: OutlineInputBorder(),
                                          ),
                                          items: ['Laki-laki', 'Perempuan'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedGender = newValue!;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 20),

                                        TextField(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.phone),
                                            labelText: 'No HP',
                                            hintText: 'Masukkan Nomor Handphone Anda',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        TextField(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.home),
                                            labelText: 'Alamat',
                                            hintText: 'cth: Jl Tidar',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                    Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Aksi ketika tombol ditekan
                                    },
                                    child: Text('Buat Akun Baru'),
                                  ),
                                )
                
                 
                 
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Text(
                  'Registrasi',
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 182, 176, 125),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 2 * defaultMargin,
              child: ElevatedButton(
                onPressed: () {
                  // Menampilkan modal login
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent, // Menghilangkan latar belakang putih
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          bool isPasswordVisible = false;

                          return Wrap(
                            children: [
                              // Bagian modal
                              Container(
                                color: Colors.transparent, // Latar belakang transparan
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 182, 176, 125), // Warna latar belakang konten modal
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40),
                                    ),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // Untuk rata kiri
                                      children: [
                                        SizedBox(height: 25), // Jarak
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start, // Untuk rata kiri
                                              children: [
                                                Text(
                                                  "Hello World",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  "Login",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            // Jika ingin menambahkan tombol close
                                            // Image.asset(
                                            //   'assets/images/closex.png',
                                            //   height: 30,
                                            //   width: 30,
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: 25), // Jarak

                                         TextField(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.person),
                                            labelText: 'Username',
                                            hintText: 'Masukkan username anda',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        // Password field dengan toggle visibility
                                        TextField(
                                          obscureText: !isPasswordVisible, // Menyembunyikan/menampilkan password
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.lock),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPasswordVisible = !isPasswordVisible; // Toggle visibility
                                                });
                                              },
                                              icon: Icon(
                                                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                              ),
                                            ),
                                            labelText: 'Password',
                                            hintText: 'Masukkan Password Anda',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                         Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Aksi ketika tombol ditekan
                                          },
                                          child: Text('Masuk'),
                                        ),
                                      )

                                       
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Text(
                  'Login',
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 55, 115, 164),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: const Color.fromARGB(255, 182, 176, 125), width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}