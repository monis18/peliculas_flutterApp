import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
      initialPage: 1,
      viewportFraction: 0.3 //Mostrar 3 targetas en pantalla, cada una ocupa 0.3 del espacio por eso se alcanzan a mostrar 
        
  ); 
  
  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size; //para saber la dimension de la pantalla

    _pageController.addListener((){
      //Se dispara que se mueva el horizontal

      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        //Si me encuentro al final pero 200 pixeles antes, para que carge con anterioridad

        siguientePagina();


      }

    });

    return Container(
      height: _screenSize.height * 0.3, //Esto es el 20% de la pantalla
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _tarjeta(context, peliculas[i]),
      ),
    );
  }

  Widget _tarjeta (BuildContext context, Pelicula pelicula){

    pelicula.uniqueID = '${ pelicula.id }-poster';

    //Esta targeta contiene la informacion de toda la targeta
    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            
            Hero(
              tag: pelicula.id,//id unico que lo identifica
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 160.0,
                ),
              ),
            ),

            SizedBox(height: 5.0,),

            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,//Muestra ... cuando no cabe el texto
              style: Theme.of(context).textTheme.caption,
              )
          ],
        ),
      );

      //Sirve para detectar todo lo que se hace en pantalla (Taps)
      return GestureDetector(
        child: tarjeta,
        onTap: (){
          //print('ID de la pelicula ${pelicula.title}');

          Navigator.pushNamed(context, 'detalle', arguments: pelicula);

        },
      );
  }


//No se utiliza, queda como referencia
  List<Widget> _tarjetas(BuildContext context){

    return peliculas.map((pelicula){

      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),

            SizedBox(height: 5.0,),

            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,//Muestra ... cuando no cabe el texto
              style: Theme.of(context).textTheme.caption,
              )
          ],
        ),
      );

    }).toList() ;

  }
}