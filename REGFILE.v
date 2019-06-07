
module regfile(
    input clk,          //下降沿有效
    input rst,         //高位有效
    input we,          //使能信号，高位有效
    input [4:0] raddr1,           //目标寄存器地址1
    input [4:0] raddr2,           //目标寄存器地址2
    input [4:0] waddr,       //写入的地址
    input [31:0] wdata,      //写入的数据
    output [31:0] rdata1,   //读出的数据
    output [31:0] rdata2    //读出的数据
    );
    
    reg [31:0] array_reg [31:0]; ///数组顺序有影响吗<————！
    integer i;
    
  
  /*
    initial begin
        i= 0;
        repeat( 32) begin
            array_reg[i]<= 0;
            i= i+ 1;
        end
    end
    */

    //写入寄存器
    always @( negedge clk, negedge rst) begin
        if(rst==1)begin//高位有效<1R>
            i= 0;
            repeat( 32) begin
                array_reg[i]<= 0;
                i= i+ 1;
            end
        end
        else begin
        //$0恒为0，所以不能对rf[0]进行写入
        if( we && waddr!= 0)
            array_reg[ waddr]<= wdata;
        end
    end

    //读取寄存器
    assign rdata1= array_reg[ raddr1]; //rs
    assign rdata2= array_reg[ raddr2]; //rt

endmodule