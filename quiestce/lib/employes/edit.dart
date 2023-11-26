import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quiestce/models/employe.dart';
import 'package:quiestce/sqlite_database/sqlite_database.dart';
import 'package:path/path.dart' as path;

class Edit extends StatefulWidget {
  final Employe employe;
  final Function afficheEmploye;

  const Edit({super.key, required this.employe, required this.afficheEmploye});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final sqliteDatabase = SqliteDatabase();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController numeroTelephone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController poste = TextEditingController();
  TextEditingController dateDembauche = TextEditingController();
  final selectProfilImage = ImagePicker();
  Uint8List? _imageProfil;
  Uint8List? imageEdit;
  late String extension;
//on va encore recuperer l'image dans le future

// pour gallery
  Future<void> selectImageProfilGallery() async {
    final selectImageGallery =
        await selectProfilImage.pickImage(source: ImageSource.gallery);

    if (selectImageGallery != null) {
      final File imageFile = File(selectImageGallery.path);
      if (await imageFile.exists()) {
        final Uint8List imageProfil = await imageFile.readAsBytes();
        setState(() {
          _imageProfil = imageProfil;
        });
        extension = path.extension(selectImageGallery.path);
        // Mettez à jour l'image de l'employé dans l'objet widget.employe
        widget.employe.image = _imageProfil;
      }
    }
  }

  void afficherAlertUpdateReussi() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mise à jour réussi'),
          content: const Text('modification avec succès'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                  Navigator.of(context).pop();
                // Fermer l'alerte
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    nom.text = widget.employe.nom;
    prenom.text = widget.employe.prenom;
    numeroTelephone.text = widget.employe.numero.toString();
    email.text = widget.employe.email;
    adresse.text = widget.employe.adresse;
    poste.text = widget.employe.poste;
    dateDembauche.text = widget.employe.date;
    widget.employe;
    // imageEdit = widget.employe.image;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Modification',
          style: TextStyle(
              fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // color: Colors.white,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextField(
                      controller: nom,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: 'Nom',
                        labelText: 'Nom',
                        // icon: Icon(icon)
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(50),
                        //   borderSide: const BorderSide(
                        //     width: 5,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextField(
                      controller: prenom,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: 'Prenom',
                        labelText: 'Prenom',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(50),
                        //   borderSide: const BorderSide(
                        //     width: 5,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextField(
                      controller: numeroTelephone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Numero Telephone',
                        labelText: 'Numero Telephone',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(50),
                        //   borderSide: const BorderSide(
                        //     width: 5,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(50),
                        //   borderSide: const BorderSide(
                        //     width: 5,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextField(
                      controller: adresse,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                        hintText: 'Adresse',
                        labelText: 'Adresse',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(50),
                        //   borderSide: const BorderSide(
                        //     width: 5,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextField(
                      controller: poste,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: 'Poste',
                        labelText: 'Poste',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(50),
                        //   borderSide: const BorderSide(
                        //     width: 5,
                        //   ),
                        // ),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    // padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.width / 3,
                    child: Center(
                      child: TextField(
                        //editing controller of this TextField
                        controller: dateDembauche,
                        decoration: const InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Date d'embauche" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100));
                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              dateDembauche.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),
                    ),
                  ),

                  Container(
                    // pour se scroller en horizontal
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _imageProfil != null
                              ? Padding(
                                  padding: EdgeInsets.all(8),
                                  child: ClipOval(
                                    child: Image.memory(
                                      _imageProfil!,
                                      cacheHeight: 100,
                                      cacheWidth: 100,
                                    ),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Aucune image selectionné')),
                          OutlinedButton.icon(
                            onPressed: () {
                              selectImageProfilGallery();
                            },
                            icon: const Icon(Icons.image),
                            label: const Text('image'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 70,
                    margin: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(5),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue[600])),
                      onPressed: () async {
                        try {
                          widget.employe.nom = nom.text;
                          widget.employe.prenom = prenom.text;
                          widget.employe.numero =
                              int.parse(numeroTelephone.text);
                          widget.employe.email = email.text;
                          widget.employe.adresse = adresse.text;
                          widget.employe.poste = poste.text;
                          widget.employe.date = dateDembauche.text;

                          // _image == null ||
                          if (
                              nom.text.isEmpty ||
                              prenom.text.isEmpty ||
                              numeroTelephone.text.isEmpty ||
                              email.text.isEmpty ||
                              adresse.text.isEmpty ||
                              poste.text.isEmpty ||
                              dateDembauche.text.isEmpty) {
                            // Affichez un message d'erreur si un champ est vide
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Veuillez remplir tous les champs.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            // on cree un repertoire pour stocker l'image s'il n'existe pas encore
                            Employe employe = Employe(
                                id: widget.employe.id,
                                nom: widget.employe.nom,
                                adresse: widget.employe.adresse,
                                date: widget.employe.date,
                                email: widget.employe.email,
                                numero: widget.employe.numero,
                                poste: widget.employe.poste,
                                prenom: widget.employe.prenom,
                                pdfcv: widget.employe.pdfcv,
                                image: _imageProfil!=null ? widget.employe.image:widget.employe.image);

                            int employeUpdateId =
                                await sqliteDatabase.updateEmploye(employe);
                            setState(() {
                              widget.afficheEmploye();
                              widget.employe;
                            });
//
                            // ignore: unnecessary_null_comparison
                            if (employeUpdateId != -1) {
                              afficherAlertUpdateReussi();
                            } else {
                              // L'enregistrement a échoué
                              // Affichez un message d'erreur
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Erreur lors de la mise à jour de la voiture.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          // En cas d'erreur, affichez un message d'erreur
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Erreur lors de la mise à jour de la voiture'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          print(
                              'Erreur lors de l\'enregistrement de la voiture : $e');
                        }
                      },
                      child: const Text(
                        'Modifiez',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )

                  // Container(
                  //   child: TextField(
                  //     decoration:
                  //    InputDecoration(
                  //      hintText: 'Date d\'embauche'  ,
                  //      labelText:  'Date d\'embauche'
                  //    ) ,
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
