module mdu(
    input [31:0]A,
    input [31:0]B,
    input MUL_C,
    input DIV_C,
    input Sign,
    output [31:0]LO,
    output [31:0]HI
);

/*方法1，有很大风险
assign {HI,LO}= (MUL_C&&Sign)?A*B:
            ( (MUL_C&&!Sign)?{{0,A}*{0,B}:
            ( (DIV_C&&Sign)?A*B:
            ( (DIV_C&&!Sign)?{0,A}*{0,B}:{0{64}})));
*/
/*方法2，可能有风险
assign {HI,LO}= (MUL_C&&Sign)?A*B:
            ( (MUL_C&&!Sign)?  $unsigned(A)*$unsigned(B):
            ( (DIV_C&&Sign)?   {A%B,A/B[31:0]}:
            ( (DIV_C&&!Sign)?  {$unsigned(A)%$unsigned(B),$unsigned(A)/$unsigned(B)[31:0]}:
            {0{64}};
*/
//方法三 采用寄存器，风险较低
    reg [63:0]prod;
    reg [31:0]rem;
    reg [31:0]quo;
    always @(*)begin
        if(MUL_C && Sign )begin
            prod <= A*B;    
        end
        else if (MUL_C && !Sign)begin
            prod <=$unsigned(A)*$unsigned(B);
        end
        else if(DIV_C && Sign)begin
            rem<=A%B;
            quo<=A/B;
        end
        else if (DIV_C && Sign)begin
            rem<=$unsigned(A)%$unsigned(B);
            quo<=$unsigned(A)/$unsigned(B);//??maybe wrong?
        end
        else
            rem<=32'h00000000;
    end

    assign {HI,LO}= (MUL_C)?prod:((DIV_C)?{rem,quo}:{0{64}});
    
    
endmodule