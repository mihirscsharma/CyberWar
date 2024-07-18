module centerLight (clk, reset, L, R, NL, NR, lightOn, res);
	input logic clk, reset;
	input logic L, R, NL, NR, res;
	output logic lightOn;
	enum { on, off } ps, ns;
	
	assign lightOn = (ps==on);
	
	always_comb begin
		 
		if ( ps == on) begin
		 if ((R && !L) || (!R && L))
			ns = off;
		 else 
			ns = on;
			
		 end else begin 
		 if ((NL && R && !L) || (NR && L && !R))
           ns = on;	 
		 else 
			  ns = off;
		 end 	  
	end

    always_ff @(posedge clk ) 
	 begin
        if (reset | res)
            ps <= on;
        else
            ps <= ns;
    end	
endmodule

// L is true when left key is pressed, R is true when the right key
	// is pressed, NL is true when the light on the left is on, and NR
	// is true when the light on the right is on.
		// when lightOn is true, the center light should be on.


module centerLight_testbench();

		logic clk, reset, L, R, NL, NR;
		logic res;

    // Outputs
      logic lightOn;
		
		centerLight dut (.clk, .reset, .L, .R, .NL, .NR, .lightOn, .res);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end 
		
		initial begin
			
			reset <= 1;         @(posedge clk);
			reset <= 0; L <= 1'b0;	R <= 1'b0;	NL <= 1'b0;   NR <= 1'b0;   @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			                    @(posedge clk);	
			L <= 1'b0;	R <= 1'b1;	NL <= 1'b0;   NR <= 1'b0;   @(posedge clk);
									  @(posedge clk);
									  @(posedge clk);
			L <= 1'b1;	R <= 1'b0;	NL <= 1'b0;   NR <= 1'b0;   @(posedge clk);   	
			L <= 1'b0;	R <= 1'b0;	NL <= 1'b0;   NR <= 1'b0;   @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
		
			L <= 1'b1;	R <= 1'b0;	NL <= 1'b0;   NR <= 1'b1;   @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
		
			L <= 1'b1;	R <= 1'b0;	NL <= 1'b0;   NR <= 1'b0;   @(posedge clk);
									  @(posedge clk);
									  @(posedge clk);
			// going back to S0 (on) with the other possible combo and staying on after combo
			L <= 1'b0;	R <= 1'b1;	NL <= 1'b1;   NR <= 1'b0;   @(posedge clk);	
			L <= 1'b0;	R <= 1'b0;	NL <= 1'b1;   NR <= 1'b0;   @(posedge clk);	
									  @(posedge clk);
									  @(posedge clk);
			$stop; 							
							
		end 
		
endmodule		