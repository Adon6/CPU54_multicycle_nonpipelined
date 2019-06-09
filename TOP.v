
module sccomp_dataflow(

    input clk_in,
    input reset,

    output [31:0] inst,
    output [31:0] pc,
    output [31:0] addr 
    //output [7:0] o_seg,
	//output [7:0] o_sel
   
    );
    wire mem_wrt,mem_rd,mem_sign, clkDivided;
    wire [1:0]MEM_C;
    wire [31:0] dataIn, dataOut;
    wire [31:0]MEM_ADDR;
    //wire [7:0]o_seg,o_sel;

    assign addr=MEM_ADDR;

    assign clkDivided =clk_in;
    
    cpu sccpu( .clk( clkDivided), .rst( reset), .dataIn( dataIn), .GmemAddr(MEM_ADDR), 
    .dataOut( dataOut), .Gmem_W( mem_wrt), .Gmem_R(mem_rd),.MEM_S(mem_sign),.MEM_C(MEM_C),
    .pc(pc),.inst(inst));


    MEM GMEM(.MEM_W(mem_wrt),.MEM_R(mem_rd),.MEM_C(MEM_C),.MEM_S(mem_sign)
     ,.iAddr(MEM_ADDR- 32'h1001_0000), .iData(dataOut) ,.oData(dataIn));


    //divider #(4)clkDivider(.iCLK( clk_in),.oCLK(clkDivided));


endmodule