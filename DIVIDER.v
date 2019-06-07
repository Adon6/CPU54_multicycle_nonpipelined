/*
新的时钟=k/N 单位赫兹
*/
module divider #(parameter N = 20)(iCLK, oCLK);
    input iCLK;
    output reg oCLK;
    
    //initial oCLK=0;
	integer counter=0;
    
	always@(posedge iCLK) begin

		if(counter==N/2-1) begin
			counter='b0;
			oCLK=~oCLK;
		end
		else begin
			counter=counter+'b1;
		end
	end
endmodule