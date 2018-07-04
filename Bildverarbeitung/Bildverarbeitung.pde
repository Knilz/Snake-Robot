import processing.video.*;

Capture cam;
Arena feld;

void setup(){
  size(640, 480);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  println("verwendete Kamera: " +cameras[0]);
  feld = new Arena(cam,640,480,1040,760); 
}
void draw(){
  feld.allesWasInDrawSoll();
}
void mouseReleased(){
  //feld.update();
  feld.printCol(feld.avgColAt(mouseX,mouseY));
}