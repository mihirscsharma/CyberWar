module victory (
    input logic clk, reset,
    input logic LED9, LED1, L, R,
    output logic [6:0] HEX0, HEX5,
    output logic res);
	 
    logic [2:0] PLAYER;
    logic [2:0] COMP;
    enum {off, P1, P2} ps, ns;

    
    always_comb begin
			if (ps == off) begin 
				if ((LED1 & R & ~L)) 
					ns = P1;
			   else if ((LED9 & L & ~R))
					ns = P2;
			   else 
					ns = off;
			end else if (ps == P1) begin
					ns = (LED1 & R & ~L) ? P1 : off;
			end else begin // if (ps == P2)
					ns = (LED9 & L & ~R) ? P2 : off;
			end

        
        case (PLAYER)
            3'b000: HEX0 = 7'b1000000; // 0
            3'b001: HEX0 = 7'b1111001; // 1
            3'b010: HEX0 = 7'b0100100; // 2
            3'b011: HEX0 = 7'b0110000; // 3
            3'b100: HEX0 = 7'b0011001; // 4
            3'b101: HEX0 = 7'b0010010; // 5
            3'b110: HEX0 = 7'b0000010; // 6
            default: HEX0 = 7'b1111000; // 7
        endcase
        
       
        case (COMP)
            3'b000: HEX5 = 7'b1000000; // 0
            3'b001: HEX5 = 7'b1111001; // 1
            3'b010: HEX5 = 7'b0100100; // 2
            3'b011: HEX5 = 7'b0110000; // 3
            3'b100: HEX5 = 7'b0011001; // 4
            3'b101: HEX5 = 7'b0010010; // 5
            3'b110: HEX5 = 7'b0000010; // 6
            default: HEX5 = 7'b1111000; // 7
        endcase
    end

   
    always_ff @(posedge clk) begin
        if (reset) begin
            COMP <= 3'b000;
            PLAYER <= 3'b000;
            ps <= off;
            res <= 0;
        end else begin
            case (ps)
                off: begin
                    if (ns == P1) begin
								if (PLAYER < 7)
                        PLAYER <= PLAYER + 1;
                    end else if (ns == P2) begin
								if (COMP < 7)
                        COMP <= COMP + 1;
                    end
                end
                default: begin
                    PLAYER <= PLAYER;
                    COMP <= COMP;
						  res <= 0;
                end
            endcase

            if (ns == P1 || ns == P2) begin
                res <= 1;
            end else begin
                res <= 0;
            end
            
            ps <= ns;
        end
    end

endmodule

 


module victory_testbench ();

    logic clk, reset, L, R, LED9, LED1;
    logic [6:0] winner;

    
    victory dut (.clk(clk),.reset(reset),.LED9(LED9),.LED1(LED1),.L(L),.R(R),.winner(winner));

    // Clock setup
    parameter clock_period = 100;

    initial begin
        clk = 0;
        forever #(clock_period / 2) clk = ~clk;
    end

    initial begin
        // Initial reset
        reset = 1; @(posedge clk);
        reset = 0; L = 0; R = 0; LED9 = 0; LED1 = 0; @(posedge clk);
       
        repeat(3) @(posedge clk);

        
        LED9 = 1; L = 1; R = 0; @(posedge clk);  
        repeat(3) @(posedge clk);  
        
        reset = 1; @(posedge clk);
        reset = 0; L = 0; R = 0; LED9 = 0; LED1 = 0; @(posedge clk);
        repeat(3) @(posedge clk);

        
        LED1 = 1; R = 1; L = 0; @(posedge clk); 
        repeat(3) @(posedge clk);  
        $stop; 
    end
endmodule 