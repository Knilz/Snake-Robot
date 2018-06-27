#include <Stepper.h>

const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution

Stepper myStepper1(stepsPerRevolution, 10, 11);
Stepper myStepper2(stepsPerRevolution, 8, 9);

const float radiusFromWheel = 0.044;
const float oneRevolution = 2 * M_PI * 0.044; //-> one revolution is 0.28 meters
const float radiusFromRoboter = 0.0825;

void setup() {
  // set the speed at 60 rpm:
  myStepper1.setSpeed(60);
  myStepper2.setSpeed(60);
  Serial.begin(9600);

  turn(307); //in degree
  Move(685); //in mm
}

void loop() {

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

