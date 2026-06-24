module write_fsm(
  // global signals
  input logic clock,
  input logic reset,
  // i/o signals
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

// next state logic 


  always_comb begin 
     nxt_state = present_state;
    unique case(present_state) 
    
      IDLE: begin 
        if(HWRITE == 1 &&
           HTRANS == NONSEQ) begin
          nxt_state = ADDR_DECODE;
        end
        else begin 
          nxt_state = IDLE;
      end 
      end


      ADDR_DECODE: begin 
          nxt_state = WRITE_DATA;
      end 

      WRITE_DATA: begin 
          nxt_state = DONE;
      end

      DONE: begin 
          nxt_state = IDLE;
      end

      default: begin 
         nxt_state = IDLE;
      end 
       endcase
  end 


  always_comb begin 
      HREADY = 0;
    unique case(present_state) 

      IDLE: begin 
        HREADY = 1;
      end

      ADDR_DECODE: begin 
          HREADY = 0;
      end 

      WRITE_DATA: begin 
          HREADY = 0;
      end

      DONE: begin 
         HREADY = 1;
      end

      default: begin 
         HREADY = 0;
      end 
       endcase
      end 


endmodule
