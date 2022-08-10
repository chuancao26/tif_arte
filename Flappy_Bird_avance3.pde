//Somos:
//Chancayauri Mamani Jose Fernando
//Huanca Olazabal Cristhian David
boolean start_game = false;
boolean game_over = true;
bloque [] bloque = new bloque[3];
pajaro pajaro = new pajaro();
int puntaje = 0;
void setup(){
    size(540,960);
    for(int i = 0; i < 3; i++){
      bloque[i] = new bloque(i);
    }
}
void draw(){
  println(bloque[1].posx-bloque[0].posx);
  background(0);
  pajaro.puntaje = puntaje;
  if (start_game == true){
      pajaro.movimiento();
  }
  pajaro.dibujarPajaro();
  if (start_game == true){
    pajaro.caida();
  }
  pajaro.colision();
  for (int i = 0; i < 3; i++){
    bloque[i].dibujarBloque();
    bloque[i].posicion_inicial_bloque();
  }
  fill(0);
  stroke(255);
  textSize(25);
  if (start_game == true){
    fill(255);
    text(puntaje,width/2,200);
   } else{
     //los cuadros en los cuales se mostraeran en caso el juego no haya iniciado
     fill(255);
     if(game_over == true){
       text("Flappy bird",width/2-40,height/2-50);
       //text("Click para jugar",155,240);
     }else{
       fill(0);
       rect(100,100,340,200);
       fill(255);
       text("Juego acabado",150,170);
       text("Tu puntaje es: ", 150,240);
       text(puntaje, 340,240);
     }
   }
}

//veamos las clases a utilizar 
// en primer lugar tenemos al pajarito, para lo cual crearemos una clase con este nombre 
//este tendra como principales atributos, posx, posy y la velocidad a la cual decendera vely
class pajaro{
  float posx, posy, vely, size, puntaje, factor;
  ///seteamos los valores iniciales de las posiciones x  e y 
  //elegimos tener una pantalla de 
  //iniciamos al constructor
  pajaro(){
    posx = 270;
    posy = 960/2;
    size = 20;
    vely = 0;
    puntaje = 0;
    factor = 0;
    //Este se ira incrementando conun valor fijo posteriormente
  }
  // el primer metodo sera el dibujo del pajaro
  void dibujarPajaro(){
  //cuerpo
  fill(255,0,0);
  rect(posx,posy,size,size);
  ///pico
  triangle(posx+size,posy+size/2,posx+size+5,posy+size/2,posx+size,posy+size-5);
  //parpadeo
  if (second()%2 == 0){
    fill(0);
  }else{
    fill(255);}
  //ojos
  circle(posx+size/2,posy+size/2,size/4);
  }
  //algunos metodos que tendra este objeto son 
  //saltar
  void salto(){
    vely = -10;//con esta velocidad solo se ncesitara pcos clicks de raton para saltar el bloque 
  }
  //caida, debido a que el pajarito es victima de la gravedad. este ira incremetandose de forma creciente
  void caida(){
    vely += .4;
  }
  //movimiento alrededor del eje y, ya que para x no se movera.
  // este metodo unira el efecto del usuario al momento de hacer click y el salto y las condiciones dadas en
  //la caida. Ambas afectaran a la posicion y
  void movimiento(){
     posy += vely;
     // los movimientos tienen que ser acompa;ados por los bloques, 
     //por lo cual vamos a setear su parametro con valores que se iran reduciendo en razon de 3.
      factor += .0001;
      for (int i = 0; i<3 ; i++){
        bloque[i].posx -= 3 + factor;
      
        
     }
     //Incrementaremos la dificultad agregando mas velocidad al juego en cuando pasemos de 10 en 10 de puntaje  
     
 
   }
     //Ahora evaluemos la reaccion del programa cuando hagamos algun movimiento mal
  void colision(){
    //1er movimiento malo
    //Si nuestro pajarito en su posicion y esta debajo de nuestra ventana de 960 entonces el jeugo habra acabado
    if (posy >960){
      start_game = false;
    }
    //2do movimiento malo
    //Si nuestro pajario choca con los bordes de lo bloques de ancho 20 ya sea de los bloques arriba de la apertura asi como los que
    //estan debajo de esta
    for (int i = 0; i < 3; i++){
      if(((posx<bloque[i].posx+10) & (posx>bloque[i].posx - 10))&((posy<bloque[i].apertura - 100)|(posy>bloque[i].apertura+100))){
        start_game = false; 
      }
    
    }
  
  }
}
// ahora vamos a destart_gameir a la clase bloques, los cuals nos ayudaran a crear esta ilusion de movimiento
//Para lo cual destart_gameifremos una clase que tendra el mismo nombre 
class bloque{
  float posx, apertura;
  PImage tuberia_inferior, tuberia_superior;
  //por defecto no hay choque por eso tiene valor de false
  boolean checker = false;
  //el constructore recibira como unico parametro externo una variable que nos ayduara a modificar las 
  //posicion inicial de este bloque 
  bloque(int cambio){
    posx = cambio*250;
    apertura = random(700)+100;// Tendra un valor inicial para que no inice desde 0, haciendo imposbile llegar con los clicks
    tuberia_superior = loadImage("http://1.bp.blogspot.com/--dR77QHGDh8/UwIDd3D9WII/AAAAAAAAbIY/boBgGvmqT5I/s1600/Flappy+Bird+pipe+(tuber%C3%ADa+b)+-+La+Verdadera+Historia+de+Flappy+Bird.jpg"); 
    tuberia_inferior = loadImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNdmIJ-qRU7hoUdaaDuLXWzKopWJXyBoiyL5DyZn6BFkUS293qznfqn_QQmY5UtnmxNA&usqp=CAU"); 
}
  //como primer metodo dibujaremos el bloque
  void dibujarBloque(){
    //habra una linea inicial que acabara en la apertura   
   //line(posx,0,posx,apertura-100);// donde 100 sera el tama;o de la apertura
   
   image(tuberia_inferior,posx,apertura+100,40,960); // el 100 es la separacion entre las 2 lineas
   image(tuberia_superior,posx,0,40,apertura-100);
} 
  // como este objeto bloque estara moviendoce hacia valores de x negativos, es necesario implementar
  //un metodo que nos permita volver a setear los valores determinados para cada uno de los bloques 
  void posicion_inicial_bloque(){
    //en caso el bloque haya llegado un posicion menor a 0, entonces procedera a setear su posx a 600 
     if (posx<-20){
        posx = 750;
        apertura = random(100,700);
        // la variable chekcer nos ayduara a que no haya contabilidad extra de los puntos 
        //de esta forma cada uno de los bloques valdra un punto
        checker = false;
       }
      if ((posx < 270)&(checker == false)){
        checker = true;
        puntaje += 1;      
      }
  } 
}
// en caso incurramos en error 
void reinicio(){
  start_game = true;
  puntaje = 0;
  pajaro.factor = .1;
  pajaro.posy = height/2; // que es la posicion inicial central
  //tambien setearemos a valores iniciales a los 3 bloques 
  for (int i = 0; i < 3; i++){
    bloque[i].posx += 550;
    bloque[i].apertura = random(700);
    bloque[i].checker = false;
  }
}
//ahora veamos las interacciones del usuario
//para lo cual usaremos la funcion mouseClicked
void mouseClicked(){
  // la primerca accion es saltar
  pajaro.salto();
  game_over = false;
  if (start_game == false ){
    reinicio();
}
}
