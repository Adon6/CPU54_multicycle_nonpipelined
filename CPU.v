module cpu(
    input clk,
    input rst,
    input [31:0] dataIn,
    output Gmem_W,
    output Gmem_R,
    output instr_change,

    //output [31:0] imemAddr,
    output [31:0]inst,
    output [31:0]pc,
    output [31:0] GmemAddr,
    output [31:0] dataOut,
    output MEM_S,
    output [1:0]MEM_C
    );
    
   
    //wire pc_clk,rf_W,rf_clk,pc_wrt,pc_rst;
   //接口定义列表
   // kokokara
    wire alu_z,alu_c,alu_n,alu_o;
    wire mfc0,mtc0,eret,exception;
    wire [4:0]cause;

    wire sign_ext;
    wire [1:0]mux_pc;
    wire PC_in,PC_out,Y_in,Y_out;
    //mem connected
    wire mux_mem, mem_w, mem_r;
    wire [1:0]mux_A;
    wire [2:0]mux_B;
    wire [3:0]ALU_C;
    wire [1:0]mux_rdc;
    wire [2:0]mux_rd;
    wire rd_w;
    wire mux_lo, mux_hi , lo_w, hi_w, S_mdu;
    wire MUL_C, DIV_C;
    wire IR_in,clz_c;

    wire [4:0] mux_rdc_out;
    wire [31:0] mux_pc_out, mux_mem_out, mux_a_out, mux_b_out, mux_lo_out, mux_hi_out,mux_rd_out;
    wire [31:0] pc_out, y_out, ir_out, lo_out, hi_out ,clz_out, cp0_out,status_cp0;
    wire [31:0] rs_out,rt_out,rd_in;
    wire [31:0] ext16_out,ext18_out,ext5_out,catch_out;
    wire [31:0] mdu_hi_out,mdu_lo_out;
    wire [31:0] alu_f;

    wire [31:0] exc_addr;

    wire [4:0] rtc,rsc,rdc,shamt;
    wire [5:0] op,func;
    wire [15:0]offset;
    wire [25:0]target;

    wire ONE,ZERO;
    wire [31:0]ERROR,CONST_4,CONST_0;
/*
    wire M3C; 
    wire [4:0]cause;
    wire [1:0]M2C,M4C,M5C;
    wire [2:0]M1C;
    wire [3:0]ALU_C;
    wire [4:0]mux5_out;//2 LINKED TO RD
    wire [4:0]rtc,rsc,rdc,shamt;
    wire [5:0]op,func;
    wire [15:0]offset;
    wire [25:0]target;

    wire [31:0]npc_out,pc_out,add2_out,add1_out;
    wire [31:0]mux1_out,mux2_out,mux3_out,mux4_out;
    wire [31:0]ext16_out,ext18_out,sext16_out,ext5_out,catch_out;
    wire [31:0]rs,rt,rd,alu_f;
    wire [31:0]rdata_cp0,status_cp0,exc_addr;
    wire [17:0]imm_18;

*/
    assign ZERO =0;
    assign ONE=1;
    assign ERROR =32'HFFFF;
    assign CONST_4 =32'H0004;
    assign CONST_0 =32'H0000;
    //线型赋值列表

    assign op= ir_out[31:26];
    assign rsc= ir_out[25:21];
    assign rtc= ir_out[20:16];
    assign rdc= ir_out[15:11];
    assign shamt= ir_out[10:6];
    assign func= ir_out[5:0];
    assign target = ir_out[25:0];
    assign offset =ir_out[15:0];

    //output connect
    assign Gmem_W = mem_w;
    assign Gmem_R = mem_r;

    assign GmemAddr = mux_mem_out;
    assign inst=ir_out;
    assign pc=pc_out;
    assign dataOut =  rt_out;

/*
    assign pc_clk=clk;
    assign rf_clk=clk;
    assign rd=mux2_out;

    //assign pc31t28= pc_out[31:28];
    assign op= inst[31:26];
    assign rsc= inst[25:21];
    assign rtc= inst[20:16];
    assign rdc= inst[15:11];
    assign shamt= inst[10:6];
    assign func= inst[5:0];
    assign target = inst[25:0];
    assign offset =inst[15:0];

    assign imemAddr=pc_out;
    assign dataOut= rt;
    assign dmemAddr= alu_f;     
*/



    extend #(5)EXT5(.a(shamt),.b(ext5_out) );
    sign_extend #(16)S_EXT16(.a(offset),.S(sign_ext),.b(ext16_out));
    extend_18 #(18)EXT18(.a(offset),.b(ext18_out));
    catch CATCH_unit (.iA(pc_out[31:28]),.iB(target),.oZ(catch_out));

