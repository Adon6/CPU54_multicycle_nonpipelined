/*
module pcreg(
    input clk,  //下升沿有效
    input rst,   //高电平有效
    input ena, //1read,0keep
    input [31:0] iData,
    output reg [31:0] oData
    );

    
    initial begin
        oData<= 32'h0040_0000;
    end
    

    always @( negedge clk,negedge rst) begin
        if( rst== 1) 
            oData<= 32'h0040_0000;
        else begin
            if(ena)
                oData<= iData;
            else
                oData<= oData;
        end
    end

endmodule

*/

module reg#(parameter INIT =32'h0040_0000)(
    input rst,   //高电平有效
    input [31:0]wdata,
    input write,
    input read,
    output [31:0]rdata
)
    reg [31:0]data;

    always @(*)begin
        if (rst)
            odata<=INIT;
        else if(write)
            data<=wdata; 
    end

    assign rdata<=(read)?data:{z{32}};

endmodule