
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
    parameter bit32_=2'b00;
    parameter bit16_=2'b01;
    parameter bit8_=2'b10;

    //这里@的部分削掉了一块，不知道会不会有问题
    always @(*) begin
        if(MEM_W) begin
        // 写入
            case (MEM_C)
            //这里没有指令的合法性判断
                bit32_:
                    memory[ iAddr]<= iData[31:24];
                    memory[ iAddr+ 1]<= iData[23:16];
                    memory[ iAddr+ 2]<= iData[15:8];
                    memory[ iAddr+ 3]<= iData[7:0];    
                bit16_:
                    memory[ iAddr]<= iData[15:8];
                    memory[ iAddr+ 1]<= iData[7:0];
                bit8_:
                    memory[ iAddr]<= iData[7:0];
        end     
        else if (MEM_R)begin
            case (MEM_C)
                bit32_:
                    memory[ iAddr]<= iData[31:24];
                    memory[ iAddr+ 1]<= iData[23:16];
                    memory[ iAddr+ 2]<= iData[15:8];
                    memory[ iAddr+ 3]<= iData[7:0];    
                bit16_:
                    if(MEM_S)begin
                        odata<={memory[ iAddr][7]{16},memory[ iAddr],memory[ iAddr+ 1]};
                    end
                    else begin
                        odata<={0{16},memory[ iAddr],memory[ iAddr+ 1]} ;
                    end
                bit8_:
                    if(MEM_S)begin
                        odata<={memory[ iAddr][7]{24},memory[iAddr]} ;
                    end
                    else begin
                        odata<={0{24},memory[ iAddr]};
                    end
        end
    end    

endmodule