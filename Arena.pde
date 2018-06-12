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
  public Arena(Capture cam,int pBreite, int pHoehe, float aHoehe,float aBreite){
      this.cam = cam;
      this.cam.start();
      
      this.pBreite = pBreite;
      this.pHoehe = pHoehe;
      this.aBreite = aBreite;
      this.aHoehe = aHoehe;
      if(abs(aHoehe/aBreite - pHoehe/pBreite)>1)
        println("Die Verhältnisse stimmen nicht");
      
      pic = new color[pBreite][pHoehe];
      
      cHint = color(255,255,255); //weiß
      cKopf = color(255,0,0);     //rot
      cEnde = color(0,255,0);     //grün  
      cFood = color(0,0,0);       //schwarz
  }
   //aktualisiert die 3 Vektoren 
   public void update(){
     updatePic();
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
   //gibt den PixelArray aus
   private void displayPic(){
     for(int i = 0;i< pBreite;i++){
      for(int j = 0;j<pHoehe;j++){
       fill(pic[i][j]);
       point(i,j);
      }
     }
   }
}