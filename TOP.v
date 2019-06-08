
module sccomp_dataflow(

    input clk_in,
    input reset,


    //output [7:0] o_seg,
	//output [7:0] o_sel
   
    );
    wire mem_wrt,mem_rd,mem_sign, clkDivided;
    wire [1:0]MEM_C;
    wire [31:0] dataIn, dataOut;
    //wire [7:0]o_seg,o_sel;
    // wire [31:0] inst;
    //wire [31:0] pc;
    //wire [31:0] addr; 

    cpu sccpu( .clk( clkDivided), .rst( reset), .dataIn( dataIn), .GmemAddr( addr), 
    .dataOut( dataOut), .mem_W( mem_wrt),mem_R(mem_rd),.MEM_S(mem_sign),.MEM_C(MEM_C)
       );


    MEM GMEM(.clk(clkDivided),.MEM_W(mem_wrt),.MEM_R(mem_rd),.MEM_C(MEM_C),.MEM_S(mem_sign)
     ,.iAddr(addr- 32'h1001_0000), .iData(dataOut) ,.oData(dataIn));


    divider #(2)clkDivider(.iCLK( clk_in),.oCLK(clkDivided));


endmodule