import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';



class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();//propiedad de clase


  @override
  Widget build(BuildContext context) {

peliculasProvider.getPopulares();//Llamamos una vez para que aparezca algo en el stream

    return Scaffold(
      
      appBar: AppBar(
        centerTitle: false, //Deja el titulo a la izquierda
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              //funcion de flutter para buscar
              showSearch(
                context: context, 
                delegate: DataSearch(),
                //query: 'hola' este sirve para tener alguna palabraya preescrita
                );

            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,//Espacio entre objetos de la columna
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        ),
      )
      
       //SafeArea(   //Sirve para que exista un espacio encima de la pantalla por si tiene algo que la tape
       //child: Text('Hola Mundo !!!!!!!!'),
       //)
      
    );
  }

  Widget _swiperTarjetas(){

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {//Snapshot = tiene list de peliculas
        
        if (snapshot.hasData){
          //Si tiene informacion
          return CardSwiper(peliculas: snapshot.data);
        }else{
          //Si no uno de carga/loading
          return Container(
            //lo puse dentro del container para que se vea en el centro :D
            height: 400,
            child: Center(
              child: CircularProgressIndicator()
              )
            );
        }
      },
    );

    //return CardSwiper(
    //  peliculas: [1,2,3,4,5],
    //);
    
  }

  Widget _footer(BuildContext context){

    return Container(
      width: double.infinity,//Tome todo el ancho 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,//Es columna por eso utiliza el cross
        children: <Widget>[
          
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead)
              ),

          SizedBox(height: 5.0),


          //FutureBuilder( este carga una sola vez
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              if(snapshot.hasData){
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                  );
              }else{
                return Center(child: CircularProgressIndicator());
              }

            },
          ),
        ],
      ),
    );
  }

}