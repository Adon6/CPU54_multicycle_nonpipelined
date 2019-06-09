
module reg_pc(
    input rst,   //高电平有效
    input write,
    input read,
    input [31:0] wdata,
    output [31:0] rdata
    );

    reg [31:0]data;


    always @(*) begin
        if( rst== 1) 
            data<= 32'h0000_0000;
        else  if(write)
            data<=wdata; 
        else
            data<=data;
    end
    assign rdata=(read)?data:32'hzzzz;

endmodule



module reg_32(
    input rst,   //高电平有效
    input write,
    input read,
    input [31:0]wdata,
    output [31:0]rdata
);
    reg [31:0]data;

    always @(*)begin
        if (rst)
            data<=32'h0000_0000;
        else if(write)
            data<=wdata; 
        else
            data<=data;
    end

    assign rdata=(read)?data:32'hzzzz;

endmodule