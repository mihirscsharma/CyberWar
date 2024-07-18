module user_input (clk, reset, w, out);

	input  logic  clk, reset, w; // Input signals, 'w' is user input from meta
	output logic out; // Output signals (if key is pressed)

	enum {S0, S1} ps, ns; // Present state, next state


	always_comb begin
		case (ps)
			S0: if (w) ns = S1; 
					else ns = S0;
			S1: if (w) ns = S1; 
					else ns = S0;
		endcase
	end
	
	assign out = (ps == S0) & w; //Next state logic
	// next state is based off of present state and 
	// the input that is inpute, situations are all described 
	// in case statement
	
	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0; // Reset
			else
				ps <= ns; // Update the present state 
		end
				
	
endmodule



module user_input_testbench();

		logic clk, reset, w;
		logic out;
		
		user_input dut (.clk, .reset, .w, .out);
		
		
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end
		
		initial begin
		
			reset <= 1;         @(posedge clk);
			reset <= 0; w<=0;   @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			                    @(posedge clk);	
			            w<=1;   @(posedge clk);	
							w<=0;   @(posedge clk);	
							w<=1;   @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
							w<=0;   @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
							w<=1;   @(posedge clk);	
									  @(posedge clk);
							w<=0;   @(posedge clk);	
							w<=1;   @(posedge clk);	
									  @(posedge clk);
									  @(posedge clk);
			$stop; 							
							
		end 
		
endmodule		