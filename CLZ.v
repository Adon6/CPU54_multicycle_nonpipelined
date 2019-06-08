module clz(
    input clz_c,
    input [31:0]data_in,
    output reg [31:0]data_out
);

    always @(posedge clz_c)begin      

        casex(data_in)
            32'b1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd1;
            32'b01xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd1;
            32'b001xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd2;
            32'b0001xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd3;
            32'b00001xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd4;
            32'b000001xx_xxxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd5;
            32'b0000001x_xxxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd6;
            32'b00000001_xxxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd7;
            32'b00000000_1xxxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd8;
            32'b00000000_01xxxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd9;
            32'b00000000_001xxxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd10;
            32'b00000000_0001xxxx_xxxxxxxx_xxxxxxxx: data_out<=32'd11;
            32'b00000000_00001xxx_xxxxxxxx_xxxxxxxx: data_out<=32'd12;
            32'b00000000_000001xx_xxxxxxxx_xxxxxxxx: data_out<=32'd13;
            32'b00000000_0000001x_xxxxxxxx_xxxxxxxx: data_out<=32'd14;
            32'b00000000_00000001_xxxxxxxx_xxxxxxxx: data_out<=32'd15;
            32'b00000000_00000000_1xxxxxxx_xxxxxxxx: data_out<=32'd16;
            32'b00000000_00000000_01xxxxxx_xxxxxxxx: data_out<=32'd17;
            32'b00000000_00000000_001xxxxx_xxxxxxxx: data_out<=32'd18;
            32'b00000000_00000000_0001xxxx_xxxxxxxx: data_out<=32'd19;
            32'b00000000_00000000_00001xxx_xxxxxxxx: data_out<=32'd20;
            32'b00000000_00000000_000001xx_xxxxxxxx: data_out<=32'd21;
            32'b00000000_00000000_0000001x_xxxxxxxx: data_out<=32'd22;
            32'b00000000_00000000_00000001_xxxxxxxx: data_out<=32'd23;
            32'b00000000_00000000_00000000_1xxxxxxx: data_out<=32'd24;
            32'b00000000_00000000_00000000_01xxxxxx: data_out<=32'd25;
            32'b00000000_00000000_00000000_001xxxxx: data_out<=32'd26;
            32'b00000000_00000000_00000000_0001xxxx: data_out<=32'd27;
            32'b00000000_00000000_00000000_00001xxx: data_out<=32'd28;
            32'b00000000_00000000_00000000_000001xx: data_out<=32'd29;
            32'b00000000_00000000_00000000_0000001x: data_out<=32'd30;
            32'b00000000_00000000_00000000_00000001: data_out<=32'd31;
            32'b00000000_00000000_00000000_00000000: data_out<=32'd32;
            default:;
        endcase

    end

endmodule