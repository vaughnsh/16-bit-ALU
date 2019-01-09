
`timescale 1ns/1ns // set timescale
module fulladder(a,b,c,s, cout) ; // full adder circuit
input a , b, c ;  //declare inputs
output s, cout;  // declare outputs
 wire w1, w2, w3, w4;  // decalre wires
 xor #1     
 g1(w1, a, b), // xor a and b
 g2(s, w1, c);  // xor w1 and c
 and #1
 g3(w2, c, b), // c&b
 g4(w3, c, a), // c&a
 g5(w4, a, b); // a&b
 or #1
 g6(cout, w2, w3, w4); // w2|w3
 endmodule 
 
 module twotoonemux(a,b,s, f); // 2 to 1 mux circuit
 input a, b, s;  // declare inputs
 output f; // declare outputs
 wire w1, w2, w3;// declare wires
 not #1
 g1(w1, s); // ~s 
 and #1
 g2(w2, w1, a), // w1 & a
 g3(w3, s, b); // s&b
 or #1
 g4(f, w2, w3); // w2 | w3
 endmodule
 module fourtoonemux(a, b,c,d, s0, s1, f); // 4 to 1 mux circuit
 input a,b,c,d,s0,s1; // declare inputs
 output f; // declare outputs
wire w1,w2; // declare wires
twotoonemux m1(a,b,s1,w1); // uses 3 2 to 1 muxs using the output of the of the first 2 as inputs for the third mux
twotoonemux m2(c,d,s1,w2);
twotoonemux m3(w1,w2, s0,f);
endmodule
module bitalu(a,b,less,sub,cin,op0,op1, cout, out, set); // 1 bit alu circuit
input a,b,less,sub, cin, op0, op1; // decalre inputs
output cout, out, set; // declare outputs
wire w1, w2, w3, w4, w5, w6; // declare wires
and #1
g1(w1,a,b); // a&b
or #1
g2(w2,a,b); // a|b
not #1
g3(w3, b); //~b
twotoonemux m1(b,w3,sub,w4);    //two to one mux with b and w3 as inputs and sub as selector
fulladder f0(a,w4,cin,w5,cout); // full adder with a, w4, and cin as inputs
assign set = w5; // out of fulladder is set
fourtoonemux m2(w1,w2,w5,less,op0,op1, out); // 4 to 1 mux with w1, w2,w5, less as inputs and op0, op1 as selectors
endmodule

module alu(a,b,sub,op0,op1, out); //16 bit alu circuit
input [15:0] a,b;  // declare inputs
input op0,op1;
input sub;
output [15:0] out; //declare outputs
wire [16:0] w;// declare wires
wire se; // delcare set less wire
wire [14:0] c; // declare cin and cout wires
bitalu b1 (a[0],b[0],se,sub,sub,op0,op1,c[0], out[0], w[0]); // string together 16 1 bit alus with sub as cin for first and wire connecting the set of the last alu to the less of the first
bitalu b2(a[1],b[1],0,sub,c[0],op0,op1,c[1], out[1], w[1]);
bitalu b3(a[2],b[2],0,sub,c[1],op0,op1,c[2], out[2], w[2]);
bitalu b4(a[3],b[3],0,sub,c[2],op0,op1,c[3], out[3], w[3]);
bitalu b5(a[4],b[4],0,sub,c[3],op0,op1,c[4], out[4], w[4]);
bitalu b6(a[5],b[5],0,sub,c[4],op0,op1,c[5], out[5], w[5]);
bitalu b7(a[6],b[6],0,sub,c[5],op0,op1,c[6], out[6], w[6]);
bitalu b8(a[7],b[7],0,sub,c[6],op0,op1,c[7], out[7], w[7]);
bitalu b9(a[8],b[8],0,sub,c[7],op0,op1,c[8], out[8], w[8]);
bitalu b10(a[9],b[9],0,sub,c[8],op0,op1,c[9], out[9], w[9]);
bitalu b11(a[10],b[10],0,sub,c[9],op0,op1,c[10], out[10], w[10]);
bitalu b12(a[11],b[11],0,sub,c[10],op0,op1,c[11], out[11], w[11]);
bitalu b13(a[12],b[12],0,sub,c[11],op0,op1,c[12], out[12], w[12]);
bitalu b14(a[13],b[13],0,sub,c[12],op0,op1,c[13], out[13], w[13]);
bitalu b15(a[14],b[14],0,sub,c[13],op0,op1,c[14], out[14], w[14]);
bitalu b16(a[15],b[15],0,sub,c[14],op0,op1,w[15], out[15], se);
endmodule
module testbench(); //testbench creation
wire  [15:0] a,b;
wire sub , op0,op1;
wire [15:0] out;
testalu test(a,b,sub,op0,op1,out);  // connectinig alu to testbench alu
alu al(a,b,sub, op0, op1, out); 
endmodule

module testalu(a,b,sub,op0,op1,out); //outputs for testbench
output sub; // declare sub as output
input [15:0] out; // declare inputs
output [15:0] a,b; // declare outputs
output op0, op1;  // declare as output
reg op0, op1; //declare registers
reg [15:0] a,b;
reg sub;
initial
 begin
 $monitor($time, "a=%b, b=%b, sub=%b,op0=%b,op1=%b,out=%b",a,b,sub,op0,op1,out);
 $display($time, "a=%b, b=%b, sub=%b,op0=%b,op1=%b,out=%b",a,b,sub,op0,op1,out); 
  #20 a=4; b=4; sub =0; op0=1; op1=0; 
  #20 a=2; b=4; sub =0; op0=1; op1=0;  //first check delay on 2+4
  #20 a=5; b=7; sub =0; op0=0; op1=0; 
  #20 a=90; b=4; sub =0; op0=0; op1=1; 
  #20 a=2; b=4; sub =0; op0=1; op1=0;  ///Check delay on 2+4 again
    #20 a=5; b=2; sub =1; op0=1; op1=0;  // check delay of 5-2
  #40 a=5; b=7; sub =0; op0=0; op1=0; 
  #20 a=5; b=2; sub =1; op0=1; op1=0;   // check delay of 5-2 again
  #40 a=90; b=4; sub =0; op0=0; op1=1;   
 #20 a=5; b=2; sub =0; op0=0; op1=1;  // check delay of 5|2
  #20 a=5; b=7; sub =0; op0=1; op1=0; 
  #20 a=90; b=4; sub =0; op0=0; op1=1; 
  #20 a=2; b=5; sub =0; op0=1; op1=0; 
  #20 a=5; b=2; sub =0; op0=0; op1=1;  // check delay of 5|2 again
   #20 a=100; b=2; sub =0; op0=1; op1=0; // check delay of 100+2
  #20 a=5; b=7; sub =1; op0=1; op1=1; 
  #20 a=90; b=4; sub =0; op0=0; op1=1; 
  #20 a=2; b=5; sub =0; op0=1; op1=0; 
  #20 a=100; b=2; sub =0; op0=0; op1=1; // check delay of 100+2 again
 #20 a=90; b=4; sub =0; op0=0; op1=1;  //start of slt delay check
 #20 a=30; b=40; sub =1; op0=1; op1=1; // check 30<40 delay
  #40 a=5; b=7; sub =0; op0=0; op1=0; 
  #20 a=90; b=4; sub =0; op0=0; op1=1; 
  #20 a=20; b=10; sub =1; op0=1; op1=0; 
  #20 a=30; b=40; sub =1; op0=1; op1=1; // check 30 <40 delay again
  
  
 #20 // Required for iverilog to show final values
 $display($time,,,, "a=%b, b=%b, sub=%b, op0=%b, op1=%b, out=%b",a,b,sub,op0,op1,out);
 end
endmodule 