
module master_read_FSM(
        // global signals
        input logic Hclk,
        input logic Hresetn,
        
        // user interface
        input logic read_req,
        input logic [31:0]read_addr,
        
        output logic [31:0]read_data,
        output logic read_done,
        
        // AHB master - slave between signls 

        output logic [31:0] HADDR,
        output logic HWRITE,
        output logic HTRANS,
        
        input logic HREADY,
        input logic [31:0] HRDATA

);


typedef enum logic [1:0]{
            IDLE,
            ADDRESS,
            WAIT_READY
            } state_t;
            
  state_t present_state,next_state;
  
     
     localparam IDLE_TRANS   = 2'b00;          
     localparam NONSEQ_TRANS = 2'b10;
     logic [31:0] addr_reg;
     
     // next state register
     
  always_ff@(posedge Hclk or posedge Hresetn) begin 
  
  if(Hresetn) begin 
  
  present_state <= IDLE;
  
  end 
  
  else begin 
  
  present_state <= next_state;
  
  end 
  end 
  
  // address_storage
  
  always_ff@(posedge Hclk or posedge Hresetn) begin 
  
  if(Hresetn) begin 
  
  addr_reg <= 32'd0;
  
  end 
  else if(read_req && (present_state == IDLE)) begin 
  
  addr_reg <= read_addr;
  
  end 
  
  end 
  
  // data register
  
  always_ff@(posedge Hclk or posedge Hresetn) begin
  if(Hresetn) 
    read_data <= 32'd0;
    else if(present_state == WAIT_READY && HREADY) 
    read_data <= HRDATA; 

    end 
    
    
    // combinational logic -STATE LOGIC
    
    always_comb begin 
    
    case(present_state) 
    
    IDLE:  begin 
        if(read_req) 
            present_state = ADDRESS;
         else 
            present_state = IDLE;
    
    end 
    
    ADDRESS: begin 
          present_state = WAIT_READY;
    end
    WAIT_READY: begin 
    
    if(HREADY)
        present_state = IDLE;
     else 
        present_state = WAIT_READY;
    
    end 
    default : present_state = IDLE;
    
    endcase 
    
    
    end 


// OUTPUTS

always_comb
begin

  HADDR     = 32'd0;
  HWRITE    = 1'b0;
  HTRANS    = IDLE_TRANS;
  read_done = 1'b0;

  case(present_state)

    ADDRESS:
    begin
      HADDR  = addr_reg;
      HWRITE = 1'b0;
      HTRANS = NONSEQ_TRANS;
    end

    WAIT_READY:
    begin
      HADDR  = addr_reg;
      HWRITE = 1'b0;
      HTRANS = NONSEQ_TRANS;

      if(HREADY)
        read_done = 1'b1;
    end

  endcase

end


endmodule
