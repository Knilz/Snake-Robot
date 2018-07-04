class Arena{
  private int pBreite;  //Pixelanzahl in Breite
  private int pHoehe;   //Pixelanzahl in Hoehe
  private float aBreite;  //Arenabreite in mm
  private float aHoehe;   //Arenahoehe in mm
  
  private Capture cam;    //Kamera
  
  public color[][] pic;   //2-dimensionaler Array von Farben aus Kamerabild
  
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
     
      initPos();
      
      pic = new color[pBreite][pHoehe];
      
      //initCols();
      colHint = color(122,122,122);
      colFront = color(163,169,62); //gelb
      colBack = color(130,23,1);   //rot
      colFood = color(25,100,180); //blau
  }
  //wird im Hauptprogramm einmal in draw aufgerufen
  public void allesWasInDrawSoll(){
    camPic();
    fill(color(0,0,0));
    ellipse(320,240,5,5);
    drawPos();
    ellipse(mouseX,mouseY,5,5);
    update();  }
  
   //aktualisiert die Positionen 
   public void update(){
     updatePic();
     updatePos();
     updateDegDist();
     camPic();
     drawPos();
   }
   //setzt alle Positionen auf 0
   private void initPos(){
      posFood = new PVector(0,0);
      posFront = new PVector(0,0);
      posBack = new PVector(0,0); 
   }
   public void printColAtPos(int x,int y){
      printCol(pic[x][y]);
   }
   //gibt die durchschnittliche Farbe an Stelle x,y aus
   private color avgColAt(int x, int y){
    color[] colAr = new color[20];
    for(int i = 0; i<20;i++){
      updatePic();
      colAr[i] = feld.pic[x][y];
    }
    return avgCol(colAr);
   }
   //gibt die Durchschnittsfarbe zurück
   public color avgCol(color[] colAr){
     float sumR = 0;
     float sumG = 0;
     float sumB = 0;
     int arL = colAr.length;
    for(int i = 0; i<arL;i++){
      sumR += red(colAr[i]);
      sumG += green(colAr[i]);
      sumB += blue(colAr[i]);
    }
    return color(sumR/arL,sumG/arL,sumB/arL);
   }
   //aktualisiert Positionen von Food,Front,Back anhand von Array pic
   private void updatePos(){
     initPos();
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
    int r = 10; //radius der Punkte
    ellipse(posFood.x*verh,posFood.y*verh,r,r);
    ellipse(posFront.x*verh,posFront.y*verh,r,r);
    ellipse(posBack.x*verh,posBack.y*verh,r,r);
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
     float rDif = red(a)/red(b);
     float gDif = green(a)/green(b);
     float bDif = blue(a)/blue(b);
     
     float absR = abs(rDif);
     float absG = abs(gDif);
     float absB = abs(bDif);
     return colSimil(absR,absG,absB);
   }
   //kriegt r,g und b Abstand von zwei Farben übergeben und überprüft, ob 
   private boolean colSimil(float r, float g,float b){
     float tmDif = 30;           //total maximum Difference
     float smDif = 15;           //single maximum Difference
     return (r+g+b <= tmDif && r<smDif && g<smDif && b<smDif);
   }
   private boolean colSame(float r,float g,float b){
     float lmDif = 30;           //light maximum difference
     return floatSimil(new float[]{r,g,b},10);
   }
   //gibt zurück ob sich in einem float-Array alle einzelnen Einträge paarweise nicht zu stark unterscheiden, 
   private boolean floatSimil(float[] flAr, float allDif){
    for(int i = 0; i<flAr.length;i++){
     for(int j = i; j< flAr.length;j++){
        if(abs(flAr[i]-flAr[j])>allDif){
           return false; 
        }
     }
    }
    return true;
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
     println("Rot: "+red(col)+ ", Gruen: "+green(col) + ", Blau: "+blue(col)); 
   }
   /*    vorerst nicht benötigter Code: 
   
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