module extend #(parameter WIDTH = 16 )(
    input [WIDTH -1:0]a,
    output [31:0]b
    );
    assign b = {{(32- WIDTH){0}},a};
endmodule

module sign_extend #(parameter WIDTH = 16 )(
    input [WIDTH -1:0]a,
    input S,
    output [31:0]b
    );
    assign b = (S==1)?{{(32- WIDTH){ a[WIDTH - 1]}},a} : {{(32- WIDTH){0}},a};
endmodule

module extend_18 (
    input [15:0]a,
    output [31:0]b
    );
    assign b = {{(14){a[15]}},a,2'b00} ;
endmodule

module catch(
    input [3:0]iA,
    input [25:0]iB,
    output [31:0]oZ 
);
    assign oZ={iA, iB,2'b00};
endmodule

/*
module catch_2zero(
    input [15:0]iA,
    output [17:0]oZ    
);
    assign oZ={iA,2'b00};
endmodule
*/