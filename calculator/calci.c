#include<reg51.h>

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
 int  x=0;
 int w,z,o,s;
 int c,d,e,f;
 unsigned char a,b;
 unsigned char y;
key_enb=1;
p:
lcddata('0');
lcdcmd(0x06);
lcddata('0');
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

MSDelay(20);//debounce of 20ms

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
b='0';
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
lcddata('-');
w=x;
o=4;
}
else if(y==0xEF){lcdcmd(0x80);lcdcmd(0x01);
lcddata('/');w=x;
o=3;
}
else if(y==0xF7){lcdcmd(0x80);lcdcmd(0x01);
//output (delete)
buzzer=1;
buzzer=0;
goto p;
}
else if(y==0xFB){lcdcmd(0x80);lcdcmd(0x01);
lcddata('*');
o=2;
w=x;
}
else if(y==0xFD){lcdcmd(0x80);lcdcmd(0x01);
lcddata('+');
w=x;
o=1;
}
else if(y==0xFE){lcdcmd(0x80);lcdcmd(0x01);
z=x;
if(o==1){
s=w+z;
if(s<10)
{a='0';
b=s+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);}
else if(s<100) {
b=s%10;
b=b+0x30;
a=s/10;
a=a+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}
else if(s<1000){
c=s%10;
d=s%100;
d=d-c;
d=d/10;
e=s/100;
a=e+0x30;
lcddata(a);
a=d+0x30;
lcddata(a);
a=c+0x30;
lcddata(a);
}

}
else if(o==2){
s=w*z;
if(s<10)
{a='0';
b=s+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);}

else if(s<100) {
b=s%10;
b=b+0x30;
a=s/10;
a=a+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}
else if(s<1000){
c=s%10;
d=s%100;
d=d-c;
d=d/10;
e=s/100;
a=e+0x30;
lcddata(a);
a=d+0x30;
lcddata(a);
a=c+0x30;
lcddata(a);

}
else if(s<10000){
c=s%10;
d=s%100;
d=d-c;
d=d/10;
s=s/100;
e=s%10;
f=s/10;
a=f+0x30;
lcddata(a);
a=e+0x30;
lcddata(a);
a=d+0x30;
lcddata(a);
a=c+0x30;
lcddata(a);

}


}
else if(o==3){
s=w/z;
if(s<10)
{a='0';
b=s+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);}

else if(s<100) {
b=s%10;
b=b+0x30;
a=s/10;
a=a+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}

}
else if(o==4){
s=w-z;
if(s<0){
s=s*(-1);
a=s+0x30;
lcddata('-');
lcdcmd(0x06);
lcddata(a);
}
else if(s<10)
{a='0';
b=s+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);}

else if(s<100) {
b=s%10;
b=b+0x30;
a=s/10;
a=a+0x30;
lcddata(a);
lcdcmd(0x06);
lcddata(b);
}
}

}}
goto m;
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



