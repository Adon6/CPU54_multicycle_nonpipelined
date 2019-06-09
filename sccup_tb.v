`timescale 1ns / 1ps

module test();
    reg clk, rst;
    wire [31:0] inst, pc, addr;
    wire instr_change;
    reg care;
    integer file_output;
    integer counter= 0;
  

    initial begin
        file_output= $fopen( "C:\\Users\\admin\\Desktop\\54CPUtest\\20_sll_myresult.txt");
        rst= 1;
        #12 rst= 0;
    end
        
    initial begin
        clk= 0;
        forever 
        #5 clk= ~clk;
    end

    always @(negedge instr_change)
    begin
        $fdisplay( file_output, "pc: %h", cpuTest.sccpu.pc_reg.data);
    end


    always@( posedge instr_change) 
    begin      
       
            counter= counter+ 1;

            $fdisplay( file_output, "instr: %h", cpuTest.sccpu.ir_reg.data);
            #2;
            //$fdisplay( file_output, "Daddr: %h", addr);
            //$fdisplay( file_output, "a= %h", cpuTest.sccpu.alu_a);
            //$fdisplay( file_output, "b= %h", cpuTest.sccpu.alu_b);
            //$fdisplay( file_output, "PC_MUX= %h", cpuTest.sccpu.pc_mux);
            //$fdisplay( file_output, "adderOut= %h", cpuTest.sccpu.adderOut);
            $fdisplay( file_output, "regfile0: %h", cpuTest.sccpu.cpu_ref.array_reg[0]);
            $fdisplay( file_output, "regfile1: %h", cpuTest.sccpu.cpu_ref.array_reg[1]);
            $fdisplay( file_output, "regfile2: %h", cpuTest.sccpu.cpu_ref.array_reg[2]);
            $fdisplay( file_output, "regfile3: %h", cpuTest.sccpu.cpu_ref.array_reg[3]);
            $fdisplay( file_output, "regfile4: %h", cpuTest.sccpu.cpu_ref.array_reg[4]);
            $fdisplay( file_output, "regfile5: %h", cpuTest.sccpu.cpu_ref.array_reg[5]);
            $fdisplay( file_output, "regfile6: %h", cpuTest.sccpu.cpu_ref.array_reg[6]);
            $fdisplay( file_output, "regfile7: %h", cpuTest.sccpu.cpu_ref.array_reg[7]);
            $fdisplay( file_output, "regfile8: %h", cpuTest.sccpu.cpu_ref.array_reg[8]);
            $fdisplay( file_output, "regfile9: %h", cpuTest.sccpu.cpu_ref.array_reg[9]);
            $fdisplay( file_output, "regfile10: %h", cpuTest.sccpu.cpu_ref.array_reg[10]);
            $fdisplay( file_output, "regfile11: %h", cpuTest.sccpu.cpu_ref.array_reg[11]);
            $fdisplay( file_output, "regfile12: %h", cpuTest.sccpu.cpu_ref.array_reg[12]);
            $fdisplay( file_output, "regfile13: %h", cpuTest.sccpu.cpu_ref.array_reg[13]);
            $fdisplay( file_output, "regfile14: %h", cpuTest.sccpu.cpu_ref.array_reg[14]);
            $fdisplay( file_output, "regfile15: %h", cpuTest.sccpu.cpu_ref.array_reg[15]);
            $fdisplay( file_output, "regfile16: %h", cpuTest.sccpu.cpu_ref.array_reg[16]);
            $fdisplay( file_output, "regfile17: %h", cpuTest.sccpu.cpu_ref.array_reg[17]);
            $fdisplay( file_output, "regfile18: %h", cpuTest.sccpu.cpu_ref.array_reg[18]);
            $fdisplay( file_output, "regfile19: %h", cpuTest.sccpu.cpu_ref.array_reg[19]);
            $fdisplay( file_output, "regfile20: %h", cpuTest.sccpu.cpu_ref.array_reg[20]);
            $fdisplay( file_output, "regfile21: %h", cpuTest.sccpu.cpu_ref.array_reg[21]);
            $fdisplay( file_output, "regfile22: %h", cpuTest.sccpu.cpu_ref.array_reg[22]);
            $fdisplay( file_output, "regfile23: %h", cpuTest.sccpu.cpu_ref.array_reg[23]);
            $fdisplay( file_output, "regfile24: %h", cpuTest.sccpu.cpu_ref.array_reg[24]);
            $fdisplay( file_output, "regfile25: %h", cpuTest.sccpu.cpu_ref.array_reg[25]);
            $fdisplay( file_output, "regfile26: %h", cpuTest.sccpu.cpu_ref.array_reg[26]);
            $fdisplay( file_output, "regfile27: %h", cpuTest.sccpu.cpu_ref.array_reg[27]);
            $fdisplay( file_output, "regfile28: %h", cpuTest.sccpu.cpu_ref.array_reg[28]);
            $fdisplay( file_output, "regfile29: %h", cpuTest.sccpu.cpu_ref.array_reg[29]);
            $fdisplay( file_output, "regfile30: %h", cpuTest.sccpu.cpu_ref.array_reg[30]);
            $fdisplay( file_output, "regfile31: %h", cpuTest.sccpu.cpu_ref.array_reg[31]);                          
            
     

        /*
        else begin
            $fclose( file_output);
        
        end*/
        
    end
    
    sccomp_dataflow cpuTest( .clk_in( clk), .reset( rst), .inst( inst), .pc( pc), .addr( addr),.instr_change(instr_change)
    
    );
    /*module sccomp_dataflow(
        input clk_in,
        input reset,
 );*/
    
endmodule

