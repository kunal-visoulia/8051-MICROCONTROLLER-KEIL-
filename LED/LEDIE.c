#include<reg51.h>


sbit LED_FAULT = P1^6;
sbit LED_CPU=P1^7;
sbit buzzer=P1^5;

void timer0() interrupt 1{
LED_FAULT=~LED_FAULT;
LED_CPU=~LED_CPU;
}
void main(){
unsigned int i;
buzzer=0;
LED_FAULT=1;
LED_CPU=0;
while(1){
TMOD=0x01;
for(i=0;i<15;i++)
{TMOD=0x01;

TH0=0x00;
TL0=0x00;
TR0=1;
while(TF0==0);
TF0=0;
TR0=0;
}
TMOD=0x01;
TH0=0x00;
TL0=0x00;
TR0=1;
IE=0x82;
}
}