import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quiestce/employes/affiche_cv.dart';
import 'package:quiestce/employes/edit.dart';
import 'package:quiestce/models/employe.dart';
import 'package:quiestce/options/couleurs.dart';
import 'package:quiestce/sqlite_database/sqlite_database.dart';

class AfficheSpecifique extends StatefulWidget {
  final Employe employe;
  final Function afficheEmploye;
  const AfficheSpecifique(
      {super.key, required this.employe, required this.afficheEmploye});

  @override
  State<AfficheSpecifique> createState() => _AfficheSpecifiqueState();
}

class _AfficheSpecifiqueState extends State<AfficheSpecifique> {
  final sqliteDatabase = SqliteDatabase();
   Color vertEmeraude = Couleurs.vertEmeraude;

  Future<void> confirmerSuppression(int id) async {
    await sqliteDatabase.deleteEmploye(id);
    final initEmploye = await sqliteDatabase.getEmploye();
    setState(() {
      widget.afficheEmploye();
    });
  }

  alertSuppression(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: const Text(
              'Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                confirmerSuppression(id);

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // afficheEmployeSpecifique();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Informations',style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
            fontWeight: FontWeight.bold
          ),),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 5)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.memory(
                      widget.employe.image!,
                      cacheHeight: 150,
                      cacheWidth: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    widget.employe.prenom,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 141, 141, 141)),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 300,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(221, 166, 172, 168),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: 90,
                      child: const Center(
                          child: Text(
                        'Nom :',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      child: Center(
                          child: Text(
                        widget.employe.nom,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: 90,
                      child: const Center(
                          child: Text(
                        'Poste :',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      child: Center(
                          child: Text(
                        widget.employe.poste,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: 90,
                      child: const Center(
                          child: Text(
                        'Adresse :',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      child: Center(
                          child: Text(
                        widget.employe.adresse,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: 90,
                      child: const Center(
                          child: Text(
                        'Email :',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      child: Center(
                          child: Text(
                        widget.employe.email,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: 90,
                      child: const Center(
                        child: Text(
                          'Numero :',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      child: Center(
                        child: Text(
                          widget.employe.numero.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
        child: ElevatedButton.icon(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AfficheCv(employe:widget.employe))) ;
        }, icon:  Icon(Icons.picture_as_pdf_sharp,color: vertEmeraude), label: const Text('Cv')),
          ) , 
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  style: const ButtonStyle(
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.red))),
                  onPressed: () {
                    alertSuppression(context, widget.employe.id!);
                  },
                  child: const Text(
                    'Supprimez',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                OutlinedButton(
                  style: const ButtonStyle(
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.blueAccent))),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Edit(employe:widget.employe,afficheEmploye:widget.afficheEmploye,)));
                  },
                  child: const Text(
                    'Modifiez',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
