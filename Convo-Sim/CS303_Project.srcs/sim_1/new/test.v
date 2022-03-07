`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sabanci University
// Engineer: Mert Ture & Muhammed Orhun Gale
// 
// Create Date: 02.01.2022 14:55:12
// Design Name: 
// Module Name: test
// Project Name: Telephone - Term Project
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test(

    );
    reg clk;
    reg rst;
    reg startCall, answerCall;
    reg endCall;
    reg sendChar;
    reg [7:0] charSent;
    wire [63:0] statusMsg;
    wire [63:0] sentMsg;
    
    telephone uut(clk, rst, startCall, answerCall, endCall, sendChar, charSent, statusMsg, sentMsg);
    
    always #5 clk = ~clk; 
    
    initial begin
        clk = 0;
        rst = 0;
        startCall = 0;
        answerCall = 0;
        endCall = 0;
        sendChar = 0;
        charSent = " ";

        #100;
    
        rst=1; #20; rst=0; #20;
        
        startCall=1; #10 startCall=0; #100;                                                   
        #100
        #10;
        startCall=1; #10 startCall=0;
        #10 endCall=1; #10 endCall=0; #100
            
        startCall=1; #10; startCall=0;            
        #20;                                        
        answerCall=1; #10; answerCall=0;          
        #20;                                        
    
        sendChar=1; charSent="M"; #10; sendChar=0; #10; 
        sendChar=1; charSent="E"; #10; sendChar=0; #10; 
        sendChar=1; charSent="T"; #10; sendChar=0; #10;
        sendChar=1; charSent="A"; #10; sendChar=0; #10;
        sendChar=1; charSent=" "; #10; sendChar=0; #10; 
        sendChar=1; charSent="I"; #10; sendChar=0; #10; 
        sendChar=1; charSent="N"; #10; sendChar=0; #10;
        sendChar=1; charSent="T"; #10; sendChar=0; #10;
        sendChar=1; charSent="E"; #10; sendChar=0; #10; 
        sendChar=1; charSent="R"; #10; sendChar=0; #10;
        sendChar=1; charSent="N"; #10; sendChar=0; #10;
        sendChar=1; charSent=127; #10; sendChar=0; #10;
        #10;
          
        #100;                                           
    
        startCall=1; #10; startCall=0;                              
        #30;                                                      
        answerCall=1; #10; answerCall=0;                           
        #20;                                                       
        sendChar=1; charSent="D"; #10; sendChar=0; #10;
        sendChar=1; charSent="u"; #10; sendChar=0; #10;
        sendChar=1; charSent="k"; #10; sendChar=0; #10;
        sendChar=1; charSent="e"; #10; sendChar=0; #10;
        sendChar=1; charSent=" "; #10; sendChar=0; #10;
        sendChar=1; charSent="o"; #10; sendChar=0; #10;
        sendChar=1; charSent="f"; #10; sendChar=0; #10;
        sendChar=1; charSent=" "; #10; sendChar=0; #10;
        sendChar=1; charSent="S"; #10; sendChar=0; #10;
        sendChar=1; charSent="t"; #10; sendChar=0; #10;
        sendChar=1; charSent="a"; #10; sendChar=0; #10; 
        sendChar=1; charSent="n"; #10; sendChar=0; #10;
        sendChar=1; charSent="f"; #10; sendChar=0; #10;
        sendChar=1; charSent="o"; #10; sendChar=0; #10;
        sendChar=1; charSent="r"; #10; sendChar=0; #10;
        sendChar=1; charSent="d"; #10; sendChar=0; #10;
        #10;
        endCall=1; 
        #10; 
        endCall=0; 
        #10;  
        #50;                                           
    end

endmodule