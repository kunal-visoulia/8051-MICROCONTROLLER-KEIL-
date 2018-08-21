#include<reg51.h>


sbit LED_FAULT = P1^6;
sbit LED_CPU=P1^7;
sbit buzzer=P1^5;

void delay(){
LED_FAULT=~LED_FAULT;
LED_CPU=~LED_CPU;
}
void main(){
buzzer=0;
LED_FAULT=1;
LED_CPU=0;
while(1){
LED_FAULT=~LED_FAULT;
LED_CPU=~LED_CPU;
delay();
LED_FAULT=~LED_FAULT;
LED_CPU=~LED_CPU;
delay();

}
}
