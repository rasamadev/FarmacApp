import 'package:farmacapp/modelos/usuario.dart';
import 'package:farmacapp/widgets/dialogo.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:farmacapp/database/db.dart';

class PantallaNuevoUsuario extends StatefulWidget {
  const PantallaNuevoUsuario({super.key});

  @override
  State<PantallaNuevoUsuario> createState() => _PantallaNuevoUsuarioState();
}

class _PantallaNuevoUsuarioState extends State<PantallaNuevoUsuario> {
  @override
  Widget build(BuildContext context) {
    
    late String nombre = "";
    late String correo = "";
    late String pass = "";
    late String confirmarpass = "";
    BDHelper bdHelper = BDHelper();
    
    return Scaffold(
      // #################### APPBAR ####################
      appBar: AppBar(
        automaticallyImplyLeading: false, // HACE QUE NO SALGA EL BOTON DE VOLVER
        title: Center(
          child: Text("CREAR USUARIO"),
        ),
      ),
      // ####################  BODY  ####################
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // TEXTO: "Introduzca su nombre y apellidos"
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                "Introduzca su nombre y apellidos",
                style: TextStyle(
                  fontSize: 19
                ),
              ),
            ),
          ),
          // TEXFIELD NOMBRE COMPLETO USUARIO
          Center(
            child: Container(
              width: 350,
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Nombre Apellido1 Apellido2",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value){
                  nombre = value;
                },
              ),
            ),
          ),
          // TEXTO: "Introduzca su correo electronico"
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                "Introduzca su correo electronico",
                style: TextStyle(
                  fontSize: 19
                ),
              ),
            ),
          ),
          // TEXFIELD CORREO ELECTRONICO USUARIO
          Center(
            child: Container(
              width: 350,
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Correo electronico",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value){
                  correo = value;
                },
              ),
            ),
          ),
          // TEXTO: "Introduzca una contraseña"
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                "Introduzca una contraseña",
                style: TextStyle(
                  fontSize: 19
                ),
              ),
            ),
          ),
          // TEXFIELD CONTRASEÑA USUARIO
          Center(
            child: Container(
              width: 350,
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value){
                  pass = value;
                },
              ),
            ),
          ),
          // TEXTO: "Confirme la contraseña"
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                "Confirme la contraseña",
                style: TextStyle(
                  fontSize: 19
                ),
              ),
            ),
          ),
          // TEXFIELD CONFIRMAR CONTRASEÑA USUARIO
          Center(
            child: Container(
              width: 350,
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value){
                  confirmarpass = value;
                },
              ),
            ),
          ),
          // BOTON INICIAR SESION
          Center(
            child: Container(
              width: 300,
              margin: EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: TextButton(
                child: const Text(
                  "CREAR USUARIO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22
                  ),
                ),
                onPressed: () async{
                  // CONSULTAMOS A LA BASE DE DATOS SI EXISTE ALGUN USUARIO CON EL CORREO INTRODUCIDO
                  // SI EXISTE, GUARDARA 1
                  // SI NO, GUARDARA 0
                  int c = await bdHelper.comprobarCorreo("usuarios", correo);

                  // SI EL USUARIO NO HA RELLENADO TODOS LOS CAMPOS
                  if(nombre == "" || correo == "" || pass == "" || confirmarpass == ""){
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => Dialogo(texto: 'Por favor, rellena todos los campos.')
                    );
                  }
                  // SI LAS CONTRASEÑAS NO COINCIDEN
                  else if(pass != confirmarpass){
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => Dialogo(texto: '¡Las contraseñas no coinciden!')
                    );
                  }
                  // COMPROBACION DE SI EL CORREO INTRODUCIDO YA EXISTE EN LA BASE DE DATOS
                  else if(c != 0){
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => Dialogo(texto: 'Ya existe un usuario registrado con la cuenta de correo proporcionada.')
                    );
                  }
                  // INSERCION DEL USUARIO EN LA BASE DE DATOS Y VOLVEMOS ATRAS
                  else{
                    bdHelper.insertarBD("usuarios",{'nombre':nombre, 'correo':correo, 'password':pass});
                    print("USUARIO CREADO.");
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}