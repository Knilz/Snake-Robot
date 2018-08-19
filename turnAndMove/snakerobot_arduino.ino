#include <Stepper.h>


const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution
int empfangeneDatenZahl = 0;
Stepper myStepper1(stepsPerRevolution, 10, 11);
Stepper myStepper2(stepsPerRevolution, 8, 9);

const float radiusFromWheel = 0.044;
const float oneRevolution = 2 * M_PI * 0.044; //-> one revolution is 0.28 meters
const float radiusFromRoboter = 0.0825;

float winkel = 0;//speichert später den übermittelten Winkel
float distance = 0;//speichert später die übermittelte Distanz

void setup() {
  // set the speed at 60 rpm:
  myStepper1.setSpeed(60);
  myStepper2.setSpeed(60);
 

  Serial.begin(9600);
  
  //Kontakt zum arduino aufbauen
  while (Serial.available() <= 0) {
    Serial.println("A");   // sendet den Buchstaben "A" bis eine Verbindung zu Processing aufgestellt wurde
    delay(300);
  }
}

void loop() {
  
  
  
  
  //solange nicht beide werte empfangen wurden, weiter  daten empfangen
  while(empfangeneDatenZahl !=2){
    receiveData();
  }
  turn(winkel);
  Move(distance);
  delay(2000);
  
  Serial.println("winkel: " +(String)winkel+ " dist: "+(String)distance);//sendet kontroll-string an Processing
 
  //Variabeln für neuen durchgang auf 0 setzten
  winkel=0;
  distance=0;
  empfangeneDatenZahl =0;
  
}

//the degree is clockwise and turn the robot
void turn(float degree) {
  if (180 < degree) {
    //turn the robot against clockwise
    float toCoveredDistance = ((360 - degree) / radiusFromRoboter) * (1 / 2.81); //the factor 2.81 was determined metrologically by Erik
    for (int i = 0; i < toCoveredDistance; i++) {
      myStepper1.step(1);
      myStepper2.step(1);
    }
  } else {
    float toCoveredDistance = (degree / radiusFromRoboter) * (1 / 2.81); //the factor 2.81 was determined metrologically by Erik
    for (int i = 0; i < toCoveredDistance; i++) {
      myStepper1.step(-1);
      myStepper2.step(-1);
    }
  }
}

//distance in milli meters and moves the robot
void Move(float distance) {
  for (int i = 0; i < (distance * 2.9); i++) { //the factor 2.9 was determined metrologically by Erik
    myStepper1.step(-1);
    myStepper2.step(1);
  }
}

void receiveData(){
 
    if(Serial.available() > 0) { // Wenn Daten da sind...
    int inByte = Serial.read(); // erster Byte wird eingelesen
    switch (inByte) {          
    case 'w':   //wenn der string mit w anfängt, handelt es sich um den winkel               
      {
       winkel= Serial.parseFloat();//die nachfolgende Zahl wird aus der schnittstelle gelesen und in winkel gespeichert
       
       empfangeneDatenZahl ++;
       
      break;                  
      }
    case 'd':                   // wenn der string mit d anfängt, ist die zahl danach die distanz
      {
      distance =Serial.parseFloat(); 
      empfangeneDatenZahl++;// 
      
      break;                   
      }
    default: // bei anderen strings passiert nichts
      break;

    
    }
  }
  
  
}


