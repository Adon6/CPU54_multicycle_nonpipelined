module selector81(
    input [31:0] iC0,
    input [31:0] iC1,
    input [31:0] iC2,
    input [31:0] iC3,
    input [31:0] iC4,
    input [31:0] iC5,
    input [31:0] iC6,
    input [31:0] iC7,
    input [2:0]iS,
    output [31:0] oZ
    );
    //00>0;01>1;10>2;11>3
    assign oZ=(iS==3'b000 ) ? iC0 :
            ((  iS==3'b001  ) ? iC1 :
            ((  iS==3'b010  ) ? iC2 :
            ((  iS==3'b011  ) ? iC3 :
            ((  iS==3'b100  ) ? iC4 :
            ((  iS==3'b101  ) ? iC5 :
            ((  iS==3'b110  ) ? iC6 : iC7))))));   
endmodule


module selector41(
    input [31:0] iC0,
    input [31:0] iC1,
    input [31:0] iC2,
    input [31:0] iC3,
    input [1:0]iS,
    output [31:0] oZ
    );
    //00>0;01>1;10>2;11>3
    assign oZ=(iS==2'b00 ) ? iC0 :
            ((  iS==2'b01  ) ? iC1 :
            ((  iS==2'b10  ) ? iC2 : iC3));       
endmodule

module selector21(
    input [31:0] iC0,
    input [31:0] iC1,
    input iS,
    output [31:0] oZ
    );
    assign oZ=iS ? iC1 : iC0;       
endmodule

module selector_rdc(
    input [4:0] iC0,
    input [4:0] iC1,
 // input [4:0] iC2,
 // input [4:0] iC3,

    input [1:0]iS,
    output [4:0] oZ
    );
    //00>0;01>1;10>2;11>3
    assign oZ=(iS==2'b00 ) ? iC0 :
            ((  iS==2'b01  ) ? iC1 :
            ((  iS==2'b10  ) ? 5'h1f :iC0 ));       
endmodule
