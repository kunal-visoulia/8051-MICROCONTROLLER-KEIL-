#include <reg51.h>

sbit key_enb=P1^3;
sfr ldata=0x80;
sbit rs=P1^0;
sbit rw=P1^1;
sbit en=P1^2;
sbit busy=P0^7;
sbit buzzer=P1^5;

void MSDelay(unsigned int value){
unsigned int i,j;
for(i=0;i<value;i++)
for(j=0;j<1275;j++);
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

void function(){
unsigned char y;
key_enb=1;







m:
P0=0xFF;
MSDelay(1);

key_enb=0;
MSDelay(1);
y=P0;
key_enb=1;
P0=0xFF;
if(y==0xFF)goto m;
else{

buzzer=1;
MSDelay(20);
buzzer=0;
key_enb=0;
y=P0;
key_enb=1;
P0=0xFF;
if(y==0x7F){lcdcmd(0x80);lcdcmd(0x01);
lcddata('U');lcddata('P');
}
else if(y==0xBF){
lcdcmd(0x80);lcdcmd(0x01);
lcddata('D');lcddata('O');lcddata('W');lcddata('N');

}
else if(y==0xDF){lcdcmd(0x80);lcdcmd(0x01);
lcddata('L');lcddata('I');lcddata('S');lcddata('T');

}
else if(y==0xEF){lcdcmd(0x80);lcdcmd(0x01);
lcddata('E');lcddata('N');lcddata('T');lcddata('E');lcddata('R');

}
else if(y==0xF7){lcdcmd(0x80);lcdcmd(0x01);
lcddata('S');lcddata('T');lcddata('A');lcddata('T');lcddata('U');lcddata('S');

}
else if(y==0xFB){lcdcmd(0x80);lcdcmd(0x01);
lcddata('M');lcddata('E');lcddata('N');lcddata('U');

}
else if(y==0xFD){lcdcmd(0x80);lcdcmd(0x01);
lcddata('C');lcddata('A');lcddata('N');lcddata('C');lcddata('E');lcddata('L');

}
else if(y==0xFE){lcdcmd(0x80);lcdcmd(0x01);
lcddata('A');lcddata('C');lcddata('K');

}}goto m;



}

void main(){

buzzer=0;
lcdcmd(0x38);
lcdcmd(0x08);
lcdcmd(0x01);
lcdcmd(0x06);
lcdcmd(0x0C);
function();
}


