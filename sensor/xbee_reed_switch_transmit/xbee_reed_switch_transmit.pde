#include <SoftwareSerial.h>

const int inPin = 8;   // choose the input pin (for a reed switch)
const int pingPin = 7; //ping sensor
int val = 0;     // variable for reading the pin status
SoftwareSerial XBeeSerial(3,4);

void setup() {
  pinMode(inPin, INPUT);    // declare pushbutton as input
  Serial.begin(9600);
  XBeeSerial.begin(9600);
}

void loop(){
  long duration, inches, cm;
  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);
  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  inches = microsecondsToInches(duration);
  cm = microsecondsToCentimeters(duration);
  if (inches > 24){
    Serial.print("PG");
    XBeeSerial.print("PG");
  }else{
    Serial.print("PR");
    XBeeSerial.print("PR");
  }
  
  val = digitalRead(inPin);  // read input value of 
  if (val == HIGH) {
    Serial.print("SG");
    XBeeSerial.print("SG");
  } else {
    Serial.print("SR");
    XBeeSerial.print("SR");
  }
  delay(5000);
}


long microsecondsToInches(long microseconds)
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
