import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();


  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America',
    'Ironman 1',
    'Ironman 2',
    'Ironman 3',
    'Ironman 4',
    'Ironman 5',
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro AppBar (Limpiar o cancelar busqueda)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';//Es todo lo que la persona escriba se va guardando en esta variable

        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation //Tiempo en el que se va a animar el icono
        ), 
      onPressed: (){
        close(context, null);//recibe el context y el 'null' es lo que regresamos al terminar esto
      }
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    
    if( query.isEmpty ){
      //Esto es seguridad si envian algo vacio
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        //Aqui tendriamos que regresar la tarjeta
        
        if(snapshot.hasData){

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage( pelicula.getPosterImg() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain, //No se salga de sus bordes
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueID='';
                  Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                },
              );
            }).toList()
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      },
    );

  }



}

//Esto es el otro codigo creado como ejemmplo

// @override
//   Widget buildSuggestions(BuildContext context) {
//     // Son las sugerencias que aparecen cuando la persona escribe

//     final listaSugerida = ( query.isEmpty)
//                           ? peliculasRecientes //true
//                           : peliculas.where(//False
//                             (p)=> p.toLowerCase().startsWith(query.toLowerCase())
//                             ).toList();//Me regresa una lista al dinal



//     return ListView.builder(
//       itemCount: listaSugerida.length,
//       itemBuilder: (context,i){
//         return ListTile(
//           leading: Icon(Icons.movie),
//           title: Text(listaSugerida[i]),
//           onTap: (){
//             seleccion = listaSugerida[i];
//             showResults(context);//Para construir los resultados a partir de dar un Click!!
//           },
//         );
//       },
//     );
//   }


