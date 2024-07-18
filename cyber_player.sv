module cyber_player(
    input logic clk, 
    input logic reset,
    input logic [9:0] Q,
    input logic [8:0] SW,
    output logic out
);

    logic [9:0] SW_extend;
    logic [9:0] B;

    assign SW_extend = {1'b0, SW}; 
    
    always_comb begin
        B = SW_extend;
        out = (SW_extend > Q);
    end 
    
endmodule


module cyber_player_testbench();
	logic out;
	logic clk, reset;
	logic [9:0] Q;
	logic [8:0] SW;
	logic [9:0] SW_extend;
	
	cyber_player dut(.clk, .reset, .Q, .SW, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) 
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1;											@(posedge clk);
																@(posedge clk);
		reset <= 0;											@(posedge clk);
																@(posedge clk);
		Q = 10'b0000000001;	SW = 9'b000000010;	@(posedge clk);
																@(posedge clk);
		Q = 10'b0000000011;								@(posedge clk);
																@(posedge clk);
		$stop;
	end
endmodule 																																																				