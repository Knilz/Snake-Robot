import processing.serial.*;
import processing.video.*;

Capture cam;
Arena feld;
 Serial myPort;  //the Serial port object
 String val;//input variable
boolean angeschaltet = true;//wenn false werden keine neuen daten versendet und der Roboter bleibt stehen

void setup() {
 

  size(640, 480);
  String[] cameras = Capture.list();
  /*for(int i = 0; i<cameras.length;i++){
   println(cameras[i]); 
  }*/
  cam = new Capture(this, cameras[1]);
  println("verwendete Kamera: " +cameras[0]);
  feld = new Arena(cam,640,480,1040,760); 
  String[] serials = Serial.list();
  for(int i = 0; i<serials.length;i++){
   println(serials[i]); 
  }
  myPort = new Serial(this, Serial.list()[0], 9600);
 
    
 
}
void draw() {
  feld.allesWasInDrawSoll();//zeichnet was die kamera sieht auf den canvas
  if(angeschaltet){
  //lese string vom arduino ein
    String val = myPort.readStringUntil('\n');//lese Serialport ein

    if (val != null){    //wenn ein String vomArduino angekommen ist....
      
      val = trim(val);
      println(val);//gebe aus was der arduino gesendet hat
      myPort.clear();//löscht was der Arduino gesendet hat aus dem serialport
      feld.update();//aktualisiert die Position vom Roboter, sucht nach Kugeln etc.
     
      sendToArduino(feld.deg,feld.dist); //versendet die in update ermittelten Werte (Winkel, Distanz zur kugel)an den Arduino
    }       
  } 
}



//versende neue Daten in der form "w123.56" "d1234.43" und gibt aus was gesendet wurde
void sendToArduino(float winkel, float distance){
  
  
  myPort.write("w"+str(winkel)); 
  println("Winkel gesendet");//
  myPort.write("d"+str(distance));
  println("distance gesendet");
  myPort.clear();
}
//um den Roboter zu stoppen und wieder zu starten
void mouseReleased(){
  angeschaltet = !angeschaltet;
}
    
   
