import 'package:farmacapp/database/db.dart';
import 'package:farmacapp/modelos/usuario.dart';
import 'package:farmacapp/paginas/pantalla_add_del_usuarios.dart';
import 'package:farmacapp/paginas/pantalla_agenda.dart';
import 'package:farmacapp/paginas/pantalla_agenda_supervisor.dart';
import 'package:farmacapp/provider/modo_edicion.dart';
import 'package:farmacapp/provider/modo_trabajo.dart';
import 'package:farmacapp/provider/usuario_supervisor.dart';
import 'package:farmacapp/widgets/boton_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Pantalla que muestra los usuarios bajo supervision de un supervisor
/// junto con la opcion de añadir mas usuarios o dejar de supervisarlos.
/// 
class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {

  // INSTANCIA BASE DE DATOS LOCAL
  BDHelper bdHelper = BDHelper();

  // INSTANCIA MODELO USUARIO
  Usuario u = new Usuario();

  // METODOS
  _loadPantallaAgendaSupervisor () async{
    final destino = MaterialPageRoute(builder:(_)=>PantallaAgendaSupervisor());
    final datoDevuelto = await Navigator.push(context, destino);
  }


  _loadPantallaAddDelUsuarios() async {
    final destino = MaterialPageRoute(builder: (_) => PantallaAddDelUsuarios());
    final datoDevuelto = await Navigator.push(context, destino);
  }

  @override
  Widget build(BuildContext context) {

    // PROVIDERS
    var modoTrabajo = Provider.of<ModoTrabajo>(context);
    var modoEdicion = Provider.of<ModoEdicion>(context);
    var usuarioIniciado = Provider.of<Usuario>(context);
    var usuarioSupervisor = Provider.of<UsuarioSupervisor>(context);
    
    // METODO PARA LLAMAR A LOS METODOS PARA RECUPERAR USUARIOS
    // SEGUN ESTEMOS EN MODO REMOTO O LOCAL
    Future<List<Usuario>> recuperarUsuarios() async{
      // MODO REMOTO
      if(modoTrabajo.modoLocal){
        return u.getUsuariosSupervisor(usuarioSupervisor.id);
      }
      // MODO LOCAL
      else{
        return await bdHelper.getUsuariosSupervisor(usuarioSupervisor.id);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("MIS USUARIOS"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: Text('Añadir usuario'),
                  value: 'addusuario',
                ),
                PopupMenuItem(
                  child: Text('Eliminar usuario'),
                  value: 'delusuario',
                ),
              ];
            },
            onSelected: (value) async{
              if(value == 'addusuario'){
                modoEdicion.addusuario = true;
              }
              else{
                modoEdicion.addusuario = false;
              }
              // IR PANTALLA ADD/DEL USUARIOS
              _loadPantallaAddDelUsuarios();
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: recuperarUsuarios(),
          builder: (context, AsyncSnapshot<List<Usuario>> snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  return Container(
                    height: 100,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white
                    ),
                    child: InkWell(
                      onTap: () {
                        // RECOGER LOS DATOS DEL USUARIO SELECCIONADO
                        usuarioIniciado.id = snapshot.data![index].id;
                        usuarioIniciado.id_supervisor = snapshot.data![index].id_supervisor;
                        usuarioIniciado.nombre = snapshot.data![index].nombre;
                        usuarioIniciado.correo = snapshot.data![index].correo;
                        usuarioIniciado.password = snapshot.data![index].password;

                        // IR A AGENDA SUPERVISOR
                        _loadPantallaAgendaSupervisor();
                      },
                      child: BotonUsuario(
                        nombre: snapshot.data![index].nombre,
                        correo: snapshot.data![index].correo
                      )
                    ),
                  );
                }
              );
            }
            else{
              // TEXTO NO HAY USUARIOS Y AÑADIR UNO
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'NO HAY USUARIOS A SU CARGO. PULSE EN EL BOTON "+" SITUADO ARRIBA PARA AÑADIR A UN USUARIO.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}