module AXI_master_write_fsm(
  input logic clock,
  input logic reset_n,
  input logic write_req,
  input logic [31:0]address,
  input logic [31:0]data,
  input logic [7:0]awlen,
  input logic [2:0]awsize,
  input logic [1:0]awburst,
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

  typedef enum [1:0]{ 
      IDLE       = 2'b00,
      ADDRESS    = 2'b01,
      DATA       = 2'b10,
      DONE       = 2'b11
  }state_t;

  state_t present_state,next_state;

  logic [31:0] addr_reg,data_reg;
  logic [7:0]  awlen_reg;
  logic [2:0]  awsize_reg;
  logic [1:0]  awburst_reg;
  logic [7:0]  beat_count_reg;


  always_ff@(posedge clock or negedge reset_n) begin 
    if(!reset_n) begin 
      present_state <= IDLE;
    end 
    else begin 
      present_state <= next_state;
    end 
  end 
  
  always_ff@(posedge clock or negedge reset_n) begin 
    if(!reset_n) begin 
      addr_reg <= 32'd0;
    end 
    else if(write_req) begin 
     addr_reg <= address;
    end 
  end 


  always_ff@(posedge clock or negedge reset_n) begin 
    if(!reset_n) begin 
      data_reg <= 32'd0;
    end 
    else if(write_req) begin 
      data_reg <= data;
    end 
  end 

  always_ff@(posedge clock or negedge reset_n) begin
    if(!reset_n) begin 
      awlen_reg <= 8'd0;
    end 
    else if(write_req) begin 
      awlen_reg <= awlen;
    end 
  end 

  always_ff@(posedge clock or negedge reset_n) begin 
    if(!reset_n) begin 
      awsize_reg <= 3'd0;
    end 
    else if(write_req) begin 
      awsize_reg <= awsize;
    end 
  end 

  always_ff@(posedge clock or negedge reset_n) begin 
    if(!reset_n) begin 
      awburst_reg <= 2'd0;
    end 
    else if(write_req) begin 
      awburst_reg <= awburst;
    end 
  end 

  always_ff@(posedge clock or negedge reset_n) begin 
   if(!reset_n)
    beat_count_reg <= 8'd0;
  else if(write_req)
    beat_count_reg <= 8'd0;
  else if(WVALID && WREADY)
    beat_count_reg <= beat_count_reg + 8'd1;
  end 


  // Next state logic 

  always_comb begin
    next_state = present_state;
    case(present_state)

      IDLE: begin 
        if(write_req) begin 
        next_state = ADDRESS;
        end 
        else begin 
        next_state = IDLE; 
        end 
      end 

      ADDRESS: begin 
        if(AWVALID && AWREADY) begin 
        next_state = DATA;
        end 
        else begin 
        next_state = ADDRESS;
        end 
      end 

      DATA: begin 
        if(WVALID && WREADY && WLAST) begin 
        next_state = DONE;
        end 
        else begin 
        next_state = DATA;
        end 
      end 

      DONE: begin 
        if(BVALID && BREADY) begin 
        next_state = IDLE;
        end 
        else begin 
        next_state =   DONE;
        end 
      end 

      default: begin 
      next_state = IDLE;
      end 
    endcase 
end



// OUTPUT LOGIC

always_comb begin

    // Default values
    AWADDR  = 32'd0;
    AWVALID = 1'b0;
    AWLEN   = 8'd0;
    AWSIZE  = 3'd0;
    AWBURST = 2'd0;

    WDATA   = 32'd0;
    WVALID  = 1'b0;
    WSTRB   = 4'b0000;
    WLAST   = 1'b0;

    BREADY  = 1'b0;

    case (present_state)

        //==================================================
        // IDLE STATE
        //==================================================
        IDLE: begin

            AWVALID = 1'b0;
            WVALID  = 1'b0;
            WLAST   = 1'b0;
            BREADY  = 1'b0;

        end


        //==================================================
        // ADDRESS STATE
        //==================================================
        ADDRESS: begin

            AWADDR  = addr_reg;
            AWVALID = 1'b1;

            AWLEN   = awlen_reg;
            AWSIZE  = awsize_reg;
            AWBURST = awburst_reg;

        end


        //==================================================
        // DATA STATE
        //==================================================
        DATA: begin

            WDATA  = data_reg;
            WVALID = 1'b1;

            // WLAST for last beat
            if (beat_count_reg == awlen_reg)
                WLAST = 1'b1;
            else
                WLAST = 1'b0;


           // WSTRB generation
    case (awsize_reg)

    // 1 byte per beat
    3'b000: begin
        WSTRB = 4'b0001 <<
                ((addr_reg + beat_count_reg) & 32'h00000003);
    end

    // 2 bytes per beat
    3'b001: begin
        WSTRB = 4'b0011 <<
                ((addr_reg + (beat_count_reg << 1)) & 32'h00000003);
    end

    // 4 bytes per beat
    3'b010: begin
        WSTRB = 4'b1111;
    end

    default: begin
        WSTRB = 4'b0000;
    end

endcase

        end


        //==================================================
        // DONE STATE
        //==================================================
        DONE: begin

            BREADY = 1'b1;

        end


        //==================================================
        // DEFAULT
        //==================================================
        default: begin

            AWADDR  = 32'd0;
            AWVALID = 1'b0;
            AWLEN   = 8'd0;
            AWSIZE  = 3'd0;
            AWBURST = 2'd0;

            WDATA   = 32'd0;
            WVALID  = 1'b0;
            WSTRB   = 4'b0000;
            WLAST   = 1'b0;

            BREADY  = 1'b0;

        end

    endcase

end

endmodule
