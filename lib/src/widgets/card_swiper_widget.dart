import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas});//metodo constructor lo requiere indispensablemente


  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;//para saber las dimensiones de pantalla del dispositivo
    

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        //width: double.infinity,//utiliza todo el ancho posible
        itemWidth: _screenSize.width * 0.7, //70% del ancho
        itemHeight: _screenSize.height * 0.4, //70% de la altura
        itemBuilder: (BuildContext context,int index){
          
          peliculas[index].uniqueID = '${ peliculas[index].id }-targeta';

          //construir imagenes desde esa direccion web
          return Hero(
            tag: peliculas[index].uniqueID,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: ()=> Navigator.pushNamed(context, 'detalle',arguments: peliculas[index]),
                child: FadeInImage(
                  image: NetworkImage( peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,//adapte a todo el ancho que tiene
                ),
              ),
              //Hace un fit para que el tamaño se adapte
            ),
          );
        },
        itemCount: peliculas.length,
        //pagination: new SwiperPagination(), // muestre en la parte de abajo
        //control: new SwiperControl(), //muestralas flechas de izq y der
        layout: SwiperLayout.STACK,
      ),
    );
  }
}