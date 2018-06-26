#include <Stepper.h>

const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution

Stepper myStepper1(stepsPerRevolution, 10, 11);
Stepper myStepper2(stepsPerRevolution, 8, 9);

const float radiusFromWheel = 0.044;
const float oneRevolution = 2*M_PI*0.044; //-> one revolution is 0.28 meters
const float radiusFromRoboter = 0.0825;

void setup() {
  // set the speed at 60 rpm:
  myStepper1.setSpeed(60);
  myStepper2.setSpeed(60);

  // initialize the serial port:
  Serial.begin(9600);
//  turn(180);
  Move(300); //300mm
}

void loop() {
  // put your main code here, to run repeatedly:
//  turn(180);
}

void turn(float degree){
  float toCoveredDistance = (degree / radiusFromRoboter)*(1/3.0);
  for(int i = 0; i < toCoveredDistance; i++){
    myStepper1.step(1);
    myStepper2.step(-1);
  }
}

//distance in milli meters
void Move(float distance){
  for(int i = 0; i < (distance*3); i++){ //passt ungefähr mit mal drei
    myStepper1.step(1);
    myStepper2.step(1);
  }
}

