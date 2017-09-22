`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2017 12:40:20 PM
// Design Name: 
// Module Name: dm_cache_data
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

//TODO
//modify the cache so that it 
//is set associative
import cache_def::*; 

/*cache: data memory, single port, 1024 blocks*/
module dm_cache_data(input  bit clk, 
    input  cache_req_type  data_req,//data request/command, e.g. RW, valid
    input  cache_data_type data_write, //write port (128-bit line) 
    output cache_data_type data_read); //read port
    timeunit 1ns; timeprecision 1ps;
    cache_data_type data_mem[0:1023];
    cache_data_type set[0:N][0:floor(1024/N)][0:1023];  //an array of N sets with floor(1024/N) blocks
    cache_data_type history[0:1023];                      //array to hold history of addresses for LRU/MRU policies
    int cnt = 0;
    
  initial begin                                         //initialize arrays to 0
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < floor(1024/N); j++) begin
            for (int k = 0; k < 1024; k++) begin
                set[i][j][k] = 0;
            end
        end
    end
    for (int i=0; i<1024; i++) 
        history[i] = 0;
  end
    
  initial  begin
    for (int i=0; i<1024; i++) 
          data_mem[i] = 0;
  end
  
  assign  data_read  =  data_mem[data_req.index];
  
  always_ff  @(posedge(clk))  begin
    if  (data_req.we) begin
      data_mem[data_req.index] <= data_write;
      if(P==0) begin                                    //LRU
        history[0] <= data_write;                       //store data_write in most recent history index 0
        for (int i = 0; i < 1024; i++) begin            //looping through the cache lines
            for (int j = 0; j < floor(1024/N); j++)     //looping through the blocks in each set
                set[data_req.index%N][j][i] <= history[0];    
        end 
        for (int i = 0; i < 1024; i++) begin            //update history array
            history[i+1] = history[i];
        end
        cnt++;
      end
      if(P==1)                                          //MRU                                                   
        history[cnt] <= data_write;                     //store data_write in most recent history index 0
        for (int i = 0; i < 1024; i++) begin            //looping through the cache lines
            for (int j = 0; j < floor(1024/N); j++)     //looping through the blocks in each set
                set[data_req.index%N][j][i] <= history[0];    
        end 
        for (int i = 0; i < 1024; i++) begin            //update history array
            history[i] = history[i+1];
        end
        cnt++;
      end
    end
endmodule

/*cache: tag memory, single port, 1024 blocks*/
module dm_cache_tag(input  bit clk, //write clock
    input  cache_req_type tag_req, //tag request/command, e.g. RW, valid
    input  cache_tag_type tag_write,//write port    
    output cache_tag_type tag_read);//read port
  timeunit 1ns; timeprecision 1ps;
  cache_tag_type tag_mem[0:1023];
  cache_tag_type history[0:1023];                      //array to hold history of addresses for LRU/MRU policies
  cache_tag_type set[0:N];    //an array of N sets with floor(1024/N) blocks
  int cnt = 0;
  
initial begin                                         //initialize arrays to 0
  for (int i = 0; i < N; i++) begin
      set[i] = 0;
  end
  for (int i=0; i<1024; i++) 
      history[i] = 0;
end

  initial  begin
      for (int i=0; i<1024; i++) 
      tag_mem[i] = 0;
  end
  assign tag_read = tag_mem[tag_req.index];
  always_ff  @(posedge(clk))  begin
    if  (tag_req.we) begin
      tag_mem[tag_req.index] <= tag_write;
      if(P==0) begin                                    //LRU
        history[0] <= tag_write;                       //store data_write in most recent history index 0
        for (int i = 0; i < 1024; i++) begin            //looping through the cache lines
          for (int j = 0; j < floor(1024/N); j++)       //looping through the blocks in each set
            set[tag_req.index%N] <= history[0];    
          end 
          for (int i = 0; i < 1024; i++) begin          //update history array
            history[i+1] = history[i];
          end
          cnt++;
      end
      if(P==1)                                          //MRU                                                   
        history[cnt] <= tag_write;                     //store data_write in most recent history index 0
        for (int i = 0; i < 1024; i++) begin            //looping through the cache lines
            for (int j = 0; j < floor(1024/N); j++)     //looping through the blocks in each set
                 set[tag_req.index%N] <= history[0];    
        end 
        for (int i = 0; i < 1024; i++) begin            //update history array
            history[i] = history[i+1];
        end
        cnt++;
    end
  end
endmodule