/*
module extend #(parameter WIDTH = 16 )(
    input [WIDTH -1:0]a,
    output [31:0]b
    );

module sign_extend #(parameter WIDTH = 16 )(
    input [WIDTH -1:0]a,
    input S,
    output [31:0]b
    );

module extend_18 #(parameter WIDTH = 16 )(
    input [WIDTH -1:0]a,
    output [31:0]b
    );

module catch(
    input [3:0]iA,
    input [27:0]iB,
    output [31:0]oZ    
);
*/

    selector41 MUX_PC(.iC0(catch_out),.iC1(y_out),.iC2(exc_addr),.iC3(ERROR),.iS(mux_pc),.oZ(mux_pc_out) );
    selector21 MUX_MEM(.iC0(pc_out),.iC1(y_out), .iS(mux_mem),.oZ(mux_mem_out));
    selector_rdc MUX_RDC(.iC0(rdc),.iC1(rtc),.iS(mux_rdc),.oZ(mux_rdc_out) );
    selector81 MUX_RD(.iC0(y_out ),.iC1(rt_out),.iC2(cp0_out),.iC3(lo_out),.iC4(hi_out)
        ,.iC5(clz_out),.iC6(ERROR),.iC7(ERROR),.iS(mux_rd),.oZ(mux_rd_out) );
    selector41 MUX_A(.iC0(ext5_out),.iC1(pc_out),.iC2(rs_out),.iC3(ERROR),.iS(mux_A),.oZ(mux_a_out) );
    selector81 MUX_B(.iC0(rt_out ),.iC1(ext16_out),.iC2(ext18_out),.iC3(CONST_4),.iC4(CONST_0)
        ,.iC5(ERROR),.iC6(ERROR),.iC7(ERROR),.iS(mux_B),.oZ(mux_b_out) );
    selector21 MUX_LO(.iC0(mdu_lo_out),.iC1(rs_out), .iS(mux_lo),.oZ(mux_lo_out) );
    selector21 MUX_HI(.iC0(mdu_hi_out),.iC1(rs_out), .iS(mux_hi),.oZ(mux_hi_out) );

/*
module selector21(
    input [31:0] iC0,
    input [31:0] iC1,
    input iS,
    output [31:0] oZ
    );

module selector41(
    input [31:0] iC0,
    input [31:0] iC1,
    input [31:0] iC2,
    input [31:0] iC3,
    input [1:0]iS,
    output [31:0] oZ
    );
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


*/


    /*下面是两个硬核部件，计算器和控制器*/
    alu ALU_unit(.a(mux_a_out),.b(mux_b_out),.aluc(ALU_C),.r(alu_f),.zero(alu_z),.carry(alu_c),.negative(alu_n),.overflow(alu_o));

    mdu MDU_unit(.A(rs_out),.B(rt_out),.Sign(S_mdu),.MUL_C(MUL_C),.DIV_C(DIV_C),.LO(mdu_lo_out),.HI(mdu_hi_out));


/*
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

module mdu(
    input [31:0]A,
    input [31:0]B,
    input MUL_C,
    input DIV_C,
    input Sign,
    output [31:0]LO,
    output [31:0]HI,
)
*/

    CONTROLLER CONTROL_unit(.instr(ir_out),.clk(clk),.alu_Z(alu_z),.alu_C(alu_c),.alu_N(alu_n),.alu_O(alu_o),.reset(rst),
    .S(sign_ext),.M_pc(mux_pc),.PC_in(PC_in),.PC_out(PC_out),.Y_in(Y_in),.Y_out(Y_out),.M_mem(mux_mem),.MEM_w(mem_w),
    .MEM_r(mem_r),.MEM_S(MEM_S),.MEM_C(MEM_C),.M_A(mux_A),.M_B(mux_B),.ALUC(ALU_C),.M_rdc(mux_rdc),.M_rd(mux_rd),
    .Rd_w(rd_w),.M_lo(mux_lo),.M_hi(mux_hi),.LO_w(lo_w),.HI_w(hi_W),.S_mdu(S_mdu),.MUL_C(MUL_c),.DIV_C(DIV_C),.IR_in(IR_in),
   .clz_c(clz_c),.mfc0(mfc0),.mtc0(mtc0),.eret(eret),.exception(exception),.cause(cause),.instr_change(instr_change));

