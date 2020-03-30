import 'dart:async';

import 'package:http/http.dart' as http; //el as es para que asi lo llamemos y despuss un . y sus metodos
import 'package:peliculas/src/models/actores_models.dart';

import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apikey    ='356707183a6f424aa6e977b4359d26a8'; //clave de la api
  String _url       ='api.themoviedb.org'; //URL utilizado
  String _language  ='es-ES'; //Asignar el lenguaje de la informacion

  int _popularesPage  = 0;
  bool _cargando      = false;//Esta ayudara a no hacer un monton de peticiones y gastar muchos datos.

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();//Especifico que contenido pasara por el stream
  //El .broatcast muchos puedes escuchar, si solo es 1 no se pone

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;//proceso para añadir peliculas

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream; 



  void disposeStreams(){
    _popularesStreamController?.close();//Si se cierra la pantalla para que no se mantenga abierto
  }


  Future<List<Pelicula>>  getEnCines() async{
  //regresa un listado de peliculas usamos async porque utilizaremos el await


    final url = Uri.https(_url, '3/movie/now_playing', {
      //uri ayuda a crear el url de peticion

      //parametros que solicita la app 
      'api_key'   : _apikey,
      'languaje'  : _language
    });

    return await _procesarRespuesta(url);

  }


  Future<List<Pelicula>>  getPopulares() async{
    //regresa un listado de peliculas usamos async porque utilizaremos el await

    if( _cargando ) return [];

    _cargando = true; 

    _popularesPage++; //Ayuda a cada que cargue aumente la pagina y asi hacer el infinit scroll

    final url = Uri.https(_url, '3/movie/popular', {
      //uri ayuda a crear el url de peticion

      //parametros que solicita la app 
      'api_key'   : _apikey,
      'languaje'  : _language,
      'page'      : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);//agregar todas las respuestas de las peliculas
    popularesSink( _populares );//agrego ahora la inf del strem mediante el sink

    _cargando = false;

    return resp;
  }


  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {

    
    final resp = await http.get( url );//Me envia la respuesta pero con await para que no envie un future sino ya la respuesta

    final decodedData = json.decode(resp.body); //Toma el string de la respuesta y transforma en map

    final peliculas = new Peliculas.fromJsonList(decodedData['results']); //Barre los resultados y los envia a el objeto pelicula


    return peliculas.items; //Regresa las peliculas listas para ser mapeadas :D
      
  }


  Future<List<Actor>> getCast( String peliId ) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key'   : _apikey,
      'languaje'  : _language
    });

    //Hago la peticion y espero a que responda
    final resp = await http.get(url);
    // decodeData = Map de respuesta web 
    final decodedData = json.decode( resp.body );

    final cast = new Cast.fromJsonList(decodedData['cast']);//decodedData['cast'] = de la respuesta obtengo todo lo de cast

    return cast.actores;
  }


  Future<List<Pelicula>>  buscarPelicula(String query) async{
    //regresa un listado de peliculas usamos async porque utilizaremos el await


    final url = Uri.https(_url, '3/search/movie', {
      //uri ayuda a crear el url de peticion

      //parametros que solicita la app 
        'api_key'   : _apikey,
        'languaje'  : _language,
        'query'     : query
      });

    return await _procesarRespuesta(url);
 
  }

}