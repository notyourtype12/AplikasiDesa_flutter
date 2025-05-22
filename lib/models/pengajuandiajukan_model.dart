class StatusDiajukanModel {
  final int idPengajuan;
  final String namaSurat;
  final String tanggalDiajukan;
  final String status;

  StatusDiajukanModel({
    required this.idPengajuan,
    required this.namaSurat,
    required this.tanggalDiajukan,
    required this.status,
  });

  factory StatusDiajukanModel.fromJson(Map<String, dynamic> json) {
    return StatusDiajukanModel(
      idPengajuan: json['id_pengajuan'],
      namaSurat: json['nama_surat'],
      tanggalDiajukan: json['tanggal_diajukan'],
      status: json['status'],
    );
  }
}
