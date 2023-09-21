#include <SoftwareSerial.h>

SoftwareSerial bt_ser(4, 5); // Connected to RX and TX pins for serial data communication
char c[6];
int i = 0, speed_value = 0, send_value;

#define pwm1 9  // Input 2
#define pwm2 10 // Input 1
boolean motor_dir = 0;

void setup() {
  Serial.begin(9600);
  bt_ser.begin(9600);
  pinMode(pwm1, OUTPUT);
  pinMode(pwm2, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  while (bt_ser.available()) { // When data is transmitted
    if (bt_ser.available() > 0) {
      c[i] = bt_ser.read(); // Reading the string sent from the master device
      Serial.print(c[i]);
      i++;
    }

    if (c[i - 1] == 'N') { // If the button is pressed
      motor_dir = !motor_dir; // Toggle direction variable

      if (motor_dir) { // Setting direction, pwm1 and pwm2 are opposites
        digitalWrite(pwm2, 0);
        digitalWrite(LED_BUILTIN, HIGH);
      } else {
        digitalWrite(pwm1, 0);
        digitalWrite(LED_BUILTIN, LOW);
      }
    }

    if (c[i - 1] == 'S') {
      speed_value = 0;
    } else if (c[i - 1] == '1') {
      speed_value = 70; // Slow Speed
    } else if (c[i - 1] == '2') {
      speed_value = 160; // Medium Speed
    } else if (c[i - 1] == '3') {
      speed_value = 250; // Fast Speed
    }
  }

  // Interpreting speed from the string
  if (motor_dir) { // For a given direction
    analogWrite(pwm1, speed_value);
  } else { // For the opposite direction
    analogWrite(pwm2, speed_value);
  }

  i = 0;
}
