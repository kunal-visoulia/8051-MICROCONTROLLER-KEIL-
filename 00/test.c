#include<reg51.h>

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




void main(){
char c='a';
buzzer=0;
lcdcmd(0x38);
lcdcmd(0x0C);
lcdcmd(0x01);

lcdcmd(0x80);
lcddata('a');
lcdcmd(0x06);
c=9+0x30;
lcddata(c);
while(1);
}
