module meta (clk, reset, button, out);

		input logic clk, reset;
		input logic button;
		output logic out;

		logic flip;

			always_ff @(posedge clk) begin
				flip <= button;
			end
			
			always_ff @(posedge clk) begin
				out <= flip;
			end
endmodule

module meta_testbench();

		logic clk, reset, button;
		logic out;
		
		meta dut (.clk, .reset, .button, .out);  
// meta testbench tests all expected, unexpected, and edgecase behavior
		
		//setting up clock
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end 
		initial begin
		
			reset <= 1;         @(posedge clk);
			reset <= 0; button<=0;   @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			                    @(posedge clk);	
			            button<=1;   @(posedge clk);	
							button<=0;   @(posedge clk);	
							button<=1;   @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
							button<=0;   @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
							button<=1;   @(posedge clk);	
									  @(posedge clk);
							button<=0;   @(posedge clk);	
							button<=1;   @(posedge clk);	
									  @(posedge clk);
									  @(posedge clk);
			$stop; 						
							
		end 
		
endmodule		




