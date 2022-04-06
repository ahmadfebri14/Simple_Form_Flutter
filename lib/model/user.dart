class User {
  final int? id;
  final String nomorInduk;
  final String nama;
  final String alamat;
  final String tanggalLahir;
  final String tanggalBergabung;

  User(
      { this.id,
        required this.nomorInduk,
        required this.nama,
        required this.alamat,
        required this.tanggalLahir,
        required this.tanggalBergabung
      });

  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        nomorInduk = res["nomorInduk"],
        nama = res["nama"],
        alamat = res["alamat"],
        tanggalLahir = res["tanggalLahir"],
        tanggalBergabung = res["tanggalBergabung"];

  Map<String, Object?> toMap() {
    return {'id':id,'nomorInduk': nomorInduk, 'nama': nama, 'alamat': alamat, 'tanggalLahir': tanggalLahir, 'tanggalBergabung': tanggalBergabung};
  }
}
