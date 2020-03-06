//CARRY SELECT ADDER
module fulladd(a,b,cin,cout,sum);
    input a,b,cin;
    output cout,sum;
    wire y,y1,y2;
    xor(y,a,b);
    xor(sum,y,cin);
    and(y1,a,b);
    and(y2,cin,y);
    or(cout,y2,y1);
endmodule

module muxx2(a,b,s,out);
    input a,b,s;
    output out;
    reg out;
    always@(*)
    begin
    if(s==0)
    out=a;
    else
    out=b;
    end
endmodule

module cla1(a,b,cin,cout,sum);
    input [9:0]a,b;
    input cin;
    output cout;
    output [9:0]sum;
    Wire y,y1,y2,y3,y4,y5,sum1,sum2,sum3,sum4,c1,c2,
    wire c7,c8,c9;
    
    fulladd a1(a[0],b[0],cin,y,sum[0]);
    fulladd a2(a[1],b[1],0,y1,sum1);
    fulladd a3(a[1],b[1],1,y2,sum2);
    fulladd a4(a[2],b[2],0,y3,sum3);
    fulladd a5(a[2],b[2],1,y4,sum4);
    muxx2 m1(sum1,sum2,y,sum[1]);
    muxx2 m2(y1,y2,y,c1);
    muxx2 m3(sum3,sum4,c1,sum[2]);
    muxx2 m4(y3,y4,c1,cout)
endmodule

//BOOTH MULTIPLIER
module boo(mul,A,B);
    input [3:0]A,B; //A=multiplicand and B=multiplier
    output [9:0]mul;
    reg [3:0]C=4'd0;
    reg [9:0]mul;
    reg q1=1'd0;
    reg [8:0]Y;
    reg [3:0]A1;
    reg [3:0]B1;
    reg s1=2'd0;
    integer i;
    always@(*)
    begin
    C=4'd0;
    B1=B;
    Y={C,B1,q1};
    for(i=0;i<4;i=i+1)
    begin
    if((B1[0]==0 && q1==0) || (B1[0]==1 && q1==1))
    begin
    Y=Y >> 1;
    Y[8]=Y[7];
    C=Y[8:5];
    B1=Y[4:1];
    q1=Y[0];
    end
    else if(B1[0]==1 && q1==0)
    begin
    A1=-A;
    C=C+A1;
    Y={C,B1,q1};
    Y=Y >> 1;
    Y[8]=Y[7];
    
    C=Y[8:5];
    B1=Y[4:1];
    q1=Y[0];
    end
    else
    begin
    C=C+A;
    Y={C,B1,q1};
    Y=Y >> 1;
    Y[8]=Y[7];
    C=Y[8:5];
    B1=Y[4:1];
    q1=Y[0];
    end
    end
    mul={s1,C,B1};
    end
endmodule

//MAC UNIT
module macfinal(A,B,C,D,rst,clk,acc);

    input [3:0]A,B,C,D;
    input clk;
    input rst;
    output reg[9:0]acc;
    wire [9:0]mul,mul1;
    wire [9:0]sum,sum1;
    wire cout,c1;
    
    boo f1(mul,A,B);
    boo f2(mul1,C,D);
    cla1 x1(mul,mul1,0,cout,sum1);
    cla1 x2(sum1,acc,cout,c1,sum);
    
    always@(posedge clk)
    begin
        if(rst)
        begin
            acc<=10'd0;
        end
        else
        begin
            acc<=sum;
        end
    end
endmodule

