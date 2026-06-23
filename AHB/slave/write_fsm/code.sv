module write_fsm(
  input logic clock,
  input logic reset,
  input logic [1:0]HTRANS,
  input logic HWRITE,
  input logic [31:0]HADDR,
  input logic [31:0]HWDATA,
  output logic HREADY
);

  typedef enum logic [1:0] {

            IDLE,
            ADDR_DECODE,
            WRITE_DATA,
            DONE
  } state_t;

  state_t present_state, nxt_state;
  logic [31:0] addr_reg, data_reg;
  localparam NONSEQ = 2'b10;

  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
        present_state <= IDLE;
    end 
    else begin 
        present_state <= nxt_state;
    end
  end 


  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
        addr_reg <= 32'd0;
    end 
    else if(HTRANS == NONSEQ &&
            HWRITE == 1 &&
      present_state == IDLE) begin 
        addr_reg <= HADDR;
    end 
  end 


  always_ff@(posedge clock or posedge reset) begin 
    if(reset) begin 
      data_reg <= 32'd0;
    end
    else if(HTRANS == NONSEQ &&
            HWRITE == 1 &&
      present_state == IDLE) begin 
      data_reg <= HWDATA;
    end
  end 





endmodule
