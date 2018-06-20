import processing.video.*;

Capture cam;
Arena feld;

void setup(){
  size(640, 480);
  String[] cameras = Capture.list();
  /*
  if(cameras.length == 0 ){
    println("There are no cameras available for capture. ");
    exit();
  }else {
    println("Available cameras: ");
    for(int i = 0;i<cameras.length; i++){
      println(i + cameras[i]);
    }
  }*/
  cam = new Capture(this, cameras[0]);
  feld = new Arena(cam,640,480,640,480); 
}

void draw(){
  feld.update();
  feld.camPic();
  fill(color(0,0,0));
  ellipse(640/2,480/2,5,5);
}