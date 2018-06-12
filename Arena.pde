class Arena{
  private final float pBreite;  //Pixelzahl breite
  private final float pHoehe;   //Pixelzahl hoehe
  private final float aBreite;  //Arenabreite in cm
  private final float aHoehe;   //Arenahoehe in cm
  
  public PVector food;   //Position of the MagnetBall to be eaten next
  public PVector sHead;  //current Position of the Snake
  public PVector sBack;  //current direction the snake looks at
   
   
   public Arena(float breite, float hoehe){
      this.breite = breite;
      this.hoehe = hoehe;
   }
   public void update(PImage pic){
     
   }
}