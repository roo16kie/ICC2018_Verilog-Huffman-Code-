module huffman(clk, reset, gray_valid, gray_data, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid,M1, M2, M3, M4, M5, M6, HC1, HC2, HC3, HC4, HC5, HC6);

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output CNT_valid;
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output code_valid;
output reg[7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;

reg [13:0] MAX1,MAX2,MAX3,MAX4,MAX5,MAX6;
reg [2:0] counter ;
reg [3:0] ns , cs ;



wire [2:0] M_1 , M_2 , M_3 , M_4 , M_5 , M_6 ;
wire [7:0] check ;
reg change ;

parameter READ       = 4'd0 ;
parameter SORT1      = 4'd1 ;
parameter SORT2      = 4'd2 ;
parameter SORT3 	 = 4'd3 ;
parameter SORT4      = 4'd4 ;
parameter SORT5      = 4'd5 ;
parameter COMB1      = 4'd6 ;
parameter COMB2      = 4'd7 ;
parameter COMB3      = 4'd8 ;
parameter COMB4      = 4'd9 ;
parameter COMB5      = 4'd10;
parameter OUT1       = 4'd11;
parameter OUT2       = 4'd12;
parameter IDLE       = 4'd15;


assign CNT_valid  = (cs==OUT1) ;
assign code_valid = (cs==OUT2) ;

assign check = (CNT1 + CNT2) + ((CNT3 +CNT4) +(CNT5 +CNT6));
assign M_1 = ((M1[0]+M1[1])+(M1[2]+M1[3]))+((M1[4]+M1[5])+(M1[6]+M1[7])) ;
assign M_2 = ((M2[0]+M2[1])+(M2[2]+M2[3]))+((M2[4]+M2[5])+(M2[6]+M2[7])) ;
assign M_3 = ((M3[0]+M3[1])+(M3[2]+M3[3]))+((M3[4]+M3[5])+(M3[6]+M3[7])) ;
assign M_4 = ((M4[0]+M4[1])+(M4[2]+M4[3]))+((M4[4]+M4[5])+(M4[6]+M4[7])) ;
assign M_5 = ((M5[0]+M5[1])+(M5[2]+M5[3]))+((M5[4]+M5[5])+(M5[6]+M5[7])) ;
assign M_6 = ((M6[0]+M6[1])+(M6[2]+M6[3]))+((M6[4]+M6[5])+(M6[6]+M6[7])) ;
                                                                   
always@(posedge clk or posedge reset)
begin
	if(reset)
		change <= 0 ;
	else if(counter==3'd4)
		change <= 1 ;
	else
		change <= 0 ;
end



always@(posedge clk or posedge reset)
begin
	if(reset)
		counter <= 3'd0 ;
	else if(change)
		counter <= 3'd0 ;
	else if(ns==READ||ns==OUT1||ns==OUT2||ns==IDLE)
		counter <= 3'd0 ;	
	else 
		counter <= counter + 3'd1 ;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		cs <= READ ;
	else
		cs <= ns ;
end

always@(*)
begin
	case(cs)
	
	READ :if(check==8'd100) ns = SORT1 ; else ns = READ ;
	IDLE :			 ns = IDLE ;
    SORT1:if(change) ns = SORT2 ; else ns = SORT1 ; 
    SORT2:if(change) ns = SORT3 ; else ns = SORT2 ;
    SORT3:if(change) ns = SORT4 ; else ns = SORT3 ;
    SORT4:if(change) ns = SORT5 ; else ns = SORT4 ;
    SORT5:if(change) ns = COMB1 ; else ns = SORT5 ;
    COMB1:if(change) ns = COMB2 ; else ns = COMB1 ;
    COMB2:if(change) ns = COMB3 ; else ns = COMB2 ;
    COMB3:if(change) ns = COMB4 ; else ns = COMB3 ;
    COMB4:if(change) ns = COMB5 ; else ns = COMB4 ;
	COMB5:if(change) ns = OUT1  ; else ns = COMB5 ;
    OUT1  :			 ns = OUT2 ;
	OUT2  :          ns = IDLE ;
	
	default: ns = READ;
	
	endcase
end


always@(posedge clk or posedge reset)
begin
if(reset)
	begin
		CNT1 <= 8'd0 ;
		CNT2 <= 8'd0 ;
		CNT3 <= 8'd0 ;
		CNT4 <= 8'd0 ;
		CNT5 <= 8'd0 ;
		CNT6 <= 8'd0 ;
	end
else
	begin
		if(gray_valid)
		begin
			if(gray_data==8'd1)
				CNT1 = CNT1 + 8'd1 ;
			if(gray_data==8'd2)
				CNT2 = CNT2 + 8'd1 ;
			if(gray_data==8'd3)
				CNT3 = CNT3 + 8'd1 ;
			if(gray_data==8'd4)
				CNT4 = CNT4 + 8'd1 ;			
			if(gray_data==8'd5)
				CNT5 = CNT5 + 8'd1 ;
			if(gray_data==8'd6)
				CNT6 = CNT6 + 8'd1 ;
		end
	end
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
		MAX6 <= {6'b000001,8'b00000000} ;
		MAX5 <= {6'b000010,8'b00000000} ;
		MAX4 <= {6'b000100,8'b00000000} ;
		MAX3 <= {6'b001000,8'b00000000} ;
		MAX2 <= {6'b010000,8'b00000000} ;
		MAX1 <= {6'b100000,8'b00000000} ;
		end                 
	else if(gray_valid)
		begin
				MAX1[7:0] <= MAX1[7:0] + (gray_data==8'd1) ;
				MAX2[7:0] <= MAX2[7:0] + (gray_data==8'd2) ;
				MAX3[7:0] <= MAX3[7:0] + (gray_data==8'd3) ;
				MAX4[7:0] <= MAX4[7:0] + (gray_data==8'd4) ;			
				MAX5[7:0] <= MAX5[7:0] + (gray_data==8'd5) ;
				MAX6[7:0] <= MAX6[7:0] + (gray_data==8'd6) ;
		end
	else
	begin
	case(ns)
	SORT1:
		begin
			if(counter == 3'd0)
				if(MAX2[7:0]>MAX1[7:0])
				begin
				MAX1<=MAX2;
				MAX2<=MAX1;
				end
				else if(MAX2[7:0]==MAX1[7:0]&&MAX2[13:8]>MAX1[13:8])
				begin
				MAX1<=MAX2;
				MAX2<=MAX1;
				end
			if(counter == 3'd1)
				if(MAX3[7:0]>MAX1[7:0])
				begin
				MAX1<=MAX3;
				MAX3<=MAX1;
				end
				else if(MAX3[7:0]==MAX1[7:0]&&MAX3[13:8]>MAX1[13:8])
				begin
				MAX1<=MAX3;
				MAX3<=MAX1;
				end
			if(counter == 3'd2)
				if(MAX4[7:0]>MAX1[7:0])
				begin
				MAX1<=MAX4;
				MAX4<=MAX1;
				end
				else if(MAX4[7:0]==MAX1[7:0]&&MAX4[13:8]>MAX1[13:8])
				begin
				MAX1<=MAX4;
				MAX4<=MAX1;
				end
			if(counter == 3'd3)
				if(MAX5[7:0]>MAX1[7:0])
				begin
				MAX1<=MAX5;
				MAX5<=MAX1;
				end
				else if(MAX5[7:0]==MAX1[7:0]&&MAX5[13:8]>MAX1[13:8])
				begin
				MAX1<=MAX5;
				MAX5<=MAX1;
				end
			if(counter == 3'd4)
				if(MAX6[7:0]>MAX1[7:0])
				begin
				MAX1<=MAX6;
				MAX6<=MAX1;
				end
				else if(MAX6[7:0]==MAX1[7:0]&&MAX6[13:8]>MAX1[13:8])
				begin
				MAX1<=MAX6;
				MAX6<=MAX1;
				end
		end
	SORT2:
		begin
			if(counter == 3'd0)
				if(MAX3[7:0]>MAX2[7:0])
				begin
				MAX2<=MAX3;
				MAX3<=MAX2;
				end
				else if(MAX3[7:0]==MAX2[7:0]&&MAX3[13:8]>MAX2[13:8])
				begin
				MAX2<=MAX3;
				MAX3<=MAX2;
				end
			if(counter == 3'd1)
				if(MAX4[7:0]>MAX2[7:0])
				begin
				MAX2<=MAX4;
				MAX4<=MAX2;
				end
				else if(MAX4[7:0]==MAX2[7:0]&&MAX4[13:8]>MAX2[13:8])
				begin
				MAX2<=MAX4;
				MAX4<=MAX2;
				end
			if(counter == 3'd2)
				if(MAX5[7:0]>MAX2[7:0])
				begin
				MAX2<=MAX5;
				MAX5<=MAX2;
				end
				else if(MAX5[7:0]==MAX2[7:0]&&MAX5[13:8]>MAX2[13:8])
				begin
				MAX2<=MAX5;
				MAX5<=MAX2;
				end
			if(counter == 3'd3)
				if(MAX6[7:0]>MAX2[7:0])
				begin
				MAX2<=MAX6;
				MAX6<=MAX2;
				end
				else if(MAX6[7:0]==MAX2[7:0]&&MAX6[13:8]>MAX2[13:8])
				begin
				MAX2<=MAX6;
				MAX6<=MAX2;
				end
		end
	SORT3:
		begin
			if(counter == 3'd0)
				if(MAX4[7:0]>MAX3[7:0])
				begin
				MAX3<=MAX4;
				MAX4<=MAX3;
				end
				else if(MAX4[7:0]==MAX3[7:0]&&MAX4[13:8]>MAX3[13:8])
				begin
				MAX3<=MAX4;
				MAX4<=MAX3;
				end
			if(counter == 3'd1)
				if(MAX5[7:0]>MAX3[7:0])
				begin
				MAX3<=MAX5;
				MAX5<=MAX3;
				end
				else if(MAX5[7:0]==MAX3[7:0]&&MAX5[13:8]>MAX3[13:8])
				begin
				MAX3<=MAX5;
				MAX5<=MAX3;
				end
			if(counter == 3'd2)
				if(MAX6[7:0]>MAX3[7:0])
				begin
				MAX3<=MAX6;
				MAX6<=MAX3;
				end
				else if(MAX6[7:0]==MAX3[7:0]&&MAX6[13:8]>MAX3[13:8])
				begin
				MAX3<=MAX6;
				MAX6<=MAX3;
				end
		end
	SORT4:
		begin
			if(counter == 3'd0)
				if(MAX5[7:0]>MAX4[7:0])
				begin
				MAX4<=MAX5;
				MAX5<=MAX4;
				end
				else if(MAX5[7:0]==MAX4[7:0]&&MAX5[13:8]>MAX4[13:8])
				begin
				MAX4<=MAX5;
				MAX5<=MAX4;
				end
			if(counter == 3'd1)
				if(MAX6[7:0]>MAX4[7:0])
				begin
				MAX4<=MAX6;
				MAX6<=MAX4;
				end
				else if(MAX6[7:0]==MAX4[7:0]&&MAX6[13:8]>MAX4[13:8])
				begin
				MAX4<=MAX6;
				MAX6<=MAX4;
				end
		end
	SORT5:
		begin
			if(counter == 3'd0)
				if(MAX6[7:0]>MAX5[7:0])
				begin
				MAX5<=MAX6;
				MAX6<=MAX5;
				end
				else if(MAX6[7:0]==MAX5[7:0]&&MAX6[13:8]>MAX5[13:8])
				begin
				MAX5<=MAX6;
				MAX6<=MAX5;
				end
		end
	COMB1:
		begin
			if(counter == 3'd1)
			begin
				if(MAX4[7:0]<MAX5[7:0]+MAX6[7:0])
				begin
					MAX4 <= MAX5 + MAX6 ;
					MAX5 <= MAX4 ;
				end
				else
				begin
					MAX5 <= MAX5 + MAX6 ;
				end
			end
			if(counter == 3'd2)
			begin
				if(MAX3[7:0]<MAX4[7:0])
				begin
					MAX3 <= MAX4 ;
					MAX4 <= MAX3 ;
				end
			end
			if(counter==3'd3)
			begin
				if(MAX2[7:0]<MAX3[7:0])
				begin
					MAX2 <= MAX3 ;
					MAX3 <= MAX2 ;
				end
			end
			if(counter==3'd4)
			begin
				if(MAX1[7:0]<MAX2[7:0])
				begin
					MAX1 <= MAX2 ;
					MAX2 <= MAX1 ;
				end
			end
		end
	COMB2:
		begin
			if(counter == 3'd1)
			begin
				if(MAX3[7:0]<MAX4[7:0]+MAX5[7:0])
				begin
					MAX3 <= MAX4 + MAX5 ;
					MAX4 <= MAX3 ;
				end
				else
				begin
					MAX4 <= MAX4 + MAX5 ;
				end
			end
			if(counter == 3'd2)
			begin
				if(MAX2[7:0]<MAX3[7:0])
				begin
					MAX2 <= MAX3 ;
					MAX3 <= MAX2 ;
				end
			end
			if(counter==3'd3)
			begin
				if(MAX1[7:0]<MAX2[7:0])
				begin
					MAX1 <= MAX2 ;
					MAX2 <= MAX1 ;
				end
			end
		end
	COMB3:
		begin
			if(counter == 3'd1)
			begin
				if(MAX2[7:0]<MAX3[7:0]+MAX4[7:0])
				begin
					MAX2 <= MAX3 + MAX4 ;
					MAX3 <= MAX2 ;
				end
				else
				begin
					MAX3 <= MAX3 + MAX4 ;
				end
			end
			if(counter == 3'd2)
			begin
				if(MAX1[7:0]<MAX2[7:0])
				begin
					MAX1 <= MAX2 ;
					MAX2 <= MAX1 ;
				end
			end
		end
	COMB4:
		begin
			if(counter == 3'd1)
			begin
				if(MAX1[7:0]<MAX2[7:0]+MAX3[7:0])
				begin
					MAX1 <= MAX2 + MAX3 ;
					MAX2 <= MAX1 ;
				end
				else
				begin
					MAX2 <= MAX2 + MAX3 ;
				end
			end
		end
	endcase
end
end

always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
		HC1 <= 8'd0 ;HC2 <= 8'd0 ;HC3 <= 8'd0 ;HC4 <= 8'd0 ;HC5 <= 8'd0 ;HC6 <= 8'd0 ;
	end
	else if(counter==3'd0)
	begin
	if(ns==COMB1)
	begin
		if(MAX6[8]==1)
			HC6[0] <= 1 ;
		if(MAX6[9]==1)
			HC5[0] <= 1 ;
		if(MAX6[10]==1)
			HC4[0] <= 1 ;
		if(MAX6[11]==1)
			HC3[0] <= 1 ;
		if(MAX6[12]==1)
			HC2[0] <= 1 ;
		if(MAX6[13]==1)
			HC1[0] <= 1 ;
			
		if(MAX5[8]==1)
			HC6[0] <= 0 ;
		if(MAX5[9]==1)
			HC5[0] <= 0 ;
		if(MAX5[10]==1)
			HC4[0] <= 0 ;
		if(MAX5[11]==1)
			HC3[0] <= 0 ;
		if(MAX5[12]==1)
			HC2[0] <= 0 ;
		if(MAX5[13]==1)
			HC1[0] <= 0 ;
	end
	
	if(ns==COMB2)
	begin
		if(MAX5[8]==1)
			if(M6[0]==1)
				HC6[1] <= 1 ;
			else
				HC6[0] <= 1 ;
		if(MAX5[9]==1)
			if(M5[0]==1)
				HC5[1] <= 1 ;
			else
				HC5[0] <= 1 ;
		if(MAX5[10]==1)
			if(M4[0]==1)
				HC4[1] <= 1 ;
			else
				HC4[0] <= 1 ;
		if(MAX5[11]==1)
			if(M3[0]==1)
				HC3[1] <= 1 ;
			else
				HC3[0] <= 1 ;
		if(MAX5[12]==1)
			if(M2[0]==1)
				HC2[1] <= 1 ;
			else
				HC2[0] <= 1 ;
		if(MAX5[13]==1)
			if(M1[0]==1)
				HC1[1] <= 1 ;
			else
				HC1[0] <= 1 ;
				
		if(MAX4[8]==1)
			if(M6[0]==1)
				HC6[1] <= 0 ;
			else
				HC6[0] <= 0 ;
		if(MAX4[9]==1)
			if(M5[0]==1)
				HC5[1] <= 0 ;
			else
				HC5[0] <= 0 ;
		if(MAX4[10]==1)
			if(M4[0]==1)
				HC4[1] <= 0 ;
			else
				HC4[0] <= 0 ;
		if(MAX4[11]==1)
			if(M3[0]==1)
				HC3[1] <= 0 ;
			else
				HC3[0] <= 0 ;
		if(MAX4[12]==1)
			if(M2[0]==1)
				HC2[1] <= 0 ;
			else
				HC2[0] <= 0 ;
		if(MAX4[13]==1)
			if(M1[0]==1)
				HC1[1] <= 0 ;
			else
				HC1[0] <= 0 ;
	end
	
	if(ns==COMB3)
	begin
		if(MAX4[8]==1)
			HC6[M_6] <= 1 ;
		if(MAX4[9]==1)
			HC5[M_5] <= 1 ;
		if(MAX4[10]==1)
			HC4[M_4] <= 1 ;
		if(MAX4[11]==1)
			HC3[M_3] <= 1 ;
		if(MAX4[12]==1)
			HC2[M_2] <= 1 ;
		if(MAX4[13]==1)
			HC1[M_1] <= 1 ;
			
		if(MAX3[8]==1)
			HC6[M_6] <= 0 ;
		if(MAX3[9]==1)
			HC5[M_5] <= 0 ;
		if(MAX3[10]==1)
			HC4[M_4] <= 0 ;
		if(MAX3[11]==1)
			HC3[M_3] <= 0 ;
		if(MAX3[12]==1)
			HC2[M_2] <= 0 ;
		if(MAX3[13]==1)
			HC1[M_1] <= 0 ;	
	end
	
	if(ns==COMB4)
	begin
		if(MAX3[8]==1)
			HC6[M_6] <= 1 ;
		if(MAX3[9]==1)
			HC5[M_5] <= 1 ;
		if(MAX3[10]==1)
			HC4[M_4] <= 1 ;
		if(MAX3[11]==1)
			HC3[M_3] <= 1 ;
		if(MAX3[12]==1)
			HC2[M_2] <= 1 ;
		if(MAX3[13]==1)
			HC1[M_1] <= 1 ;
			
		if(MAX2[8]==1)
			HC6[M_6] <= 0 ;
		if(MAX2[9]==1)
			HC5[M_5] <= 0 ;
		if(MAX2[10]==1)
			HC4[M_4] <= 0 ;
		if(MAX2[11]==1)
			HC3[M_3] <= 0 ;
		if(MAX2[12]==1)
			HC2[M_2] <= 0 ;
		if(MAX2[13]==1)
			HC1[M_1] <= 0 ;	
	end
	
	if(ns==COMB5)
	begin
		if(MAX2[8]==1)
			HC6[M_6] <= 1 ;
		if(MAX2[9]==1)
			HC5[M_5] <= 1 ;
		if(MAX2[10]==1)
			HC4[M_4] <= 1 ;
		if(MAX2[11]==1)
			HC3[M_3] <= 1 ;
		if(MAX2[12]==1)
			HC2[M_2] <= 1 ;
		if(MAX2[13]==1)
			HC1[M_1] <= 1 ;
			
		if(MAX1[8]==1)
			HC6[M_6] <= 0 ;
		if(MAX1[9]==1)
			HC5[M_5] <= 0 ;
		if(MAX1[10]==1)
			HC4[M_4] <= 0 ;
		if(MAX1[11]==1)
			HC3[M_3] <= 0 ;
		if(MAX1[12]==1)
			HC2[M_2] <= 0 ;
		if(MAX1[13]==1)
			HC1[M_1] <= 0 ;	
	end
	
	end
end

always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
		M1 <= 8'd0 ;
		M2 <= 8'd0 ;
		M3 <= 8'd0 ;
		M4 <= 8'd0 ;
		M5 <= 8'd0 ;
		M6 <= 8'd0 ;
	end
	else if(counter==3'd0)
	begin
		case(ns)
			COMB1:	begin
						if(MAX6[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX6[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX6[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX6[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX6[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX6[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
							
						if(MAX5[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX5[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX5[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX5[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX5[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX5[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
					end
			COMB2:	begin
						if(MAX5[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX5[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX5[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX5[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX5[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX5[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
							
						if(MAX4[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX4[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX4[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX4[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX4[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX4[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
					end
			COMB3:
				begin
						if(MAX4[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX4[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX4[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX4[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX4[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX4[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
							
						if(MAX3[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX3[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX3[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX3[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX3[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX3[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
				end
			COMB4:
				begin
						if(MAX2[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX2[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX2[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX2[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX2[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX2[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
							
						if(MAX3[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX3[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX3[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX3[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX3[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX3[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
				end
			COMB5:
				begin
						if(MAX2[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX2[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX2[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX2[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX2[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX2[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
							
						if(MAX1[8]==1)
							M6 <= (M6 << 1) + 8'd1 ;
						if(MAX1[9]==1)
							M5 <= (M5 << 1 ) + 8'd1 ;
						if(MAX1[10]==1)
							M4 <= (M4 << 1 ) + 8'd1 ;
						if(MAX1[11]==1)
							M3 <= (M3 << 1 ) + 8'd1 ;
						if(MAX1[12]==1)
							M2 <= (M2 << 1 ) + 8'd1 ;
						if(MAX1[13]==1)
							M1 <= (M1 << 1 ) + 8'd1 ;
				end
		endcase
	end
end












  
endmodule