/*
module CONTROLLER(
    input [31:0]instr,
    input clk,
    input alu_Z,
    input alu_C,
    input alu_N,
    input alu_O,
    input reset,   

    output S, 
    
    output [1:0]M_pc,
    output PC_in,
    output PC_out,
    
    output Y_in,
    output Y_out,
    
    output M_mem,
    output MEM_w,
    output MEM_r,
    output MEM_S,
    output [1:0]MEM_C,

    output [1:0]M_A,
    output [2:0]M_B,
    output [3:0]ALUC,

    output [1:0]M_rdc,
    output [2:0]M_rd,
    output Rd_w,


    output M_lo,
    output M_hi,
    output LO_w,
    output HI_w,
    output S_mdu,
    output MUL_C,
    output DIV_C,

    output IR_in,

    output mfc0,
    output mtc0,
    output eret,
    output exception,
    output [4:0]cause
    
)
*/

    /*这下面是带有时钟的部件*/
    //<1R>,<1E>
    regfile cpu_ref(.clk(clk), .rst(rst), .we(rd_w), .raddr1(rsc), .raddr2(rtc), .waddr(mux_rdc_out), .wdata(mux_rd_out), .rdata1(rs_out), .rdata2(rt_out) );
    
/*
module regfile(
    input clk,   
    input rst,   
    input we,    
    input [4:0] raddr1,      
    input [4:0] raddr2,      
    input [4:0] waddr,       
    input [31:0] wdata,      
    output [31:0] rdata1,   
    output [31:0] rdata2    
    );
    
*/

    reg_pc pc_reg(.rst(rst),.wdata(mux_pc_out),.write(PC_in),.read(PC_out),.rdata(pc_out));
    reg_32 y_reg(.rst(rst),.wdata(alu_f),.write(Y_in),.read(Y_out),.rdata(y_out));
    reg_32 ir_reg(.rst(rst),.wdata(dataIn),.write(IR_in),.read(ONE),.rdata(ir_out));
    reg_32 lo_reg(.rst(rst),.wdata(mux_lo_out),.write(lo_w),.read(ONE),.rdata(lo_out));
    reg_32 hi_reg(.rst(rst),.wdata(mux_hi_out),.write(hi_w),.read(ONE),.rdata(hi_out));
    clz clz_unit(.clz_c(clz_c),.data_in(rs_out),.data_out(clz_out));


/*
module reg_32(
    input rst,   //高电平有效
    input [31:0]wdata,
    input write,
    input eead,
    output [31:0]rdata
)

module clz(
    input [31:0]data_in,
    output reg [31:0]data_out
)

*/


    CP0 cp0_unit(.clk(clk),.rst(rst),.mfc0(mfc0),.mtc0(mtc0),.eret(eret),.exception(exception),.Rd(rdc)
    ,.pc(pc_out),.wdata(rt_out),.cause(cause),.rdata(cp0_out),.status(status_cp0/*??这个干嘛用的*/),.exc_addr(exc_addr));
/*
module CP0(
    input clk,
    input rst,
    input mfc0, // CPU instruction is Mfc0
    input mtc0, // CPU instruction is Mtc0
    input eret, // Instruction is ERET (Exception Return)
    //input intr, // Instruction which needs interuption
    input exception, //?whta's this ?
    //this
    input [4:0] Rd, // Specifies Cp0 register
    //pc
    input [31:0]pc,
    //rs or others,not control at least
    input [31:0]wdata, // Data from GP register to replace CP0 register
    //control
    input [4:0]cause,
    output [31:0] rdata, // Data from CP0 register for GP register
    output [31:0] status,
    //output reg timer_int,
    output reg [31:0]exc_addr // Address for PC at the beginning of an exception
);
*/


endmodule