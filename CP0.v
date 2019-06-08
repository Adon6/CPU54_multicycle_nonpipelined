module CP0(
    input clk,
    input rst,
    input mfc0, // CPU instruction is Mfc0
    input mtc0, // CPU instruction is Mtc0
    input eret, // Instruction is ERET (Exception Return)
    //input intr, // Instruction which needs interuption
    input exception, //?whta's this ?
    //this
    input [4:0] Rd, // Specifies Cp0 register
    //pc
    input [31:0]pc,
    //rs or others,not control at least
    input [31:0]wdata, // Data from GP register to replace CP0 register
    //control
    input [4:0]cause,
    output [31:0] rdata, // Data from CP0 register for GP register
    output [31:0] status,
    //output reg timer_int,
    output reg [31:0]exc_addr // Address for PC at the beginning of an exception
);
    parameter status_reg = 4'hc;
    parameter cause_reg = 4'hd;
    parameter epc_reg = 4'he;
    integer i;
    wire [31:0]status_left,status_back;
    assign status_left = status<<5;
    assign status_back = status>>5;

    reg [31:0] array_reg [31:0];

    always @(negedge clk) begin
        if(rst==1)begin//高位有效<1R>
            i= 0;
            repeat( 32) begin
                array_reg[i]<= 0;
                i= i+ 1;
            end
        end

        if (mtc0 == 1) begin 
            array_reg[Rd] <=wdata;
        end

        if (exception)begin //it's syscall break or teq ,then
            array_reg[status_reg]<=status_left;
            array_reg[cause_reg][6:2]<=cause;
            array_reg[epc_reg]<=pc;
            exc_addr <= 32'h0000_0004;
        end 
        else if (eret) begin
            exc_addr[epc_reg]<=pc;            
        end
        else
            exc_addr[epc_reg]<=pc;
        
    end

    assign status = array_reg[status_reg];
    assign rdata = (mfc0)? array_reg[Rd]:32'h0;
    //assign exc_addr <= array_reg[epc_reg];
endmodule