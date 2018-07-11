import processing.serial.*;
import processing.video.*;

Capture cam;
Arena feld;//import the Serial library
 Serial myPort;  //the Serial port object
 String val;//input variable
// we need to check if we've heard from the microcontroller
boolean angeschaltet =true;



void setup() {
 
  //  initialize your serial port and set the baud rate to 9600

  size(640, 480);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  println("verwendete Kamera: " +cameras[0]);
  feld = new Arena(cam,640,480,1040,760);
  String[] serials = Serial.list();
  for(int i = 0;i<serials.length;i++){
    println(serials[i]);
  }
  myPort = new Serial(this, Serial.list()[0], 9600);
 
    
 
}
void draw() {
  feld.allesWasInDrawSoll();//zeichnet was die kamera sieht auf den canvas
  
  if(angeschaltet){
  //lese string vom arduino ein
  String val = myPort.readStringUntil('\n');//lese Serialport ein
  //wenn etwas gesendet wurde....
  if (val != null){
    val = trim(val);
    println(val);//gebe aus was der arduino gesendet hat
    
    
   myPort.clear();//löscht was der Arduino gesendet hat aus dem serialport
   
  feld.update();//aktualisiert die Positions-vektoren vom Roboter, sucht nach Kugeln etc.
  // zugriff auf die eben aktualisierten attribute
   
        float winkel = feld.deg; 
        float distance = feld.dist;
        
        //versende neue Daten in der form "w123.56" "d1234.43" und gibt aus was gesendet
        myPort.write("w"+str(winkel)); 
        println("Winkel gesendet");//send string
        myPort.write("d"+str(distance));
        println("distance gesendet");
        myPort.clear();
        println("warten");
        
        //angeschaltet = false;//für  testfahrten: wenn diese Zeile aktiviert ist, bleibt der Roboter nach dem einsammeln stehen
       
       
  }
        
  }
    else{

      
    }
    
    
  
 
}
void mouseReleased(){
 feld.update();
 //feld.printCol(feld.avgColAt(mouseX,mouseY)); 
}

    
   