#include <Time.h>

int offCount = 0; 
time_t start;
int touchCount = 0;

int COUNT_MAX = 300;

void setup() {
  Serial.begin(9600);
  pinMode(4, INPUT_PULLUP);
  start = now();
}


void loop() {
  if (digitalRead(4) == 0 && offCount >= COUNT_MAX) {
    int t = now();
    touchCount++;
    int totalTime = t - start;
    Serial.println(t);
//    Serial.print('New touch: '); 
//    Serial.println(t);
//    Serial.print('Bubbles per minute: ');
//    Serial.println((float)touchCount / totalTime); 
    offCount = 0;
  } else if (digitalRead(4) == 1) {
    if (offCount < COUNT_MAX)
      offCount++;
  }
}
