module AXI_master_write_fsm(
  input logic clock,
  input logic reset,
  input logic write_req,
  input logic [31:0]addr,
  input logic [31:0]data,
  input logic AWREADY,
  input logic WREADY,
  input logic BVALID,
  input logic [1:0] BRESP,

  output logic [31:0]AWADDR,
  output logic AWVALID,
  output logic [7:0]AWLEN,
  output logic [2:0]AWSIZE,
  output logic [1:0]AWBURST,
  output logic [31:0]WDATA,
  output logic WVALID,
  output logic [3:0]WSTRB,
  output logic WLAST,
  output logic BREADY

  
);
