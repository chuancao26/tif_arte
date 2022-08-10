pajaro pa = new pajaro();
bloque[] bl = new bloque[3];
boolean fin=false;
boolean inicio=true;
int puntaje=0;
void setup(){
  size(500,800);
  for(int i = 0;i<3;i++){
  bl[i]=new bloque(i);
  }
}
void draw(){
  background(0);
  if(fin){
  pa.move();
  }
  pa.dibujarpajaro();
  if(fin){
  pa.caida();
  }
  pa.revisarchoque();
  for(int i = 0;i<3;i++){
  bl[i].dibujarbloque();
  bl[i].revisarPosition();
  }
  fill(0);
  stroke(255);
  textSize(25);
  if(fin == true){
  rect(20,20,100,50);
  fill(255);
  text(puntaje,30,58);
  }else{
  rect(150,100,200,50);
  rect(150,200,200,50);
  fill(255);
  if(inicio){
    text("Flappy Code",155,140);
    text("Click to Play",155,240);
  }else{
  text("Juego finalizado",170,140);
  text("Tu puntaje es: ",150,240);
  text(puntaje,280,240);
  }
  }
}
class pajaro{
  float posx,posy,yvel;
pajaro(){
posx = 250;
posy = 400;
yvel = 0;
}
void dibujarpajaro(){
  fill(255,0,0);

  rect(posx,posy,20,20);
  triangle(posx+20,posy+10,posx+25,posy+10,posx+20,posy+15);
  if (second()%2 == 0){
  fill(0);
  }else{
  fill(255);}
  circle(posx+10,posy+10,5);

}
void salto(){
 yvel=-10; 
}
void caida(){
 yvel+=0.4; 
}
void move(){
 posy+=yvel; 
 for(int i = 0;i<3;i++){
   println(bl[i].posx);
   bl[i].posx-=3;
  
 }
}
void revisarchoque(){
 if(posy>800){
  fin=false;
 }
for(int i = 0;i<3;i++){
  if((posx<bl[i].posx+10&&posx>bl[i].posx-10)&&(posy<bl[i].opening-100||posy>bl[i].opening+100)){
   fin=false; 
  }
}
} 
}
class bloque{
  float posx, opening;
  boolean cashed = false;
 bloque(int i){
  posx = (i*200);
  opening = random(600)+100;
  println(i);
 }
 void dibujarbloque(){
   line(posx,0,posx,opening-100);  
   line(posx,opening+100,posx,800);
 }
 void revisarPosition(){
  if(posx<0){
   posx+=(200*3);
   opening = random(600)+100;
   cashed=false;
  } 
  if(posx<250&&cashed==false){
   cashed=true;
   puntaje++; 
  }
 }

}
void reset(){
 fin=true;
 puntaje=0;
 pa.posy=400;
 for(int i = 0;i<3;i++){
  bl[i].posx+=550;
  bl[i].cashed = false;
 }
}
void mouseClicked  (){
 pa.salto();
 inicio=false;
 if(fin==false){
   reset();
 }
}
void keyPressed(){
 pa.salto(); 
 inicio=false;
 if(fin==false){
   reset();
 }
}
