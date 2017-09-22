//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
// Company:
// Engineer:
//
// Create Date:    11:00:54 02/23/2017
// Design Name:
// Module Name:    cpu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

//the CPU module from 4.13.4 of the textbook from the online companion material
//The initial register and memory state are read from .dat files and the
//resulting register and memory state are each printed into corresponding .dat
//files
//TODO
//implement three other instructions, cmov, jrt and lwcab and also
//a 'taken' branch predictor

module CPU (clock);
   parameter LW = 6'b100011, SW = 6'b101011, BEQ = 6'b000100, no_op = 32'b0000000_0000000_0000000_0000000, ALUop = 6'b0,
					jrt = 30, lwcab = 31;
   integer fd,code,str;
   input clock;

   reg[31:0] PC, currPC, Regs[0:31], IMemory[0:1023], DMemory[0:1023], // separate memories
             IFIDIR, IDEXA, IDEXB, IDEXIR, EXMEMIR, EXMEMB, // pipeline registers
             EXMEMALUOut, MEMWBValue, MEMWBIR; // pipeline registers
   wire [4:0] IDEXrs, IDEXrt, EXMEMrd, MEMWBrd, MEMWBrt; //hold register fields
   wire [5:0] EXMEMop, MEMWBop, IDEXop; //Hold opcodes
	reg [5:0] IFIDop;
   wire [31:0] Ain, Bin;


   //declare the bypass signals
   wire takebranch, stall, bypassAfromMEM, bypassAfromALUinWB,bypassBfromMEM, bypassBfromALUinWB,
        bypassAfromLWinWB, bypassBfromLWinWB;
   assign IDEXrs = IDEXIR[25:21];  assign IDEXrt = IDEXIR[20:16];  assign EXMEMrd=EXMEMIR[15:11];
   assign MEMWBrd = MEMWBIR[15:11]; assign EXMEMop = EXMEMIR[31:26]; assign MEMWBrt=MEMWBIR[20:16];
   assign MEMWBop = MEMWBIR[31:26];  assign IDEXop = IDEXIR[31:26];
   // The bypass to input A from the MEM stage for an ALU operation
   assign bypassAfromMEM = (IDEXrs == EXMEMrd) & (IDEXrs!=0) & (EXMEMop==ALUop); // yes, bypass
   // The bypass to input B from the MEM stage for an ALU operation
   assign bypassBfromMEM = (IDEXrt == EXMEMrd)&(IDEXrt!=0) & (EXMEMop==ALUop); // yes, bypass
   // The bypass to input A from the WB stage for an ALU operation
   assign bypassAfromALUinWB =( IDEXrs == MEMWBrd) & (IDEXrs!=0) & (MEMWBop==ALUop);
   // The bypass to input B from the WB stage for an ALU operation
   assign bypassBfromALUinWB = (IDEXrt == MEMWBrd) & (IDEXrt!=0) & (MEMWBop==ALUop);
   // The bypass to input A from the WB stage for an LW operation
   assign bypassAfromLWinWB =( IDEXrs == MEMWBIR[20:16]) & (IDEXrs!=0) & (MEMWBop==LW);
   // The bypass to input B from the WB stage for an LW operation
   assign bypassBfromLWinWB = (IDEXrt == MEMWBIR[20:16]) & (IDEXrt!=0) & (MEMWBop==LW);
   // The A input to the ALU is bypassed from MEM if there is a bypass there,
   // Otherwise from WB if there is a bypass there, and otherwise comes from the IDEX register
   assign Ain = bypassAfromMEM? EXMEMALUOut :
               (bypassAfromALUinWB | bypassAfromLWinWB)? MEMWBValue : IDEXA;
   // The B input to the ALU is bypassed from MEM if there is a bypass there,
   // Otherwise from WB if there is a bypass there, and otherwise comes from the IDEX register
   assign Bin = bypassBfromMEM? EXMEMALUOut :
               (bypassBfromALUinWB | bypassBfromLWinWB)? MEMWBValue: IDEXB;
   // The signal for detecting a stall based on the use of a result from LW
   assign stall = (EXMEMIR[31:26]==LW) && // source instruction is a load
         ((((IDEXop==LW)|(IDEXop==SW)) && (IDEXrs==EXMEMIR[20:16])) | // stall for address calc
          ((IDEXop==ALUop) && ((IDEXrs==EXMEMIR[20:16]) |
          (IDEXrt==EXMEMIR[20:16])))); // ALU use

   //Signal for a taken branch: instruction is BEQ and registers are equal
   assign takebranch = (IFIDIR[31:26]==BEQ) && (Regs[IFIDIR[25:21]] == Regs[IFIDIR[20:16]]);
   reg [10:0] i; //used to initialize registers
   initial begin
      #1 //delay of 1, wait for the input ports to initialize
      PC = 0;
		currPC = PC;   //To keep track of the current instruction being implemented
      IFIDIR = no_op; IDEXIR = no_op; EXMEMIR = no_op; MEMWBIR = no_op; // put no_ops in pipeline registers
      for (i=0;i<=31;i=i+1) Regs[i]=i; //initialize registers -- just so they aren't don't cares
      for(i=0;i<=1023;i=i+1) IMemory[i]=0;
      for(i=0;i<=1023;i=i+1) DMemory[i]=0;
      fd=$fopen("./regs.dat","r");
      i=0; while(!$feof(fd)) begin
        code=$fscanf(fd, "%b\n", str);
        Regs[i]=str;
        i=i+1;
      end
      i=0; fd=$fopen("./dmem.dat","r");
      while(!$feof(fd)) begin
        code=$fscanf(fd, "%b\n", str);
        DMemory[i]=str;
        i=i+1;
      end
      i=0; fd=$fopen("./imem.dat","r");
      while(!$feof(fd)) begin
        code=$fscanf(fd, "%b\n", str);
        IMemory[i]=str;
        i=i+1;
      end
      #396
      i=0; fd =$fopen("./mem_result.dat","w" ); //open memory result file
      while(i < 32)
      begin
        str = DMemory[i];  //dump the first 32 memory values
        $fwrite(fd, "%b\n", str);
        i=i+1;
      end
      $fclose(fd);
      i=0; fd =$fopen("./regs_result.dat","w" ); //open register result file
      while(i < 32)
      begin
        str = Regs[i];  //dump the register values
        $fwrite(fd, "%b\n", str);
        i=i+1;
      end
      $fclose(fd);
   end
   always @ (posedge clock) begin
   if (~stall) begin // the first three pipeline stages stall if there is a load hazard
      if (~takebranch) begin
      //first instruction in the pipeline is being fetched normally
         $display("IFIDIR updated \n");
         IFIDIR <= IMemory[PC>>2];
			IFIDop <= IFIDIR[31:26];
			if(IFIDop == BEQ) begin					//branch taken predictor (Always assume Branch is taken)
				currPC <= PC;
				PC <= PC + 4 + ({{16{IFIDIR[15]}}, IFIDIR[15:0]}<<2);
			end
			else begin
				currPC <= PC;
				PC <= PC + 4;
			end
      end else begin // a taken branch is in ID; instruction in IF is wrong; insert a no_op and reset the PC
         IFIDIR <= no_op;
         PC <= PC + ({{16{IFIDIR[15]}}, IFIDIR[15:0]}<<2);
			currPC <= PC;
      end
      //second instruction is in register fetch
      IDEXA <= Regs[IFIDIR[25:21]]; IDEXB <= Regs[IFIDIR[20:16]]; // get two registers
      //third instruction is doing address calculation or ALU operation
      IDEXIR <= IFIDIR;  //pass along IR
      if ((IDEXop==LW) |(IDEXop==SW))  // address calculation & copy B
           EXMEMALUOut <= Ain +{{16{IDEXIR[15]}}, IDEXIR[15:0]};
      else if (IDEXop==ALUop) 
				case (IDEXIR[5:0]) //case for the various R-type instructions
					29: if(Ain < Bin)					 //conditional move instruction - if (R[rs]<R[rt]) R[rd]=R[shamt] else do nothing
							EXMEMALUOut <= IDEXIR[10:6];
					32: EXMEMALUOut <= Ain + Bin;  //add operation
					36: EXMEMALUOut <= Ain & Bin;  //AND operation
					37: EXMEMALUOut <= Ain | Bin;  //OR operation
					42: if(Ain < Bin) 				 //SLT operation
							EXMEMALUOut <= 1;			 //set rd = 1 if rs<rt
						 else
							EXMEMALUOut <= 0;			 //or set to 0 otherwise
               default: EXMEMALUOut <= Ain - Bin;  						//other R-type operations: subtract, SLT, etc.
            endcase
		else if(IDEXop==jrt) begin					 								//jrt instruction
			if(Ain == 0) begin														//if(R[rs]==0)
				Regs[IDEXIR[25:21]] <= Ain + 1;									//R[rs] = R[rs]+1
				PC <= PC + 4 + ({{16{IDEXIR[15]}}, IDEXIR[15:0]}<<2);    //PC=PC+4+loop
			end
		end
		else if(IDEXop==BEQ) begin
			if((Ain != Bin) && (takebranch == 1)) begin
				//takebranch <= 0;
				IDEXIR <= no_op;
				PC <= currPC + ({{16{IFIDIR[15]}}, IFIDIR[15:0]}<<2);
			end
		end
      EXMEMIR <= IDEXIR; EXMEMB <= IDEXB; //pass along the IR & B register
   end
   else EXMEMIR <= no_op; //Freeze first three stages of pipeline; inject a nop into the EX output
      //Mem stage of pipeline
      if (EXMEMop==ALUop) MEMWBValue <= EXMEMALUOut; //pass along ALU result
      else if (EXMEMop == LW) MEMWBValue <= DMemory[EXMEMALUOut>>2];
      else if (EXMEMop == SW) DMemory[EXMEMALUOut>>2] <=EXMEMB; //store
		else if(IDEXop==lwcab) begin				 //lwcab instruction
			if(Bin < Regs[EXMEMIR[15:11]])
				Regs[EXMEMIR[25:21]] <= DMemory[EXMEMB>>2];
			else
				Regs[EXMEMIR[25:21]] <= 0;
		end
      //the WB stage
      MEMWBIR <= EXMEMIR; //pass along IR
      if ((MEMWBop==ALUop) & (MEMWBrd != 0)) Regs[MEMWBrd] <= MEMWBValue; // ALU operation
      else if ((MEMWBop == LW)& (MEMWBIR[20:16] != 0)) Regs[MEMWBIR[20:16]] <= MEMWBValue;
   end
endmodule
