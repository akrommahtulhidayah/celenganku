class CelenganModel {
  final int id;
  final String nama;
  final String emoji; // Menyimpan representasi visual/simbol keuangan pelacak celengan
  final double target;
  final double terkumpul;

  CelenganModel({
    required this.id,
    required this.nama,
    required this.emoji,
    required this.target,
    required this.terkumpul,
  });

  // Factory constructor untuk konversi dari format JSON map
  factory CelenganModel.fromJson(Map<String, dynamic> json) {
    return CelenganModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      nama: json['nama'] ?? '',
      // Default emoji/simbol finansial bersih jika data kosong
      emoji: json['emoji'] ?? '💰', 
      target: double.parse((json['target'] ?? 0).toString()),
      terkumpul: double.parse((json['terkumpul'] ?? 0).toString()),
    );
  }

  // Mengubah objek ke Map JSON untuk dikirim ke REST API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'emoji': emoji,
      'target': target,
      'terkumpul': terkumpul,
    };
  }
}