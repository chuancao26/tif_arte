//Somos:
//Chancayauri Mamani Jose Fernando
//Huanca Olazabal Cristhian David
import ddf.minim.*;

Minim minim;
AudioSample sonido_salto;
AudioSample sonido_choque;
AudioSample sonido_punto;
int error = 0;
boolean start_game = false;
boolean initial_status = true;
bloque [] bloque = new bloque[3];
pajaro pajaro = new pajaro();
int puntaje = 0;
int puntaje_max = 0; 
void setup(){
    minim = new Minim(this);
    size(540,960);
    for(int i = 0; i < 3; i++){
      bloque[i] = new bloque(i);
    }
    sonido_salto = minim.loadSample("SONIDO_SALTO.wav");
    sonido_choque = minim.loadSample("SONIDO_CHOQUE.wav");
    sonido_punto = minim.loadSample("SONITO_PUNTO.wav");
}
void draw(){
  
  println(bloque[1].posx-bloque[0].posx);
  background(0);
  if (puntaje>puntaje_max){
    puntaje_max = puntaje;
  }
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
    text("Max. Puntaje", 20,20);
    
    
    text(puntaje,width/2,200);
    text(puntaje_max,170,20);   
 } else{
     //los cuadros en los cuales se mostraeran en caso el juego no haya iniciado
     fill(255);
     if(initial_status == true){
       text("Flappy bird",width/2-40,height/2-50);
       puntaje_max = 0;
       //text("Click para jugar",155,240);
     }else{
       fill(0);
       rect(100,100,340,200);
       fill(255);
       text("Juego acabado",150,170);
       text("Tu puntaje es: ", 150, 240);
       text(puntaje, 340,240);
     }
   }
}

//veamos las clases a utilizar 
// en primer lugar tenemos al pajarito, para lo cual crearemos una clase con este nombre 
//este tendra como principales atributos, posx, posy y la velocidad a la cual decendera vely
class pajaro{
  float posx, posy, vely, size, factor;
  PImage cuerpo;
  ///seteamos los valores iniciales de las posiciones x  e y 
  //elegimos tener una pantalla de 
  //iniciamos al constructor
  pajaro(){
    posx = 270;
    posy = 960/2;
    size = 40;
    vely = 0;
    factor = 0;
    //sonido_salto = minim.loadFile("SONIDO_SALTO.wav");
    cuerpo = loadImage("https://github.com/chuancao26/tif_arte/blob/main/image-removebg-preview.png?raw=true");
    //Este se ira incrementando conun valor fijo posteriormente
  }
  // el primer metodo sera el dibujo del pajaro
  void dibujarPajaro(){
      image(cuerpo,posx,posy,size,size);  
   
  //cuerpo
  //fill(255,0,0);
  //rect(posx,posy,size,size);
  /////pico
  //triangle(posx+size,posy+size/2,posx+size+5,posy+size/2,posx+size,posy+size-5);
  ////parpadeo
  //if (second()%2 == 0){
  //  fill(0);
  //}else{
  //  fill(255);}
  ////ojos
  //circle(posx+size/2,posy+size/2,size/4);
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
      factor += .001;
     //Para agregar dificultad, existe este la variable factor que ira incrementandose a razon de .001
      for (int i = 0; i<3 ; i++){
        bloque[i].posx -= 3 + factor;
     }
   }
     //Ahora evaluemos la reaccion del programa cuando hagamos algun movimiento mal
  void colision(){
    //1er movimiento malo
    //Si nuestro pajarito en su posicion y esta debajo de nuestra ventana de 960 entonces el jeugo habra acabado
    if ((posy >960) & (initial_status == false)){
      start_game = false;
      error += 1;
    }
    //sonido_choque.trigger(); 
    //2do movimiento malo
    //Si nuestro pajario choca con los bordes de lo bloques de ancho 20 ya sea de los bloques arriba de la apertura asi como los que
    //estan debajo de esta
    for (int i = 0; i < 3; i++){
      if((initial_status == false) & ((posx>bloque[i].posx-40) & (posx<bloque[i].posx + 40))&((posy<=bloque[i].apertura - 110)|(posy>=bloque[i].apertura+70))){
        error += 1 ;
        start_game = false; 
      }
    }
    if((error == 1)){
      sonido_choque.trigger();
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
    apertura = random(100,700);// Tendra un valor inicial para que no inice desde 0, haciendo imposbile llegar con los clicks
    tuberia_superior = loadImage("http://1.bp.blogspot.com/--dR77QHGDh8/UwIDd3D9WII/AAAAAAAAbIY/boBgGvmqT5I/s1600/Flappy+Bird+pipe+(tuber%C3%ADa+b)+-+La+Verdadera+Historia+de+Flappy+Bird.jpg"); 
    tuberia_inferior = loadImage("http://1.bp.blogspot.com/--dR77QHGDh8/UwIDd3D9WII/AAAAAAAAbIY/boBgGvmqT5I/s1600/Flappy+Bird+pipe+(tuber%C3%ADa+b)+-+La+Verdadera+Historia+de+Flappy+Bird.jpg"); 
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
    //en caso el bloque haya llegado un posicion menor a 0, entonces procedera a setear su posx a 720 
     if (posx<-30){
        posx = 720;
        apertura = random(100,700);
        // la variable chekcer nos ayduara a que no haya contabilidad extra de los puntos 
        //de esta forma cada uno de los bloques valdra un punto
        checker = false;
       }
      if ((posx < 270)&(checker == false)&(initial_status == false)){
        checker = true;
        sonido_punto.trigger();
        puntaje += 1;      
      }
  } 
}
// en caso incurramos en error 
void reinicio(){
  start_game = true;
  error = 0;
  puntaje = 0;
  //Para setear desde 0 el factor de dificultad y de sta forma no mantendra sus valores en el juego
  pajaro.factor = 0;
  pajaro.posy = height/2; // que es la posicion inicial central
  //tambien setearemos a valores iniciales a los 3 bloques 
  for (int i = 0; i < 3; i++){
    //incrementar las posx de aparicion en 540
    bloque[i].posx += 540;
    //Para que la nueva apertura sea otra vez random 
    bloque[i].apertura = random(700);
    bloque[i].checker = false;
  }
}
//ahora veamos las interacciones del usuario
//para lo cual usaremos la funcion mouseClicked
void mouseClicked(){
  // la primerca accion es saltar
  pajaro.salto();
  sonido_salto.trigger();
  
  //pajaro.sonido_salto.play();
  initial_status = false;
  if (start_game == false ){
    reinicio();
}
}
