#include <Stepper.h>
int empfangeneDatenZahl =0;

const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution

Stepper myStepper1(stepsPerRevolution, 10, 11);
Stepper myStepper2(stepsPerRevolution, 8, 9);

const float radiusFromWheel = 0.044;
const float oneRevolution = 2 * M_PI * 0.044; //-> one revolution is 0.28 meters
const float radiusFromRoboter = 0.0825;

float winkel = 0;
float distance = 0;

void setup() {
  // set the speed at 60 rpm:
  myStepper1.setSpeed(60);
  myStepper2.setSpeed(60);
 

  Serial.begin(9600);
  
  //Kontakt zum arduino aufbauen
  while (Serial.available() <= 0) {
    Serial.println("A");   // send a capital A
    delay(300);
  }
}

void loop() {
  
  
  //while(winkel==0||distance==0){
  
  //solange nicht beide werte empfangen wurden, weiter  daten empfangen
  while(empfangenedatenZahl !=2){
    receiveData();
  }
  turn(winkel);
  Move(distance);
  delay(2000);
  
  Serial.println("winkel:" +(String)winkel+ "dist:"+(String)distance);
 
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
    int inByte = Serial.read(); // ...dann lies das erste Byte und speichere es in der Variable inByte
    switch (inByte) {           // und nimm den Wert, der übertragen wurde, genauer unter die Lupe.
    case 'w':                   // wenn dieser das Zeichen 'r' für 'rechts' ist...
      {
       winkel= Serial.parseFloat();
       // dann lies erstmal eine Zahl ein (wenn irgendetwas anders kam, ist das Ergebnis 0 )
       empfangeneDatenZahl ++;
       
      break;                    // höre hier auf.
      }
    case 'd':                   // ..links genauso:
      {
      distance =Serial.parseFloat(); 
      empfangeneDatenZahl++;// dann lies erstmal eine Zahl ein (wenn irgendetwas anders kam, ist das Ergebnis 0 )
      
      break;                    // höre hier auf.
      }
    default: // bei uns unbekannten Kommandos machen wir einfach garnichts...
      break;

    
    }
  }
  
  
}


