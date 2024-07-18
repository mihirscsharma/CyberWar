module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	 input logic 			CLOCK_50;        // 50MHz clock.
	 output logic 	[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic 	[9:0] LEDR;
	 input logic 	[3:0] KEY;           // True when not pressed, False when pressed
	 input logic 	[9:0] SW;
	 logic res;
	 
	 //logic reset;
	 logic key0, key3;
	 logic press, press2;
	 
	 logic [31:0] clk;
	 parameter whichClock = 15;
	 clock_divider cdiv (CLOCK_50, clk);
	 
	 logic [9:0] lfsr_out;
	
	 logic comput;
	 
	 assign HEX4 = 7'b1111111;
	 assign HEX3 = 7'b1111111;
	 assign HEX2 = 7'b1111111;
	 assign HEX1 = 7'b1111111;
	 
	 meta leftside (.clk(clk[whichClock]), .reset(SW[9]), .button(~KEY[0]), .out(press));
	 meta rightside (.clk(clk[whichClock]), .reset(SW[9]), .button(comput), .out(press2));
	 
	 user_input lefty (.clk(clk[whichClock]), .reset(SW[9]), .w(press), .out(key0));
	 user_input righty (.clk(clk[whichClock]), .reset(SW[9]), .w(press2), .out(key3));
	 
	 normalLight one (.Clock(clk[whichClock]), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]), .res(res));
	 normalLight two (.Clock(clk[whichClock]), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]), .res(res));
	 normalLight three (.Clock(clk[whichClock]), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]), .res(res));
	 normalLight four (.Clock(clk[whichClock]), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]), .res(res)); 
	 centerLight five (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]), .res(res));	 
	 normalLight six (.Clock(clk[whichClock]), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]), .res(res));
	 normalLight seven (.Clock(clk[whichClock]), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]), .res(res));
	 normalLight eight (.Clock(clk[whichClock]), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]), .res(res));
	 normalLight nine (.Clock(clk[whichClock]), .Reset(SW[9]), .L(key3), .R(key0), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]), .res(res));	 
	 LFSR random(.clk(clk[whichClock]), .reset(SW[9]), .Q(lfsr_out));
	 cyber_player comp(.clk(clk[whichClock]), .reset(SW[9]), .Q(lfsr_out), .SW(SW[8:0]), .out(comput));
	 victory gameEnds (.clk(CLOCK_50), .reset(SW[9]), .LED9(LEDR[9]), .LED1(LEDR[1]), .L(key3), .R(key0), .HEX0(HEX0), .HEX5(HEX5), .res(res));
	 
	 
endmodule 

 //divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	 input logic 			clock; //reset?
	 output logic [31:0] divided_clocks = 0; 

	 always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	 end

endmodule 

module DE1_SoC_testbench();

		logic CLOCK_50; // 50MHz clock
		logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
		logic [9:0] LEDR;
		logic [3:0] KEY; // Active low property
		logic [9:0] SW;
		
		// Instantiate the the DE1 SoC module under test
		DE1_SoC dut (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
		
		//clock setup
		parameter clock_period = 100;
		
		// Generate the clock signal for simulation
		initial begin 
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
		
	   end //initial 
	
	// Test scenario to validate the DE1 SoC module's operation
	initial begin 
						 
		SW[9] <= 1;  			    @(posedge CLOCK_50);
		SW[9] <= 0;				    @(posedge CLOCK_50);
		KEY[0] <= 1; KEY[3]<= 0; @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 1; @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 0; @(posedge CLOCK_50);
			                      @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 1; @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
					    KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 0; @(posedge CLOCK_50);
								       @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 1; @(posedge CLOCK_50);			 
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 0; @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 1; @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 0; @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 1; @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
						 KEY[0]<= 1; @(posedge CLOCK_50);
						 KEY[3]<= 0; @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
										 @(posedge CLOCK_50);
		$stop; //end simulation
		
	end //initial

endmodule 