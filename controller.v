module CONTROLLER(
    input [31:0]instr,
    input clk,
    input alu_Z,
    input alu_C,
    input alu_N,
    input alu_O,
    input reset,   

/*
    there are output for controlling ,38bits with 9bits cp0
    alu 9bits with mdu 7bits  won't be used together 
*/ 
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
//    output Rs_r,
//    output Rt_r,

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

//编码参数部分
 parameter 
    CALCU_CODE = 000000,
    INBREAK_CODE = 010000,
    MULT_OP_CODE = 011100,

    SLL_CODE = 000000,
    SRL_CODE = 000010,
    SRA_CODE = 000011,
    SLLV_CODE = 000100,
    SRLV_CODE = 000110,
    SRAV_CODE = 000111,

    JR_CODE = 001000,
    JALR_CODE = 001001,
    SYSCALL_CODE = 001100,
    BREAK_CODE = 001101,

    MFHI_CODE = 010000,
    MFLO_CODE = 010010,
    MTHI_CODE = 010001,
    MTLO_CODE = 010011,

    MULTU_CODE = 011001,
    MULT_CODE = 011000,
    DIV_CODE = 011010,
    DIVU_CODE = 011011,

    ADD_CODE = 100000,
    ADDU_CODE = 100001,
    SUB_CODE = 100010,
    SUBU_CODE = 100011,
    AND_CODE = 100100,
    OR_CODE = 100101,
    XOR_CODE = 100110,
    NOR_CODE = 100111,
    SLT_CODE = 101010,
    SLTU_CODE = 101011,

    TEQ_CODE = 110100,

    ERET_CODE = 011000,
    MTC0_CODE = 00000,
    MFC0_CODE = 00100,
  
    MUL_CODE= 000010,
    CLZ_CODE = 100000,       

    BGEZ_CODE = 000001,
    J_CODE = 000010,
    JAL_CODE = 000011,
    BEQ_CODE = 000100,
    BNE_CODE = 000101,
  
    ADDI_CODE = 001000,
    ADDIU_CODE = 001001,
    SLTI_CODE = 001010,
    SLTIU_CODE = 001011,
    ANDI_CODE = 001100,
    ORI_CODE = 001101,
    XORI_CODE = 001110,
    LUI_CODE = 001111,

    LB_CODE = 100000,
    LH_CODE = 100001,
    LW_CODE = 100011,
    LBU_CODE = 100100,
    LHU_CODE = 100101,

    SB_CODE = 101000,
    SW_CODE = 101011,
    SH_CODE = 101001;


wire [5:0]op,rsc,rtc,rdc,shamt,func;
wire SLL,SRL,SRA,SLLV,SRLV,SRAV,JR,JALR,SYSCALL,BREAK,MFHI,MFLO,
    MTHI,MTLO,MULTU,DIV,DIVU,ADD,ADDU,SUB,SUBU,AND,OR,XOR,NOR,
    SLT,SLTU,TEQ,ERET,MTC0,MFC0,MULT,CLZ,BGEZ,J,JAL,BEQ,BNE,
    ADDI,ADDIU,SLTI,SLTIU,ANDI,ORI,XORI,LUI,LB,LH,LW,LBU,LHU,SB,SW,SH;

    assign op[5:0]= inst[31:26];
    assign rsc[5:0]= inst[25:21];
    assign rtc[5:0]= inst[20:16];
    assign rdc[5:0]= inst[15:11];
    assign shamt[5:0]= inst[10:6];
    assign func[5:0]= inst[5:0];

//编码转换成指令信号部分
    assign SLL = ((op == CALCU_CODE )&& ( func == SLL_CODE )) ? 1 : 0;
    assign SRL = ((op == CALCU_CODE )&& ( func == SRL_CODE )) ? 1 : 0;
    assign SRA = ((op == CALCU_CODE )&& ( func == SRA_CODE )) ? 1 : 0;
    assign SLLV = ((op == CALCU_CODE )&& ( func == SLLV_CODE )) ? 1 : 0;
    assign SRLV = ((op == CALCU_CODE )&& ( func == SRLV_CODE )) ? 1 : 0;
    assign SRAV = ((op == CALCU_CODE )&& ( func == SRAV_CODE )) ? 1 : 0;

    assign JR = ((op == CALCU_CODE )&& ( func == JR_CODE )) ? 1 : 0;
    assign JALR = ((op == CALCU_CODE )&& ( func == JALR_CODE )) ? 1 : 0;
    assign SYSCALL = ((op == CALCU_CODE )&& ( func == SYSCALL_CODE )) ? 1 : 0;
    assign BREAK = ((op == CALCU_CODE )&& ( func == BREAK_CODE )) ? 1 : 0;

    assign MFHI = ((op == CALCU_CODE )&& ( func == MFHI_CODE )) ? 1 : 0;
    assign MFLO = ((op == CALCU_CODE )&& ( func == MFLO_CODE )) ? 1 : 0;
    assign MTHI = ((op == CALCU_CODE )&& ( func == MTHI_CODE )) ? 1 : 0;
    assign MTLO = ((op == CALCU_CODE )&& ( func == MTLO_CODE )) ? 1 : 0;

    assign MULTU = ((op == CALCU_CODE )&& ( func == MULTU_CODE )) ? 1 : 0;
    assign MULT=((op == CALCU_CODE )&& ( func ==  MULT_CODE)) ? 1 : 0;
    assign DIV = ((op == CALCU_CODE )&& ( func == DIV_CODE )) ? 1 : 0;
    assign DIVU = ((op == CALCU_CODE )&& ( func == DIVU_CODE )) ? 1 : 0;

    assign ADD = ((op == CALCU_CODE )&& ( func == ADD_CODE )) ? 1 : 0;
    assign ADDU = ((op == CALCU_CODE )&& ( func == ADDU_CODE )) ? 1 : 0;
    assign SUB = ((op == CALCU_CODE )&& ( func == SUB_CODE )) ? 1 : 0;
    assign SUBU = ((op == CALCU_CODE )&& ( func == SUBU_CODE )) ? 1 : 0;
    assign AND = ((op == CALCU_CODE )&& ( func == AND_CODE )) ? 1 : 0;
    assign OR = ((op == CALCU_CODE )&& ( func == OR_CODE )) ? 1 : 0;
    assign XOR = ((op == CALCU_CODE )&& ( func == XOR_CODE )) ? 1 : 0;
    assign NOR = ((op == CALCU_CODE )&& ( func == NOR_CODE )) ? 1 : 0;
    assign SLT = ((op == CALCU_CODE )&& ( func == SLT_CODE )) ? 1 : 0;
    assign SLTU = ((op == CALCU_CODE )&& ( func == SLTU_CODE )) ? 1 : 0;

    assign TEQ = ((op == CALCU_CODE )&& ( func ==  TEQ_CODE)) ? 1 : 0;

    assign ERET=((op == INBREAK_CODE )&& ( func ==  ERET_CODE)) ? 1 : 0; 
    assign MTC0=((op == INBREAK_CODE )&& ( rsc ==  MTC0_CODE)) ? 1 : 0; 
    assign MFC0=((op == INBREAK_CODE )&& ( rsc ==  MFC0_CODE)) ? 1 : 0;    
    
    assign MUL=((op == MULT_OP_CODE )&& ( func ==  MUL_CODE)) ? 1 : 0;
    assign CLZ=((op == MULT_OP_CODE )&& ( func ==  CLZ_CODE)) ? 1 : 0;          

    assign BGEZ=(op ==BGEZ_CODE)? 1 : 0;
    assign J=(op ==J_CODE)? 1 : 0;
    assign JAL=(op ==JAL_CODE)? 1 : 0;
    assign BEQ=(op ==BEQ_CODE)? 1 : 0;
    assign BNE=(op ==BNE_CODE)? 1 : 0;
    
    assign ADDI=(op ==ADDI_CODE)? 1 : 0;
    assign ADDIU=(op ==ADDIU_CODE)? 1 : 0;
    assign SLTI=(op ==SLTI_CODE)? 1 : 0;
    assign SLTIU=(op ==SLTIU_CODE)? 1 : 0;
    assign ANDI=(op ==ANDI_CODE)? 1 : 0;
    assign ORI=(op ==ORI_CODE)? 1 : 0;
    assign XORI=(op ==XORI_CODE)? 1 : 0;
    assign LUI=(op ==LUI_CODE)? 1 : 0;

    assign LB=(op ==LB_CODE)? 1 : 0;
    assign LH=(op ==LH_CODE)? 1 : 0;
    assign LW=(op ==LW_CODE)? 1 : 0;
    assign LBU=(op ==LBU_CODE)? 1 : 0;
    assign LHU=(op ==LHU_CODE)? 1 : 0;

    assign SB=(op ==SB_CODE)? 1 : 0;
    assign SW=(op ==SW_CODE)? 1 : 0;
    assign SH=(op ==SH_CODE)? 1 : 0;

//指令信号转化成控制信号的部分
//试用一下布尔控制
    reg T1,T2,T3,T4,T5;
    
    always @(posedge clk)begin
        if(reset)begin
            T1<=1;
            T2<=0;
            T3<=0;
            T4<=0;
            T5<=0;
        end
        else if(T1)begin
            T1<=0;
            T2<=1;
            T3<=0;
            T4<=0;
            T5<=0;
        end
        else if(T2)begin
            T1<=0;
            T2<=0;
            T3<=1;
            T4<=0;
            T5<=0;
        end
        else if(T3)begin
            T1<=(BREAK||SYSCALL||ERET||MFC0||MTC0||MFHI||MFLO||DIV||DIVU||MULT||MULTU||MUL||J||~(BEQ&&alu_Z==0)||~(BNE&&alu_Z!=0)||~(BGEZ&&alu_Z==0)||(TEQ&&alu_Z==0))?1:0;
            T2<=0;
            T3<=0;
            T4<=(BREAK||SYSCALL||ERET||MFC0||MTC0||MFHI||MFLO||DIV||DIVU||MULT||MULTU||MUL||J||~(BEQ&&alu_Z==0)||~(BNE&&alu_Z!=0)||~(BGEZ&&alu_Z==0)||~(TEQ&&alu_Z==0))?0:1;
            T5<=0;
        end
        else if(T4)begin
            T1<=(BEQ||BNE||BGEZ||JALR)?0:1;
            T2<=0;
            T3<=0;
            T4<=0;
            T5<=(BEQ||BNE||BGEZ||JALR)?1:0;
        end
        else if(T5)begin
            T1<=1;
            T2<=0;
            T3<=0;
            T4<=0;
            T5<=0;
        end
    end


    assign S=T3&(SW|SH|SB|LBU|LHU|LW|LB|LH|LW);
    assign M_pc[0]=T2 || (T4&JR) || (T5&(BNE|BEQ|BGEZ|JALR));
    assign M_pc[1]=T3&(BREAK|SYSCALL|ERET) || (T4&TEQ);
    assign PC_in=T2 || T3&(J|BREAK|SYSCALL|ERET) || T4&(JAL|JR|TEQ) || T5&(BNE|BEQ|BGEZ|JALR);
    assign PC_out= T1;
    assign Y_in=T1 || T3&(ADDU|ADD|SUBU|SUB|AND|OR|XOR|NOR|SLT|SLTU|SLLV|SRLV|SRAV|SRL|SRA|SLL|ADDI|ADDIU|ANDI|ORI|XORI|SLTI|SLTIU|LUI|SW|SH|SB|LBU|LHU|LW|LB|LH|LW|BNE|BEQ|BGEZ|JR|TEQ) || T4&(BNE|BEQ|BGEZ);
    assign Y_out=T2 || T3&(JAL|JALR) || T4&((ADDU|ADD|SUBU|SUB|AND|OR|XOR|NOR|SLT|SLTU|SLLV|SRLV|SRAV|SRL|SRA|SLL|ADDI|ADDIU|ANDI|ORI|XORI|SLTI|SLTIU|LUI|SW|SH|SB|LBU|LHU|LW|LB|LH|LW|JR) || T5&(BNE|BEQ|BGEZ|JALR);
    assign M_mem=T4&(SW|SH|SB|LBU|LHU|LW|LB|LH|LW);
    assign MEM_w=T4&(SW|SH|SB);
    assign MEM_r=T1 || T4&(LBU|LHU|LW|LB|LH|LW);
    assign MEM_S=T4&(LBU|LHU);
    assign MEM_C[0]=T4&(SH|LHU|LH);
    assign MEM_C[1]=T4&(SB|LBU|LB);
    assign M_A[0]=T1 || T4&(BNE|BEQ|BGEZ);
    assign M_A[1]=T3&(ADDU|ADD|SUBU|SUB|AND|OR|XOR|NOR|SLT|SLTU|SLLV|SRLV|SRAV|ADDI|ADDIU|ANDI|ORI|XORI|SLTI|SLTIU|LUI|SW|SH|SB|LBU|LHU|LW|LB|LH|LW|BNE|BEQ|BGEZ|JR|TEQ) || T4&JALR;
    assign M_B[0]=T1 || T3&(ADDI|ADDIU|ANDI|ORI|XORI|SLTI|SLTIU|LUI|SW|SH|SB|LBU|LHU|LW|LB|LH|LW);
    assign M_B[1]=T1 || T4&(BNE|BEQ|BGEZ);
    assign M_B[2]=T3&(BGEZ|JR) ||T4&JALR;
    assign ALUC[0]=T3&((BGEZ)|(BNE|BEQ|TEQ)|SUB|SUBU|OR|ORI|NOR|SLT|SLTI|SRL|SRLV);
    assign ALUC[1]=T1 ||T3&((BNE|BEQ|TEQ)|(SW|SH|SB|LBU|LHU|LW|LB|LH|LW|JR)|ADD|ADDI|SUB|XOR|NOR|SLT|SLTI|SLTU|SLTIU|SLL|SLLV) || T4&(BNE|BEQ|BGEZ|JALR);
    assign ALUC[2]=T3&((BGEZ)|AND|ANDI|OR|ORI|XOR|XORI|NOR|SLL|SLLV|SRL|SRLV|SRA|SRAV);
    assign ALUC[3]=T3&((BGEZ)|LUI|SLT|SLTI|SLTU|SLTIU|SLL|SLLV|SRL|SRLV|SRA|SRAV);
    assign M_rdc[0]=T3&(MFC0|MTC0) || T4&(SW|SH|SB);
    assign M_rdc[1]=T3&(JAL|JALR);
    assign M_rd[0]=T3&(MTC0|MFLO) || T4&(SW|SH|SB|LBU|LHU|LW|LB|LH|LW|CLZ|MUL);
    assign M_rd[1]=T3&(MFC0|MFLO) || T4&MUL;
    assign M_rd[2]=T3&MFHI || T4&CLZ;
    assign Rd_w=T3&(JAL|JALR|CLZ|MFC0|MFHI|MFLO) || T4&(ADDU|ADD|SUBU|SUB|AND|OR|XOR|NOR|SLT|SLTU|SLLV|SRLV|SRAV|SRL|SRA|SLL|ADDI|ADDIU|ANDI|ORI|XORI|SLTI|SLTIU|LUI|LBU|LHU|LW|LB|LH|LW|CLZ);
    //assign Rs_r=
    //assign Rt_r=
    assign M_lo=T3&MTLO;
    assign M_hi=T3&MTHI;
    assign LO_w=T3&(MTLO|DIV|DIVU|MUL|MULT|MULTU);
    assign HI_w=T3&(MTHI|DIV|DIVU|MUL|MULT|MULTU);
    assign S_mdu=T3&(DIV|MULT|MUL);
    assign MUL_C=T3&(MULT|MULTU|MUL);
    assign DIV_C=T3&(DIV|DIVU);
    assign IR_in=T1;

    assign mfc0= T3&MFC0;
    assign mtc0= T3&MTC0;
    assign eret= T3&ERET;
    assign exception= T3&(SYSCALL|BREAK) || T4&TEQ;
    assign [4:0]cause=(BREAK)?5'b01001 :(
                      (TEQ)?5'b01101 :(
                          (SYSCALL)?5'b01000 : 5'b00000
                      ));


endmodule
