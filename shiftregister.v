//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------
//
module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output reg [width-1:0]  parallelDataOut,    // Shift reg data contents
output reg             serialDataOut       // Positive edge synchronized

// modified output to output reg, since otherwise it doesn't make sense

);
    reg [width-1:0]      shiftregistermem;

    always @(posedge clk) begin
		if(parallelLoad) begin
			// this takes precedence, I suppose?
			shiftregistermem <= parallelDataIn;
		end else if (peripheralClkEdge) begin
			// advance by one
			// experimental code : below may not work
			shiftregistermem = shiftregistermem << 1;
			shiftregistermem[0] = serialDataIn; // needs to be synchronous, I guess ...?
		end

		serialDataOut <= shiftregistermem[width-1];
		parallelDataOut <= shiftregistermem; 
    end
endmodule
