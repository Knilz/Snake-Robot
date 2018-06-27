class Arena{
  private int pBreite;  //Pixelanzahl in Breite
  private int pHoehe;   //Pixelanzahl in Hoehe
  private float aBreite;  //Arenabreite in mm
  private float aHoehe;   //Arenahoehe in mm
  
  private Capture cam;    //Kamera
  
  private color[][] pic;   //2-dimensionaler Array von Farben aus Kamerabild
  
  //aktuelle Position von
  public PVector posFood;   //Futter
  public PVector posFront;  //vorderer Markierung der Schlange
  public PVector posBack;   //hinterer Markierung der Schlange
  
  public float deg; //Gradzahl (in deg) um die die Snake im Uhrzeigersinn drehen muss
  public float dist; //Distanz die der Roboter vorwärts fahren muss
  
  //Farbe bei tatsächlicher Beleuchtung von
  private color colHint;  //Hintergrund
  private color colFood;  //Futter
  private color colFront; //vorderer Markierung der Schlange
  private color colBack;  //hinterer Markierung der Schlange
  
  //einzige Konstruktor 
  public Arena(Capture cam,int pBreite, int pHoehe, float aBreite,float aHoehe){
      this.cam = cam;
      this.cam.start();
      
      this.pBreite = pBreite;
      this.pHoehe = pHoehe;
      this.aBreite = aBreite;
      this.aHoehe = aHoehe;
      VerhCheck();
      
      posFood = new PVector(0,0);
      posFront = new PVector(0,0);
      posBack = new PVector(0,0);
      
      pic = new color[pBreite][pHoehe];
      
      //initCols();
      colHint = color(122,122,122);
      colFront = color(135,15,40);
      colBack = color(10,105,80);
      colFood = color(165,120,170);
  }
  private void initCols(){
    //Farben bei optimaler Beleuchtung:
      color oHint = color(255,255,255);  //weiß
      color oFront = color(255,0,0);     //rot
      color oBack = color(0,255,0);      //grün  
      color oFood = color(0,0,255);      //blau
      
      colHint = pic[(int)(pBreite/2)][(int)(pHoehe/2)];
      
      color dif = color(red(oHint)-red(colHint),green(oHint)-green(colHint),blue(oHint)-blue(colHint));
      
      colFront = color(red(oFront)-red(dif),green(oFront)-green(dif),blue(oFront)-blue(dif));
      colBack = color(red(oBack)-red(dif),green(oBack)-green(dif),blue(oBack)-blue(dif));
      colFront = color(red(oFood)-red(dif),green(oFood)-green(dif),blue(oFood)-blue(dif));
  }
   //aktualisiert die Positionen 
   public void update(){
     updatePic();
     updatePos();
     updateDegDist();
     camPic();
     drawPos();
   }
   public void printColAtPos(int x,int y){
      printCol(pic[x][y]);
   }
   //aktualisiert Positionen von Food,Front,Back anhand von Array pic
   private void updatePos(){
     for(int i = 0;i<pBreite;i++){
      for(int j = 0;j<pHoehe;j++){
        if(colSimil(pic[i][j],colFront))
          posFront.set(i,j);
        else if(colSimil(pic[i][j],colBack)){
          posBack.set(i,j);
        }else if(colSimil(pic[i][j],colFood)){
          posFood.set(i,j);
        }
      }
     }
     //Vektoren werden in mm gebracht
     posFood.mult(aBreite/pBreite);
     posBack.mult(aBreite/pBreite);
     posFront.mult(aBreite/pBreite);
     
     printPos();
   }
   public void drawPos(){
    float verh = pBreite/aBreite;
    fill(color(255,255,255));
    ellipse(posFood.x*verh,posFood.y*verh,5,5);
    ellipse(posFront.x*verh,posFront.y*verh,5,5);
    ellipse(posBack.x*verh,posBack.y*verh,5,5);
   }
   private void printPos(){
     println("Front:"+ posFront);
     println("Back: " +posBack);
     println("Food: " +posFood);
   }
   private void printDegDist(){
     println("dist: " +dist);
     println("deg: " +deg); 
   }
   //berechnet aus den aktuellen Positionsvektoren den zu drehenden Winkel, und die zu fahrende Distanz
   private void updateDegDist(){
    PVector rV  = PVector.sub(posFront,posBack); //Vektor von PosBack zu posFront
    PVector mp = PVector.add(posBack,PVector.div(rV,2)); //ungefährer Mittelpunkt von Schlange
    PVector mpToFood = PVector.sub(posFood,mp);
    this.dist = mpToFood.mag();
    float det = det(rV,mpToFood);
    println("det: "+det);
    float angle = degrees(PVector.angleBetween(rV,mpToFood));
    if(det>0){
      this.deg = angle;
    }else{
      this.deg = 360 - angle;
    }
    printDegDist();

   }
   //gibt Determinante zweier R2 vektoren zurück
   private float det(PVector a, PVector b){
     return (a.x*b.y) - (a.y*b.x);
   }
   //gibt zurück ob sich die Farben ausreichend ähneln
   private boolean colSimil(color a,color b){
     float allDif = 50;
     return colDif(a,b) <= allDif;
   }
   //gibt den insgesamten Unterschied der Farbwerte
   private float colDif(color a, color b){
     return abs(red(a)-red(b))+ abs(green(a)-green(b)) + abs(blue(a)-blue(b));
   }
   //aktualisiert Array "pic"
   private void updatePic(){
     if(cam.available()){
       cam.read();
     }
     cam.loadPixels();
     for(int i = 0;i< pBreite;i++){
      for(int j = 0;j<pHoehe;j++){
       pic[i][j] =  cam.pixels[pBreite*j+i];
      }
     }
   }
   //überprüft, ob das Verhältnis der übergebenen Breiten und Höhen ausreichend übereinstimmt
   private void VerhCheck(){
      float aVerh = aBreite/aHoehe ;
      float pVerh = pBreite/(float)pHoehe;
      float verhDif = abs(aVerh - pVerh);
      if(verhDif > 0.05){
        println("Die Verhältnisse stimmen nicht");
        println(aVerh +", "+pVerh);
        println("Unterschied: "+verhDif);
      }
   }

   //gibt das aktuelle Bild der Kamera aus
   public void camPic(){
    if(cam.available()){
     cam.read(); 
    }
    image(cam,0,0);
   }
   //gibt die einzelnen Farbwerte einer Farbe in der Konsole aus
   private void printCol(color col){
     println("Rot: "+red(col)+ ", Blau: "+blue(col)+", Gruen: "+green(col)); 
   }
   /*    vorerst nicht benötigter Code: 
   
   //gibt den PixelArray aus (für Tests),schneller ist camPic benutzen
   private void displayPic(){
     for(int i = 0;i< pBreite;i++){
      for(int j = 0;j<pHoehe;j++){
       stroke(pic[i][j]);
       point(i,j);
      }
     }
   }*/
}