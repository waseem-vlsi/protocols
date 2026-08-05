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
  typedef enum [1:0] {
          IDLE,
          ADDRESS,
          DATA,
          DONE
  }state;

state present_state, next_state;
  logic [31:0] addr_from_user, data_from_user;
  logic [31:0] address,data;
  logic [7:0] awlen_from_user, awlen;
  logic [2:0]awsize_from_user,awsize;
  logic [1:0] awburst_from_user,awburst;
  logic [3:0] wstrb_from_user,wstrb;
  logic [7:0] beat_count;
  logic wlast;
// next state logic 
  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
      present_state <= IDLE;
    end 
    else begin 
      present_state <= next_state;
    end 
  end 

  // resisters logic 

  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
      address <= 32'd0;
    end 
    else if (write_req) begin 
    address <= addr_from_user;
    end 
  end 

  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
     data <= 32'd0;
    end
    else if (write_req) begin 
    data <= data_from_user;
    end 
  end 

  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
    awlen <= 8'd0;
    end 
    else if(write_req) begin 
    awlen <= awlen_from_user;
    end 
  end 

  always_ff(posedge clock or posedge reset) begin 
    if(reset) begin 
    awsize <= 3'd0;
    end 
    else if(write_req) begin 
    awsize <= awsize_from_user;
    end 
  end 

  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
    awburst <= 2'd0;
    end 
    else if(write_req) begin 
    awburst <= awburst_from_user;
    end 
  end 

  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
    wstrb <= 2'd0;
    end 
    else if(write_req) begin 
    wstrb <= wstrb_from_user;
    end 
  end 

  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
    beat_count <= 8'd0;
    end 
    else begin 
    beat_count <= beat_count + 8'd1;
    end 
  end 
  
  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
    wlast <= 1'd0;
    end 
    else if(beat_count == 4) begin 
    wlast <= 1'd1;
    end 
  end 


  always_comb begin 


  end 
  
endmodule
