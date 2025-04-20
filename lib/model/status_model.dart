class PengajuanModel {
  final String nama_surat;
  final String tanggal_diajukan;
  final String status;

  PengajuanModel({
    required this.nama_surat,
    required this.tanggal_diajukan,
    required this.status,
  });

  factory PengajuanModel.fromJson(Map<String, dynamic> json) {
    return PengajuanModel(
      nama_surat: json['nama_surat'] as String,
      tanggal_diajukan: json['tanggal_diajukan'] as String,
      status: json['status'] as String,
    );
  }
}
