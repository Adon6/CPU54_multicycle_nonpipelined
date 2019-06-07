module CLZ(
    input [31:0]data_in,
    output reg [31:0]data_out
)
    integer i;
    always @(*)begin
        for(i=31;i>=0;i=i-1)
            if(data_in[i]==1)begin
                data_out<= 31-i;
                break;
            end      
    end

endmodule