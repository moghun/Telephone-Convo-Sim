`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2022 01:12:07
// Design Name: 
// Module Name: telephone
// Project Name: 
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


module telephone (
    input clk, 
    input rst, 
    input startCall, answerCall, 
    input endCall,
    input sendChar,
    input [7:0] charSent, 
    output reg [63:0] statusMsg, 
    output reg [63:0] sentMsg 
    ); 
    
  parameter [2:0]  IDLE = 3'b000;
  parameter [2:0]  BUSY = 3'b001;
  parameter [2:0]  REJECTED = 3'b010;
  parameter [2:0]  RINGING = 3'b011;
  parameter [2:0]  CALL = 3'b100;
  parameter [2:0]  COST = 3'b101;
      



    reg [31:0] cost; 
    reg [7:0] current_state; 
    reg [7:0] next_state; 
    reg [4:0] counter;
    // additional registers 
    always @ (posedge clk or posedge rst) 
        begin 
         // your code goes here 
            if (rst)
                counter <= 0;       
            else
                if (current_state == RINGING | current_state == REJECTED | current_state == COST | current_state == BUSY) begin
                    if (counter == 9 & (current_state == REJECTED | current_state == RINGING))
                        counter <= 0;
                    else if((endCall == 1) & current_state == RINGING)
                        begin
                            counter<= 0;
                        end 
                    // else if(counter == 4 & current_state == COST)
                        // counter <= 0;
                    else if(counter == 9 & current_state == BUSY)
                        counter <= 0;
                    else
                        counter <= counter + 1;
                end
                else
                    counter <= 0;
        end
    
    // sequential part - state transitions 
     always @ (posedge clk or posedge rst) 
       begin 
        // your code goes here 
        if (rst)
           current_state <= IDLE;
       else
           current_state = next_state;          
       end
    // combinational part - next state definitions 
    always @ (*) begin 
        // your code goes here 
        if (rst) 
            next_state = IDLE;
        else
        begin
            case(current_state)
                IDLE: begin
                    if (startCall == 1)
                        next_state = RINGING;
                end
                RINGING: begin
                    if(endCall == 1)
                        next_state = REJECTED;
                    else if (answerCall == 1)
                        next_state = CALL;
                    else if (counter == 9)
                        next_state = BUSY;
                    else
                        next_state = RINGING;
                end
                REJECTED: begin
                    if (counter == 9)
                        next_state = IDLE;
                    else
                        next_state = REJECTED;
                end
                BUSY: begin
                    if (counter == 9)
                       next_state = IDLE;
                    else
                       next_state = BUSY;
                end
                CALL: begin
                    if (endCall == 1)
                        next_state = COST;
                    else if (charSent == 127 && sendChar == 1) begin
                        cost = (cost + 2);
                        next_state = COST;
                        end
                    else
                        next_state = CALL;
                end
                COST: begin
                    if (counter == 4)
                        next_state = IDLE;
                    else
                        next_state = COST;
                end
                default: next_state = IDLE;
            endcase
        end
    end
    // sequential part - control registers 
    always @ (posedge clk or posedge rst) 
    begin 
    // your code goes here 
        if (rst) begin 
                cost <= 0;
                sentMsg[7:0] <= 32;
                sentMsg[15:8] <= 32;
                sentMsg[23:16] <= 32;
                sentMsg[31:24] <= 32;
                sentMsg[39:32] <= 32;
                sentMsg[47:40] <= 32;
                sentMsg[55:48] <= 32;
                sentMsg[63:56] <= 32;
        end
        else if(current_state == COST) begin
                    if (cost[3:0]<= 9 && cost[3:0]>= 0 )
                        sentMsg[7:0] <= cost[3:0] + 48;
                    else sentMsg[7:0] <= cost[3:0] + 55;
                    
                    if (cost[7:4]<= 9 && cost[7:4]>= 0 )
                        sentMsg[15:8] <= cost[7:4] + 48;
                    else sentMsg[15:8] <= cost[7:4] + 55;
                    
                    if (cost[11:8]<= 9 && cost[11:8]>= 0 )
                        sentMsg[23:16] <= cost[11:8] + 48;
                    else sentMsg[23:16] <= cost[11:8] + 55;
                    
                    if (cost[15:12]<= 9 && cost[15:12]>= 0 )
                        sentMsg[31:24] <= cost[15:12] + 48;
                    else sentMsg[31:24] <= cost[15:12] + 55;
                    
                    if (cost[19:16]<= 9 && cost[19:16]>= 0 )
                        sentMsg[39:32] <= cost[19:16] + 48;
                    else sentMsg[39:32] <= cost[19:16] + 55;
                    
                    if (cost[23:20]<= 9 && cost[23:20]>= 0 )
                        sentMsg[47:40] <= cost[23:20] + 48;
                    else sentMsg[47:40] <= cost[23:20] + 55;
                    
                    if (cost[27:24]<= 9 && cost[27:24]>= 0 )
                        sentMsg[55:48] <= cost[27:24] + 48;
                    else sentMsg[55:48] <= cost[27:24] + 55;
                    
                    if (cost[31:28]<= 9 && cost[31:28]>= 0 )
                        sentMsg[63:56] <= cost[31:28] + 48;
                    else sentMsg[63:56] <= cost[31:28] + 55;
                    
        end
    end 
    // sequential part - outputs 
    always @ (posedge clk or posedge rst) 
    begin 
    // your code goes here 
        if (rst) begin
            cost <= 0;
            statusMsg[7:0]<= 32; 
            statusMsg[15:8]<=32;
            statusMsg[23:16]<=32;
            statusMsg[31:24]<=32;
            statusMsg[39:32]<= 69; 
            statusMsg[47:40]<=76;
            statusMsg[55:48]<=68;
            statusMsg[63:56]<=73;
            
            sentMsg[7:0] <= 32;
            sentMsg[15:8] <= 32;
            sentMsg[23:16] <= 32;
            sentMsg[31:24] <= 32;
            sentMsg[39:32] <= 32;
            sentMsg[47:40] <= 32;
            sentMsg[55:48] <= 32;
            sentMsg[63:56] <= 32;
            
        end
        else begin
            case(current_state)
                IDLE: begin
                    cost <= 0;
                    statusMsg[7:0]<= 32;
                    statusMsg[15:8]<=32;
                    statusMsg[23:16]<=32;
                    statusMsg[31:24]<=32;
                    statusMsg[39:32]<= 69;
                    statusMsg[47:40]<=76;
                    statusMsg[55:48]<=68;
                    statusMsg[63:56]<=73;
                    
                    sentMsg[7:0]<= 32; 
                    sentMsg[15:8]<=32;
                    sentMsg[23:16]<=32;
                    sentMsg[31:24]<=32;
                    sentMsg[39:32]<= 32;
                    sentMsg[47:40]<=32;
                    sentMsg[55:48]<=32;
                    sentMsg[63:56]<=32;
                end
                RINGING: begin
                    statusMsg[7:0]<= 32;
                    statusMsg[15:8]<=71;
                    statusMsg[23:16]<=78;
                    statusMsg[31:24]<=73;
                    statusMsg[39:32]<= 71; 
                    statusMsg[47:40]<=78;
                    statusMsg[55:48]<=73;
                    statusMsg[63:56]<=82; 
                end
                REJECTED: begin
                    statusMsg[7:0] <= 68; 
                    statusMsg[15:8]<=69;
                    statusMsg[23:16]<=84;
                    statusMsg[31:24]<=67;
                    statusMsg[39:32]<= 69;
                    statusMsg[47:40]<=74;
                    statusMsg[55:48]<=69;
                    statusMsg[63:56]<=82;
                end
                BUSY: begin
                    statusMsg[7:0]<= 32; 
                    statusMsg[15:8]<=32;
                    statusMsg[23:16]<=32;
                    statusMsg[31:24]<=32;
                    statusMsg[39:32]<= 89; 
                    statusMsg[47:40]<=83;
                    statusMsg[55:48]<=85;
                    statusMsg[63:56]<=66;
                end
                CALL: begin
                    if (sendChar == 1) begin
                        statusMsg[7:0]<= 32; 
                        statusMsg[15:8]<=32;
                        statusMsg[23:16]<=82;
                        statusMsg[31:24]<=69;
                        statusMsg[39:32]<= 76;
                        statusMsg[47:40]<=76;
                        statusMsg[55:48]<=65;
                        statusMsg[63:56]<=67; 
                        
                        if (charSent >= 32 && charSent < 127) begin
                            sentMsg[63:56]<=sentMsg[55:48];
                            sentMsg[55:48]<=sentMsg[47:40];
                            sentMsg[47:40]<=sentMsg[39:32];
                            sentMsg[39:32]<=sentMsg[31:24];
                            sentMsg[31:24]<=sentMsg[23:16];
                            sentMsg[23:16]<=sentMsg[15:8];
                            sentMsg[15:8]<=sentMsg[7:0];
                            sentMsg[7:0]<=charSent;
                            if("0" <= charSent && charSent <= "9") begin 
                                cost <= (cost+1);
                            end
                            else begin
                                cost <= (cost+2);
                            end
                        end
                    end
                    if (sendChar == 1 && charSent == 127) begin
                         sentMsg[7:0]   <= 32;
                         sentMsg[15:8]  <= 32;
                         sentMsg[23:16] <= 32;
                         sentMsg[31:24] <= 32;
                         sentMsg[39:32] <= 32;
                         sentMsg[47:40] <= 32;
                         sentMsg[55:48] <= 32;
                         sentMsg[63:56] <= 32;
                    end 
                    if (current_state == IDLE) begin
                                    sentMsg[7:0]   <= 32;
                                    sentMsg[15:8]  <= 32;
                                    sentMsg[23:16] <= 32;
                                    sentMsg[31:24] <= 32;
                                    sentMsg[39:32] <= 32;
                                    sentMsg[47:40] <= 32;
                                    sentMsg[55:48] <= 32;
                                    sentMsg[63:56] <= 32;
                                    cost <= 0;
                                
                    end
                end
                COST: begin
                    statusMsg[31:0] <= 32;
                    statusMsg[39:32]<= 84;
                    statusMsg[47:40]<= 83;
                    statusMsg[55:48]<= 79;
                    statusMsg[63:56]<= 67;
                end
                                                  
            endcase
        end
    end 
     // additional always statements 
    endmodule

