//ALU 运算器
module alu(
    input [31:0]a,
    input [31:0]b,
    input [3:0]aluc,
    output reg [31:0]r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow
    );
    reg allzero;
    initial allzero=0;
    always @(*) begin
            zero=0;
            carry=0;
            negative=0;
            overflow=0;
        case(aluc)
            4'b0000:{carry,r}=a+b;//ADDU
            4'b0010:{overflow,r}=a+b;//ADD
            4'b0001:{carry,r}=a-b;//SUBU
            4'b0011:{overflow,r}=a-b;//SUB
            4'b0100:r=a&b;//AND
            4'b0101:r=a|b;//OR
            4'b0110:r=a^b;//XOR
            4'b0111:r=~(a|b);//NOR
            //LUI
            4'b1000:r={b[15:0],16'b0};
            4'b1001:r={b[15:0],16'b0};
            4'b1011:{negative,r}=($signed(a) <$signed(b) )?33'h100000001:0;//SLT
            4'b1010:{carry,r}=({allzero,a}<{allzero,b})?33'h100000001:0;//SLTU
            4'b1100:{r,carry}=$signed({b,b[31]})>>>a;//SRA
            4'b1110:{carry,r}=b<<a;//SLA/SLR
            4'b1111:{carry,r}=b<<a;//SLA/SLR
            4'b1101:{r,carry}={b,b[31]}>>a;//SRL
            default:
             $display("Invalid ALU control signal");
        endcase
         if(r==32'b0)
            zero=1;
         if(aluc==4'b1011||aluc==4'b1010)
            zero=a==b?1:0;
         if(r[31]==1)
            negative=1;
    end 
endmodule
