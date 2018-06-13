class Arena{
  private int pBreite;  //Pixelzahl breite
  private int pHoehe;   //Pixelzahl hoehe
  private float aBreite;  //Arenabreite in mm
  private float aHoehe;   //Arenahoehe in mm
  private Capture cam;    //Kamera
  private color[][] pic;     
  
  public PVector food;   //Position of the MagnetBall to be eaten next
  public PVector sHead;  //current Position of the Snake
  public PVector sBack;  //current direction the snake looks at
  
  private color cHint;  //Farbe des Hintergrundes
  private color cKopf;  //Farbe des Punktes vorne an der Schlange
  private color cEnde;  //Farbe des Punktes hinten an der Schlange
  private color cFood;  //Farbe der Magnetkugeln
  
  
  //einzige Konstruktor 
  public Arena(Capture cam,int pBreite, int pHoehe, float aBreite,float aHoehe){
      this.cam = cam;
      this.cam.start();
      
      this.pBreite = pBreite;
      this.pHoehe = pHoehe;
      this.aBreite = aBreite;
      this.aHoehe = aHoehe;
      VerhCheck();
      
      food = new PVector(0,0);
      sHead = new PVector(0,0);
      sBack = new PVector(0,0);
      
      pic = new color[pBreite][pHoehe];
      
      cHint = color(255,255,255); //weiß
      cKopf = color(255,0,0);     //rot
      cEnde = color(0,255,0);     //grün  
      cFood = color(0,0,255);       //blau
  }
   //aktualisiert die 3 Vektoren 
   public void update(){
     updatePic();
     displayPic();
     //updatePos();
     printCol(pic[320][240]);
   }
   //updatet die Positionen von Kopf,Ende und Food
   private void updatePos(){
     for(int i = 0;i<pBreite;i++){
      for(int j = 0;j<pHoehe;j++){
        if(colSimil(pic[i][j],cKopf))
          sHead.set(i,j);
        else if(colSimil(pic[i][j],cEnde)){
          sBack.set(i,j);
        }else if(colSimil(pic[i][j],cFood)){
          food.set(i,j);
        }
      }
     }
     println("Kopf:"+ sHead);
     println("Ende: " +sBack);
     println("Food: " +food);
   }
   private boolean colSimil(color a,color b){
     float alldif = 100;
     return(abs(red(a)-red(b))< alldif && abs(green(a)-green(b))< alldif && abs(blue(a)-blue(b))< alldif);
   }
   //aktualisiert den zweiDimensionalen PixelArray
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
   //überprüft, ob das Verhältnis der übergebenen Breiten und Höhen nahezu übereinstimmt
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