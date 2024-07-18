module LFSR (
    input logic clk,
    input logic reset,
    output logic [9:0] Q);

    logic xnor_out;

    always_ff @(posedge clk) begin
        if (reset) begin
            Q <= '0;
        end else begin
            xnor_out = ~^Q[0] ^ Q[3]; 
            Q <= {xnor_out, Q[9:1]};
        end
    end

endmodule

module LFSR_testbench();
	logic [10:1] Q;
	logic clk, reset;
	logic xnor_out;
	
	LFSR dut(.clk, .reset, .Q);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1; 						@(posedge clk);
												@(posedge clk);
		reset <= 0;							@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
		$stop;
	end
endmodule
