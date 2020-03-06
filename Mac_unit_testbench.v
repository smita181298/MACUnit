//TESTBENCH
module theonetv;
    reg [3:0]A,B,C,D;
    reg clk;
    reg rst;
    wire [9:0]acc;
    macfinal m1(A,B,C,D,rst,clk,acc);
    initial
    begin
        clk=1'd0;
        forever #5 clk=~clk;
    end
    initial
    begin
        rst=1;A=4'd5;B=4'd2;C=4'd2;D=4'd1;
        #10 rst=0;
        #10 A=4'd3;B=4'd2;C=4'd5;D=4'd6;
        #10 A=4'D5;B=4'd6;C=4'd1;D=4'd5;
        #10 $stop;
    end
endmodule