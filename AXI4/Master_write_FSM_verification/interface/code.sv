interface master_write_FSM_if;

 logic clock,
 logic reset_n,
 logic write_req,
 logic [31:0]address,
 logic [31:0]data,
 logic [7:0]awlen,
 logic [2:0]awsize,
 logic [1:0]awburst,
 logic AWREADY,
 logic WREADY,
 logic BVALID,
 logic [1:0] BRESP,
 logic [31:0]AWADDR,
 logic AWVALID,
 logic [7:0]AWLEN,
 logic [2:0]AWSIZE,
 logic [1:0]AWBURST,
 logic [31:0]WDATA,
 logic WVALID,
 logic [3:0]WSTRB,
 logic WLAST,
 logic BREADY
  
endinterface
