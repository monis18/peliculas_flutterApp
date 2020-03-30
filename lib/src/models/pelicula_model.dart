class Peliculas{

  List<Pelicula> items = new List(); //lista de peliculas

  Peliculas();//constructor simple/vacio

  Peliculas.fromJsonList(List<dynamic> jsonList){
    //recibe el mapa de todas las respuestas y transforma a mi clase

    if(jsonList == null) return;//no hay nada, se sale, puedo enviar un error pero dejare asi

    //recorrer la lista de peliculas
    for( var item in jsonList ){
      final pelicula = new Pelicula.fromJsonMap(item);//Las transforma
      items.add( pelicula ); //Agrega a la lista
    }

  }
}

//Sirve por si guardo una pelicula creo la instancia

class Pelicula {
  String    uniqueID;
  double    popularity;
  int       voteCount;
  bool      video;
  String    posterPath;
  int       id;
  bool      adult;
  String    backdropPath;
  String    originalLanguage;
  String    originalTitle;
  List<int> genreIds;
  String    title;
  double    voteAverage;
  String    overview;
  String    releaseDate;

  Pelicula({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  //Funcion que llamo cuando quiero instanciar una pelicula que viene de una mapa con formato JSON
  Pelicula.fromJsonMap(Map<String, dynamic> json){
    
    //Map con llave un string y el otro dynamic por la variedad de valor
    //Ahora tomamos cada valor que recibimos y lo asignamos a cada una de las propiedades
    //Es otro constructor

    popularity        = json['popularity'] / 1; //convertir a double siempre
    voteCount         = json['vote_count'];
    video             = json['video'];
    posterPath        = json['poster_path'];
    id                = json['id'];
    adult             = json['adult'];
    backdropPath      = json['backdrop_path'];
    originalLanguage  = json['original_language'];
    originalTitle     = json['original_title'];
    genreIds          = json['genre_ids'].cast<int>();  //Hacer un casteo a entero
    title             = json['title'];
    voteAverage       = json['vote_average'] / 1 ;//convertir a double
    overview          = json['overview'];
    releaseDate       = json['release_date'];
  
  }

  getPosterImg(){

    if( posterPath == null){
      return 'https://lh3.googleusercontent.com/proxy/vprydWXgSd1V1HHyrjYLKa9SO9LVOqvV_9f2hj0DLBoNT9N3iTR6uexslxx2orHjjkZQWOYYqn33pXNX_Wrj4aSNzm0ETVfHNObnQo2Po6YkH1AqRWU-THqsaJ6YCKsZPA';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }

  }


  getBackgroundImg() {

    if ( backdropPath == null ) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }

  }
}


//Se copia la peticion, despues aqui buscas el codigo en el buscador de visual studio
//Paste JSON as CODE
//selecionas el nombre que se desea utilizar
//Solita se crea toda la recepcion
//Utilizamos una pagia externa para ver la informacion en JSON