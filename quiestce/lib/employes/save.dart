import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quiestce/models/employe.dart';
import 'package:quiestce/options/couleurs.dart';
import 'package:path/path.dart' as path;
import 'package:quiestce/sqlite_database/sqlite_database.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class Save extends StatefulWidget {
  const Save({super.key});

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> {
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

  Uint8List? cvPdf;

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
      }
    }
  }

  Future<void> exportPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'svg', 'doc', 'txt'],
    );

    if (result != null) {
      Uint8List pdfbites = await File(result.files.first.path!).readAsBytes();

      setState(() {
        cvPdf = pdfbites;
      });
    }
  }

  String pathPDF = "";
  // Future<File> fromAsset(String asset, String filename) async {
  //   // To open from assets, you can copy them to the app storage folder, and the access them "locally"
  //   Completer <File> completer = Completer();

  //   try {
  //     var dir = await getApplicationDocumentsDirectory();
  //     File file = File("${dir.path}/$filename");
  //     var data = await rootBundle.load(asset);
  //     var bytes = data.buffer.asUint8List();
  //     await file.writeAsBytes(bytes, flush: true);
  //     completer.complete(file);
  //   } catch (e) {
  //     throw Exception('Error parsing asset file!');
  //   }

  //   return completer.future;
  // }

  void alertRegisterEmploye() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Employe enregistré avec succès !'),
            content: Container(
              child: Image.asset(
                'assets/alert/true-removebg-preview.png',
                // cacheHeight: 100,
                // cacheWidth: 100,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        });
  }
  // pour camera

  // Future<void> selectImageProfilCamera() async {
  //   final selectImageGallery =
  //       await selectProfilImage.pickImage(source: ImageSource.camera);

  //   if (selectImageGallery != null) {
  //     final File imageFile = File(selectImageGallery.path);
  //     if (await imageFile.exists()) {
  //       final Uint8List imageProfil = await imageFile.readAsBytes();
  //       setState(() {
  //         _imageProfil = imageProfil;
  //       });
  //       extension = path.extension(selectImageGallery.path);
  //     }
  //   }
  // }

  String? pdfName = 'assets/pdf/pdfpardefaut.pdf';
  String? cvPdfFile;
  Uint8List? pdfContenue;
// prendre le pdf par defaut
  Future<void> insertDefaultPdf() async {
    // Charger le fichier PDF par défaut depuis le dossier assets/pdf/
    ByteData data = await rootBundle.load(pdfName!);
    Uint8List defaultPdfContent = data.buffer.asUint8List();

    // Insérer le fichier PDF par défaut dans la base de données

    setState(() {
      pdfContenue = defaultPdfContent;
    });
  }

  Future<void> pickPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String? pickedFileName = result.files.first.name;
        Uint8List pdfbites = await File(result.files.first.path!).readAsBytes();
        setState(() {
          cvPdfFile = pickedFileName;
          pdfContenue = pdfbites;
        });
      }
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }

  Color vertEmeraude = Couleurs.vertEmeraude;
  @override
  void initState() {
    //  fromAsset('assets/pdf/pdfpardefaut.pdf', 'cv.pdf').then((f) {
    //     setState(() {
    //       pathPDF = f.path;
    //     });
    //   });
    // TODO: implement initState;
    insertDefaultPdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Intégrer un nouvel employé',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: vertEmeraude,
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
                                  child: Text('aucun fichier selectionner'),
                                  //                             PDFView(
                                  //   filePath:pathPDF ,
                                  //   autoSpacing: true,
                                  //   pageSnap: true,
                                  //   pageFling: true,
                                  // ),
                                ),
                          OutlinedButton.icon(
                            onPressed: () {
                              pickPdf();
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('Exporter le fichier pdf'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 70,
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(5),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      onPressed: () async {
                        // enregistre un  employe avec image

                        try {
                          // on peut pas mettre au meme nom avec le controller
                          String nomEmploye = nom.text;
                          String prenomEmploye = prenom.text;
                          String numeroEmploye = numeroTelephone.text;
                          int convertNumero = numeroEmploye != ''
                              ? int.parse(numeroEmploye)
                              : 0;
                          String emailEmploye = email.text;
                          String adresseEmploye = adresse.text;
                          String posteEmploye = poste.text;
                          String date = dateDembauche.text;

                          if (_imageProfil == null ||
                              nomEmploye.isEmpty ||
                              posteEmploye.isEmpty ||
                              prenomEmploye.isEmpty ||
                              numeroEmploye.isEmpty ||
                              emailEmploye.isEmpty ||
                              adresseEmploye.isEmpty ||
                              date.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Veuillez remplir tous les champs.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            print('object');
                          } else {
                            Employe employe = Employe(
                                id: null,
                                nom: nomEmploye,
                                adresse: adresseEmploye,
                                date: date,
                                email: emailEmploye,
                                numero: convertNumero,
                                poste: posteEmploye,
                                prenom: prenomEmploye,
                                image: _imageProfil);

                            int employeId =
                                await sqliteDatabase.createEmploye(employe);

                            if (employeId != null && employeId != -1) {
                              alertRegisterEmploye();
                              nom.clear();
                              prenom.clear();
                              numeroTelephone.clear();
                              email.clear();
                              adresse.clear();
                              poste.clear();
                              dateDembauche.clear();

                              setState(() {
                                _imageProfil = null;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Erreur lors de l\'enregistrement de cette employe'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('error'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          print(e);
                        }
                      },
                      child: const Text(
                        'Enregistrez',
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
      // backgroundColor: const Color.fromARGB(255, 225, 225, 225),
      backgroundColor: Colors.white,
    );
  }
}
