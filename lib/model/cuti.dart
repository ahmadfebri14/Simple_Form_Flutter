class Cuti {
  final int? id;
  final String nomorInduk;
  final String tanggalCuti;
  final String lamaCuti;
  final String keterangan;


  Cuti({
    this.id, required this.nomorInduk, required this.tanggalCuti, required this.lamaCuti,
    required this.keterangan
  });

  Cuti.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        nomorInduk = res["nomorInduk"],
        tanggalCuti = res["tanggalCuti"],
        lamaCuti = res["lamaCuti"],
        keterangan = res["keterangan"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nomorInduk': nomorInduk,
      'tanggalCuti': tanggalCuti,
      'lamaCuti': lamaCuti,
      'keterangan': keterangan
    };
  }
}
