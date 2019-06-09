
//读写存储器
module MEM(
    input MEM_W,//<1W>
    input MEM_R,//<1R>
    input MEM_S,
    input [1:0]MEM_C,
    input [31:0] iAddr,
    input [31:0] iData,    
    output reg [31:0] oData
    );
    
    reg [7:0] memory[1023:0];
/*
    integer i;
    
    initial begin
        i= 0;
        repeat( 1024) begin
            memory[i]<= 0;  
            i= i+1;
        end
    end
    */
        initial begin
       $readmemh("C:\\Users\\admin\\Desktop\\54CPUtest\\1_addi.hex.txt", memory);
    end


    parameter bit32_=2'b00;
    parameter bit16_=2'b01;
    parameter bit8_=2'b10;

    //这里@的部分削掉了一块，不知道会不会有问题
    always @(*) begin
        if(MEM_W) begin
        // 写入
            case (MEM_C)
            //这里没有指令的合法性判断
                bit32_:begin
                    memory[ iAddr]<= iData[31:24];
                    memory[ iAddr+ 1]<= iData[23:16];
                    memory[ iAddr+ 2]<= iData[15:8];
                    memory[ iAddr+ 3]<= iData[7:0];   
                    end
                bit16_:begin
                    memory[ iAddr]<= iData[15:8];
                    memory[ iAddr+ 1]<= iData[7:0];
                    end
                bit8_:begin
                    memory[ iAddr]<= iData[7:0];
                    end
                default:;
            endcase
        end     
        else if (MEM_R)begin
            case (MEM_C)
                bit32_:begin
                    oData<={memory[ iAddr],memory[ iAddr+ 1],memory[ iAddr+2],memory[ iAddr+ 3]};
                    end
                bit16_:begin
                        if(MEM_S&&memory[iAddr][7]==1)begin

                            oData<={{1{16}},memory[ iAddr],memory[ iAddr+ 1]};
                        end
                        else begin
                            oData<={{0{16}},memory[ iAddr],memory[ iAddr+ 1]} ;
                        end
                    end
                bit8_:begin
                        if(MEM_S&&memory[iAddr][7]==1)begin
                            oData<={{1{24}},memory[iAddr]} ;
                        end
                        else begin
                            oData<={{0{24}},memory[ iAddr]};
                        end
                    end
                default:;
            endcase
        end
    end    

endmodule




//读写存储器
module MEM32(
    input MEM_W,//<1W>
    input MEM_R,//<1R>
    input MEM_S,
    input [1:0]MEM_C,
    input [31:0] iAddr,
    input [31:0] iData,    
    output reg [31:0] oData
    );
    
    reg [31:0] memory[128:0];
/*
    integer i;
    
    initial begin
        i= 0;
        repeat( 1024) begin
            memory[i]<= 0;  
            i= i+1;
        end
    end
    */
        initial begin
       $readmemh("C:\\Users\\admin\\Desktop\\54CPUtest\\1_addi.hex.txt", memory);
    end

    reg [31:0] readreg;

    parameter bit32_=2'b00;
    parameter bit16_=2'b01;
    parameter bit8_=2'b10;

    //这里@的部分削掉了一块，不知道会不会有问题
    always @(*) begin
        if(MEM_W) begin
        // 写入
            case (MEM_C)
            //这里没有指令的合法性判断
                bit32_:begin
                    memory[ iAddr[31:2]]<= iData;
                    end
                bit16_:begin
                    case(iAddr[1])
                        1'b1:memory[ iAddr[31:2]][31:16]<= iData[15:0];
                        1'b0:memory[ iAddr[31:2]][15:0]<= iData[15:0];
                        default:;
                    endcase
                    end
                bit8_:begin
                    case(iAddr[1:0])
                        2'b11:memory[ iAddr[31:2]][31:24]<= iData[7:0];
                        2'b10:memory[ iAddr[31:2]][23:16]<= iData[7:0];
                        2'b01:memory[ iAddr[31:2]][15:8]<= iData[7:0];
                        2'b00:memory[ iAddr[31:2]][7:0]<= iData[7:0];
                        default:;
                    endcase
                    end
                default:;
            endcase
        end     
        else if (MEM_R)begin
            case (MEM_C)
                bit32_:begin
                    oData<=memory[iAddr[31:2]];
                    end
                bit16_:begin
                        case(iAddr[1])
                        1'b1:readreg[15:0]<=memory[ iAddr[31:2]][31:16];
                        1'b0:readreg[15:0]<=memory[ iAddr[31:2]][15:0];
                        default:;
                        endcase    
                        if(MEM_S&&readreg[15]==1)
                            oData<={{1{16}},readreg[15:0]};
                        else
                            oData<={{0{16}},readreg[15:0]};

                    end

                bit8_:begin
                    case(iAddr[1:0])
                        2'b11:readreg[7:0]<=memory[ iAddr[31:2]][31:24];
                        2'b10:readreg[7:0]<=memory[ iAddr[31:2]][23:16];
                        2'b01:readreg[7:0]<=memory[ iAddr[31:2]][15:8];
                        2'b00:readreg[7:0]<=memory[ iAddr[31:2]][7:0];
                        default:;
                    endcase
                        if(MEM_S&&readreg[7]==1)
                            oData<={{1{24}},readreg[7:0]};
                        else
                            oData<={{0{24}},readreg[7:0]};

                    end

                default:;
            endcase
        end
    end    

endmodule
