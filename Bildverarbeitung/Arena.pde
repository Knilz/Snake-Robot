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
      
      initCols();
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
     displayPic();
     //updatePos();
     printCol(pic[320][240]);
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
     println("Front:"+ posFront);
     println("Back: " +posBack);
     println("Food: " +posFood);
   }
   private boolean colSimil(color a,color b){
     float alldif = 100;
     return(abs(red(a)-red(b))< alldif && abs(green(a)-green(b))< alldif && abs(blue(a)-blue(b))< alldif);
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
   //gibt den PixelArray aus (für Tests)
   private void displayPic(){
     for(int i = 0;i< pBreite;i++){
      for(int j = 0;j<pHoehe;j++){
       stroke(pic[i][j]);
       point(i,j);
      }
     }
   }
   private void printCol(color col){
     println("Rot: "+red(col)+ ", Blau: "+blue(col)+", Gruen: "+green(col)); 
   }
}