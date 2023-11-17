import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiestce/employes/affiche_specifique.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:quiestce/models/employe.dart';
import 'package:quiestce/options/couleurs.dart';
import 'package:image/image.dart' as img;
import 'package:quiestce/sqlite_database/sqlite_database.dart';

class ReconnaissanceFacialeEmploye extends StatefulWidget {
  const ReconnaissanceFacialeEmploye({super.key});

  @override
  State<ReconnaissanceFacialeEmploye> createState() =>
      _ReconnaissanceFacialeEmployeState();
}

class _ReconnaissanceFacialeEmployeState
    extends State<ReconnaissanceFacialeEmploye> {
  final sqliteDatabase = SqliteDatabase();
  final selectionnerImageProfilGallery = ImagePicker();
  Uint8List? imageProfil;
  Uint8List? imageProfil1;
  bool progressBar = false;
  late String extension;

  bool cherche = false;

  bool nonTrouveImage = true;

  bool afficheFirst = true;

  Uint8List? imageFirst;

  Color vertEmeraude = Couleurs.vertEmeraude;
// depuis gallery
  Future<void> selectImageGallery() async {
    final selectImageGallery = await selectionnerImageProfilGallery.pickImage(
        source: ImageSource.gallery);

    // on teste si on a cliquer sur un boutton qui va nous rediriger vers la gallery

    if (selectImageGallery != null) {
      final File imageFile = File(selectImageGallery.path);
      if (await imageFile.exists()) {
        final Uint8List image = await imageFile.readAsBytes();
        setState(() {
          imageProfil = image;
          cherche = true;
        });

        extension = path.extension(selectImageGallery.path);
      }
    }
  }
// depuis camera

  Future<void> selectImageCamera() async {
    final selectImageGallery = await selectionnerImageProfilGallery.pickImage(
        source: ImageSource.camera);

    // on teste si on a cliquer sur un boutton qui va nous rediriger vers la gallery

    if (selectImageGallery != null) {
      final File imageFile = File(selectImageGallery.path);
      if (await imageFile.exists()) {
        final Uint8List image = await imageFile.readAsBytes();
        setState(() {
          imageProfil1 = image;
          cherche = true;
        });

        extension = path.extension(selectImageGallery.path);
      }
    }
  }

  double calculateImageDifference(img.Image image1, img.Image image2) {
    // Assurez-vous que les deux images ont la même taille
    if (image1.width != image2.width || image1.height != image2.height) {
      throw ArgumentError('Les dimensions des images ne correspondent pas.');
    }

    double totalDifference = 0.0;

    // Parcourez chaque pixel et comparez-les
    for (int y = 0; y < image1.height; y++) {
      for (int x = 0; x < image1.width; x++) {
        int pixel1 = image1.getPixel(x, y);
        int pixel2 = image2.getPixel(x, y);
// Comparez les composants de couleur (R, G, B)
        int diffR = img.getRed(pixel1) - img.getRed(pixel2);
        int diffG = img.getGreen(pixel1) - img.getGreen(pixel2);
        int diffB = img.getBlue(pixel1) - img.getBlue(pixel2);

        // Calculez la distance euclidienne entre les couleurs
        double pixelDifference =
            (diffR * diffR + diffG * diffG + diffB * diffB).toDouble();

        // Ajoutez la différence à la somme totale
        totalDifference += pixelDifference;
      }
    }
    // Calculez la différence moyenne
    double averageDifference = totalDifference / (image1.width * image1.height);

    return averageDifference;
  }

  // pour redimensionner les images
  img.Image resizeImage(img.Image image, int targetWidth, int targetHeight) {
    return img.copyResize(image, width: targetWidth, height: targetHeight);
  }

  List<Employe> imagePret = [];

  compare() {
    // img.Image? image1 = img.decodeImage(Uint8List.fromList(imageProfil!));
    // img.Image? image2 = img.decodeImage(Uint8List.fromList(imageProfil1!));
    // // Définissez les dimensions cibles (la taille que vous souhaitez)
    // int targetWidth = 300;
    // int targetHeight = 200;

    // // Redimensionnez les images pour qu'elles aient la même taille
    // img.Image resizedImage1 = resizeImage(image1!, targetWidth, targetHeight);
    // img.Image resizedImage2 = resizeImage(image2!, targetWidth, targetHeight);
    double difference = 0.0;
// Comparez les images
    for (Employe personne in listesEmployes) {
      img.Image? image1 = imageProfil1 != null
          ? img.decodeImage(Uint8List.fromList(imageProfil1!))
          : img.decodeImage(Uint8List.fromList(imageProfil!));
      img.Image? image2 = img.decodeImage(Uint8List.fromList(personne.image!));
      // Définissez les dimensions cibles (la taille que vous souhaitez)
      int targetWidth = 300;
      int targetHeight = 200;

      // Redimensionnez les images pour qu'elles aient la même taille
      img.Image resizedImage1 = resizeImage(image1!, targetWidth, targetHeight);
      img.Image resizedImage2 = resizeImage(image2!, targetWidth, targetHeight);

      double imageTrouve =
          calculateImageDifference(resizedImage1, resizedImage2);

      if (imageTrouve < 2000 || imageTrouve < 3000) {
        setState(() {
          difference = imageTrouve;

          imagePret.add(personne);
        });

        // break;
      } else {
        difference = imageTrouve;
        setState(() {
          nonTrouveImage = false;
        });
      }
    }

    print('Différence d\'images : $difference');
    // Affichez la différence (une valeur plus élevée signifie une plus grande différence)
  }

  List<Employe> listesEmployes = [];

  Future<void> afficheEmploye() async {
    final affiche = await sqliteDatabase.getEmploye();
    setState(() {
      listesEmployes = affiche;
    });
  }

  @override
  void initState() {
    afficheEmploye();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Animate(
            effects: const [
              FadeEffect(begin: 5, end: 20, delay: Duration(milliseconds: 400)),
              ScaleEffect()
            ],
            child: const Text(
              "Localisez le Profil Recherché ",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          )),
      body: Column(
        children: [
          //  debut row1
          // premiere partie pour afficher les images
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
// pour l'image depuis gallerie ou camera
              Column(
                children: [
                  Container(
                    // color: Colors.amber,

                    height: 320,
                    width: 200,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            border: Border.all(
                              color: vertEmeraude,
                              style: BorderStyle.solid,
                              width: 5,
                            ),
                          ),
                          height: 250,
                          width: 200,
                          child: imageProfil != null || imageProfil1 != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.memory(
                                    imageProfil != null
                                        ? imageProfil!
                                        : imageProfil1!,
                                    cacheHeight: 200,
                                    cacheWidth: 200,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        'assets/images/7125204-removebg-preview.png',
                                        cacheWidth: 60,
                                        cacheHeight: 60,
                                      ),
                                    ),
                                    const Center(
                                        // child: Text('data'),
                                        ),
                                  ],
                                ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                style: const ButtonStyle(
                                  side: MaterialStatePropertyAll(
                                    BorderSide(
                                        color: Colors.red,
                                        style: BorderStyle.solid),
                                  ),
                                ),
                                onPressed: () {
                                  selectImageCamera();
                                },
                                child: Text('Camera'),
                              ),
                              OutlinedButton(
                                style: const ButtonStyle(
                                  side: MaterialStatePropertyAll(
                                    BorderSide(
                                        color: Colors.orange,
                                        style: BorderStyle.solid),
                                  ),
                                ),
                                onPressed: () {
                                  selectImageGallery();
                                },
                                child: Text('Gallery'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // pour afficher l'image s'il existe

              Column(
                children: [
                  Container(
                    //  color: Colors.amber,

                    height: 320,
                    width: 200,
                    child: Column(
                      children: [
                        imagePret.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                    color: vertEmeraude,
                                    style: BorderStyle.solid,
                                    width: 5,
                                  ),
                                ),
                                // color: Colors.blueGrey,
                                height: 250,
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.memory(
                                    afficheFirst == true
                                        ? imagePret[0].image!
                                        : imageFirst!,
                                    cacheHeight: 200,
                                    cacheWidth: 200,
                                    fit: BoxFit.fill,
                                  ),
                                )
                                // : Image.asset(
                                //     'assets/image_faciale/profil-removebg-preview.png'),
                                )
                            : Container(
                                height: 250,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                    color: vertEmeraude,
                                    style: BorderStyle.solid,
                                    width: 5,
                                  ),
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.red,
                                  highlightColor: vertEmeraude,
                                  child: Image.asset(
                                      'assets/image_faciale/profil-removebg-preview.png'),
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imagePret.isEmpty
                                  ? OutlinedButton(
                                      style: const ButtonStyle(
                                        side: MaterialStatePropertyAll(
                                          BorderSide(
                                              color: Colors.blue,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                      onPressed: () {
                                        cherche == true ? compare() : '';
                                      },
                                      child: cherche == true
                                          ? Text('Recherche...')
                                          : Text('En attente d\'image...'),
                                    )
                                  : OutlinedButton(
                                      style: const ButtonStyle(
                                        side: MaterialStatePropertyAll(
                                          BorderSide(
                                              color: Colors.blue,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                      onPressed: () {
                                        // compare();

                                        setState(() {
                                          imagePret = [];
                                          imageProfil = null;
                                          imageProfil1 = null;
                                          cherche = false;
                                          nonTrouveImage = true;
                                        });
                                      },
                                      child: Text('Actualiser...'),
                                    ),
                              //  OutlinedButton(
                              //   onPressed: () {},
                              //   child: Text('Gallery'),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          imagePret.isNotEmpty
              ? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Animate(
                      effects: [
                        FadeEffect(duration: Duration(milliseconds: 600)),
                        ScaleEffect()
                      ],
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: imagePret.length,
                          itemBuilder: (context, index) {
                            final employe = imagePret[index];
                            return Container(
                              // color: Colors.amberAccent,
                              margin: EdgeInsets.all(2),
                              child: Column(children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 5),
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.memory(
                                      employe.image!,
                                      cacheHeight: 200,
                                      cacheWidth: 200,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.blue[600]),
                                            foregroundColor:
                                                const MaterialStatePropertyAll(
                                                    Colors.white)),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AfficheSpecifique(employe: employe, afficheEmploye: afficheEmploye)) ,) ;
                                        },
                                        child: Text('Details'),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 4),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                afficheFirst = false;
                                                imageFirst = employe.image! ;
                                              });
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            );
                          }),
                    ),
                  ),
                )
              : Animate(
                  effects: [FadeEffect(), ScaleEffect()],
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 40, left: 4, right: 4),
                    height: 200,
                    child: Card(
                      child: nonTrouveImage == true
                          ? Center(
                              child: Animate(
                                effects: const [
                                  FadeEffect(
                                      delay: Duration(milliseconds: 600)),
                                  ScaleEffect()
                                ],
                                child: const Text(
                                  'Aucun recherche effectué !',
                                ),
                              ),
                            )
                          : Animate(
                              effects: const [
                                FadeEffect(delay: Duration(milliseconds: 600)),
                                ScaleEffect()
                              ],
                              child: const Center(
                                  child:
                                      Text('Cette personne est introuvable !')),
                            ),
                    ),
                  ),
                )

          //  fin row 1
        ],
      ),
    );
  }
}
