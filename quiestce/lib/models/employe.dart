import 'dart:typed_data';

class Employe {
  int? id;
  String nom;
  String prenom;
  int numero;
  String email;
  String adresse;
  String poste;
  String date;
  Uint8List? pdfcv;
  Uint8List? image;
  String? pdfFilePath;

  Employe(
      {required this.id,
      required this.nom,
      required this.adresse,
      required this.date,
      required this.email,
      required this.numero,
      required this.poste,
      required this.prenom,
         required this.pdfcv ,
      required this.image ,
        this.pdfFilePath
      });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'date': date,
      'email': email,
      'numero': numero,
      'poste': poste,
       'pdfcv': pdfcv,
      'prenom': prenom,
      'image': image
    };
  }

  factory Employe.fromMap(Map<String, dynamic> map) {
    return Employe(
        id: map['id'],
        nom: map['nom'],
        adresse: map['adresse'],
        date: map['date'],
        email: map['email'],
        numero: map['numero'],
        poste: map['poste'],
        prenom: map['prenom'],
        pdfcv:map['pdfcv'] ,
        image: map['image']);
  }
}
