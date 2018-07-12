import processing.video.*;

Capture cam;
Arena feld;

void setup(){
  size(640, 480);
  String[] cameras = Capture.list();
  /*
  for(int i = 0;i<cameras.length;i++){         //um beim Einrichten herauszufinden, welche Kamera zu nehmen ist
    println(i + ": " +cameras[i]);
  }
  */
  cam = new Capture(this, cameras[0]);
  println("verwendete Kamera: " +cameras[0]);
  feld = new Arena(cam,640,480,1040,760); 
}
void draw(){
  feld.allesWasInDrawSoll(); 
  feld.update();
}
void mouseReleased(){
  feld.printCol(feld.avgColAt(mouseX,mouseY));
}
