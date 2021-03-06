`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint
(
	input clk,
	input [3:0] sw, // 2 switches, sw[0] for Serial Data In, sw[1] for Clk Ed, sw[2] for "show low 4 bits" and !sw[2] for "show high 4 bits"
	input [3:0] btn, // btn[0] for parallel load
	output reg [3:0] led // 4 leds, display subset of status of shift register
  );

  wire[2:0] conditioned, posiedge, negaedge;
  wire[7:0] parallelOut;
  wire serialOut;

  inputconditioner ic0(clk, btn[0], conditioned[0], posiedge[0], negaedge[0]);
  inputconditioner ic1(clk, sw[0], conditioned[1], posiedge[1], negaedge[1]);
  inputconditioner ic2(clk, sw[1], conditioned[2], posiedge[2], negaedge[2]);

  shiftregister sr0(clk, posiedge[2], negaedge[0], 8'hA5, conditioned[1], parallelOut, serialOut);
  
  always @(posedge clk) begin
      if (sw[2]) begin
        led = parallelOut[3:0];
      end else begin
        led = parallelOut[7:4];
      end
  end
  
endmodule
