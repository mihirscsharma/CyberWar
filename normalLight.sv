module normalLight (Clock, Reset, L, R, NL, NR, lightOn, res);
	input logic Clock, Reset;
	
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
	always_ff @(posedge Clock ) 
	 begin
        if (Reset | res)
            ps <= off;
        else
            ps <= ns;
    end	
endmodule
	
 


module normal_light_testbench();
    logic clk, reset;
    logic L, R, NL, NR;
    logic lightOn;
    // Instantiate the DUT
    normalLight dut (.Clock(clk),.Reset(reset),.L(L),.R(R),.NL(NL),.NR(NR),.lightOn(lightOn));

    // Clock setup
    parameter clock_period = 100;

    initial begin
        clk = 0;
        forever #(clock_period / 2) clk = ~clk;
    end

   
    initial begin
        reset = 1; @(posedge clk);
        reset = 0; @(posedge clk);

        
        L = 0; R = 0; NL = 0; NR = 0; @(posedge clk);
        L = 0; R = 1; NL = 1; NR = 0; @(posedge clk);
        L = 0; R = 0; NL = 0; NR = 0; @(posedge clk);
        L = 0; R = 0; NL = 1; NR = 0; @(posedge clk);
        L = 1; R = 0; NL = 0; NR = 0; @(posedge clk);
        L = 1; R = 0; NL = 0; NR = 0; @(posedge clk);
        L = 1; R = 0; NL = 0; NR = 1; @(posedge clk);
        L = 0; R = 0; NL = 1; NR = 0; @(posedge clk);

        // End simulation
        $stop;
    end
endmodule 