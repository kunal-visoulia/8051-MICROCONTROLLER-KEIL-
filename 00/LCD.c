#include<reg51.h>

sfr ldata=0x80;
sbit rs=P1^0;
sbit rw=P1^1;
sbit en=P1^2;
sbit busy=P0^7;
sbit buzzer=P1^5;
sbit LED_FAULT = P1^6;
sbit LED_CPU=P1^7;
sbit key_enb=P1^3;

void delay(){
unsigned int i;
for(i=0;i<8;i++){
TMOD=0x01;
TH0=0x00;
TL0=0x00;
TR0=1;
while(TF0==0);
TR0=0;
TF0=0;
}}
void lcdcmd(unsigned char);
void lcddata(unsigned char);
void MSDelay(unsigned int);
void lcdready();
void function(){
 int  x=0;
unsigned char a,b;
unsigned char y;
key_enb=1;

p:
if(x<0){
x=99;
b=x%10;
b=b+0x30;
a=x/10;
a=a+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}
if(x>99){
x=0;
a='0';
b=x+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}
if(x<10)
{a='0';
b=x+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);}
m:

P0=0xFF;//make p0 input
MSDelay(1);
key_enb=0;//H-to-L for taking key value
MSDelay(1);
y=P0;//input value
key_enb=1;//high again
P0=0xFF;//ready for input again
if(y==0xFF)goto m;
else{

MSDelay(10);//debounce of 20ms

key_enb=0;
y=P0;
key_enb=1;
P0=0xFF;
if(y==0x7F){lcdcmd(0x80);lcdcmd(0x01);
x++;
if(x<10)
{a='0';
b=x+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);}
else if(x>99){
x=0;
a='0';
b=x+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}
else {
b=x%10;
b=b+0x30;
a=x/10;
a=a+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}
}
else if(y==0xBF){
lcdcmd(0x80);lcdcmd(0x01);
x--;
if(x<0){
x=99;
a='9';
b='9';
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}

else if(x<10)
{a='0';
b=x+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);}

else {
b=x%10;
b=b+0x30;
a=x/10;
a=a+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}
}
else if(y==0xDF){lcdcmd(0x80);lcdcmd(0x01);
goto p;

}
else if(y==0xEF){lcdcmd(0x80);lcdcmd(0x01);
goto p;

}
else if(y==0xF7){lcdcmd(0x80);lcdcmd(0x01);
goto p;

}
else if(y==0xFB){lcdcmd(0x80);lcdcmd(0x01);
goto p;

}
else if(y==0xFD){lcdcmd(0x80);lcdcmd(0x01);
goto p;

}
else if(y==0xFE){lcdcmd(0x80);lcdcmd(0x01);

buzzer=1;
MSDelay(20);
buzzer=0;
x=0;
a='0';
b='0';
lcddata(a);
lcdcmd(0x06);
lcddata(b);
goto m;
}}
goto m;

}
void main(){

buzzer=0;
lcdcmd(0x38);
lcdcmd(0x0C);
lcdcmd(0x01);
lcdcmd(0x06);
lcdcmd(0x80);

LED_FAULT=1;
LED_CPU=0;
lcddata('K');MSDelay(20);lcdcmd(0x18);
lcddata('U');MSDelay(20);lcdcmd(0x18);
lcddata('N');MSDelay(20);lcdcmd(0x18);
lcddata('A');MSDelay(20);lcdcmd(0x18);
lcddata('L');MSDelay(20);lcdcmd(0x18);
lcddata(' ');MSDelay(20);lcdcmd(0x18);
lcddata('V');MSDelay(20);lcdcmd(0x18);
lcddata('I');MSDelay(20);lcdcmd(0x18);lcddata('S');MSDelay(20);lcdcmd(0x18);
lcddata('O');MSDelay(20);lcdcmd(0x18);lcddata('U');MSDelay(20);lcdcmd(0x18);
lcddata('L');MSDelay(20);lcdcmd(0x18);lcddata('I');MSDelay(20);lcdcmd(0x18);lcddata('A');MSDelay(20);lcdcmd(0x18);
lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);
MSDelay(20);
lcdcmd(0xC0);
lcddata('M');MSDelay(20);lcdcmd(0x18);
lcddata('Y');MSDelay(20);lcdcmd(0x18);lcddata(' ');
MSDelay(20);lcdcmd(0x18);lcddata('F');MSDelay(20);lcdcmd(0x18);lcddata('I');MSDelay(20);lcdcmd(0x18);lcddata('R');MSDelay(20);lcdcmd(0x18);lcddata('S');MSDelay(20);lcdcmd(0x18);lcddata('T');MSDelay(20);lcdcmd(0x18);lcddata(' ');MSDelay(20);lcdcmd(0x18);lcddata('L');MSDelay(20);lcdcmd(0x18);lcddata('C');MSDelay(20);lcdcmd(0x18);lcddata('D');MSDelay(20);lcdcmd(0x18);lcddata(' ');MSDelay(20);lcdcmd(0x18);
lcddata('P');MSDelay(20);lcdcmd(0x18);lcddata('R');MSDelay(20);lcdcmd(0x18);lcddata('O');MSDelay(20);lcdcmd(0x18);
lcddata('G');MSDelay(20);lcdcmd(0x18);lcddata('R');
MSDelay(20);lcdcmd(0x18);lcddata('A');MSDelay(20);lcdcmd(0x18);lcddata('M');MSDelay(20);lcdcmd(0x18);
lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);lcdcmd(0x1C);


while(1){unsigned int i;
for(i-0;i<10;i++){
LED_FAULT=~LED_FAULT;
LED_CPU=~LED_CPU;
delay();
LED_FAULT=~LED_FAULT;
LED_CPU=~LED_CPU;
delay();}
buzzer=0;
lcdcmd(0x38);
lcdcmd(0x08);
lcdcmd(0x01);
lcdcmd(0x06);
lcdcmd(0x0C);
function();
}


}

void lcdcmd(unsigned char value){
lcdready();
ldata=value;
rs=0;
rw=0;
en=1;
MSDelay(1);
en=0;
return;
}

void lcddata(unsigned char value){
lcdready();
ldata=value;
rs=1;
rw=0;
en=1;
MSDelay(1);
en=0;
return;
}
void lcdready(){

busy=1;
rs=0;
rw=1;
while(busy==1)
{
en=0;
MSDelay(1);
en=1;
}
return;
}
void MSDelay(unsigned int value){
unsigned int i,j;
for(i=0;i<value;i++)
for(j=0;j<1275;j++);
}
