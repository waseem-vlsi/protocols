module Master_Write_FSM(
  input logic clock,
  input logic reset,
  input logic [31:0] cpu_data,
  input logic [31:0] cpu_addr,
  input logic [3:0] cpu_awlen,
  input logic [2:0] cpu_awsize,
  input logic [1:0] cpu_awburst,

  output logic [31:0] AWADDR,
  output logic [31:0] WDATA,
  output logic [3:0] AWLEN,
  output logic [2:0] AWSIZE,
  output logic [1:0] AWBURST,

  input logic BREADY
  
);
  



typedef enum logic [2:0] {
          IDLE,
          SEND_ADDRESS,
          LOAD_DATA,
          RESPONSE_STATE,
          DONE
} state_t;

state_t present_state,next_state;

logic [31:0] addr_reg;
logic [31:0] write_reg_data;
logic [3:0]awlen_reg;
logic [2:0]awsize_reg;
logic [1:0]awburst_reg;
logic [3:0]beat_counter;





always_ff@(posedge clock or posedge reset) begin 
  if(reset) begin 
  addr_reg <= 32'd0;
  end 
  else if(write_req) begin 
  addr_reg <= cpu_addr;
  end 
end 

always_ff@(posedge clock or posedge reset) begin 
  if(reset) begin 
    present_state <= IDLE;
  end
  else  begin 
    present_state <= next_state;
  end 
end 

always_ff@(posedge clock or posedge reset) begin 
  if(reset) begin 
    write_reg_data <= 32'd0;
  end 
  else if(write_req) begin 
    write_reg_data <= cpu_data;
  end 
end 

always_ff@(posedge clock or posedge reset) begin 
  if(reset) begin 
    awlen_reg <= 4'd0;
  end 
  else if(write_req) begin 
    awlen_reg <= cpu_awlen;
  end 
end 

always_ff@(posedge clock or posedge reset) begin 
  if(reset) begin 
    awsize_reg <= 3'd0;
  end 
  else if(write_req) begin 
    awsize_reg <=cpu_awsize;
  end 
end 

always_ff@(posedge clock or posedge reset) begin 
  if(reset) begin 
    awburst_reg <= 2'd0;
  end 
  else if(write_req) begin 
    awburst_reg <= cpu_awburst;
  end 
end 

always_ff@(posedge clock or posedge reset) begin 
  if(reset) begin 
    beat_counter <= 4'd0;
  end 
  else if(write_req) begin 
    beat_counter <= 4'd0;
  end 
 else if (WVALID && WREADY) begin 
    beat_counter <= beat_counter + 1;
  end 
end 
