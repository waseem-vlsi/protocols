module slave_read_fsm(
    input logic clock,
    input logic reset,
    input logic [31:0]HADDR,
    input logic HWRITE,
    input logic [1:0]HTRANS,

    output logic [31:0]HRDATA,
    output logic HREADY

);

    typedef enum logic[1:0]{
            IDLE,
            ADDR_DECODE,
            FETCH_DATA,
            TRANSFER_DATA
    }state_t ;

    state_t present_state, next_state;


    localparam NON_SEQ = 2'b10;

    logic [31:0] addr_reg, data_reg;
    logic [31:0] mem [1023:0];
    always_ff@(posedge clock or posedge reset) begin 

        if(reset) 
            present_state <= IDLE;
        else 
            present_state <= next_state;
    end 

always_ff@(posedge clock or posedge reset) begin 
    if(reset)
        addr_reg <= 32'd0;
    else if(present_state == IDLE &&
            HTRANS == NON_SEQ &&
            HWRITE == 0)
        addr_reg <= HADDR;
end
    
always_ff@(posedge clock or posedge reset) begin 
    if(reset) 
        data_reg <= 32'd0;

    else if(present_state == FETCH_DATA)
        data_reg <= mem[addr_reg];
end



    always_comb begin 
        next_state = present_state;
        case(present_state)
        IDLE: begin 
            if(HTRANS == NON_SEQ  &&  HWRITE == 0)
                next_state = ADDR_DECODE;
            else 
                next_state = IDLE;            
        end 

        ADDR_DECODE: begin 
            next_state = FETCH_DATA;
        end

        FETCH_DATA: begin
            next_state = TRANSFER_DATA;  
        end

        TRANSFER_DATA: begin
            next_state = IDLE;
        end

        default: begin 
            next_state = IDLE;
        end
        endcase 
        end 


    always_comb begin 
        HREADY = 0;
        HRDATA = 32'd0;

        case(present_state)
            IDLE: begin 
                HREADY = 1;
            end 

            ADDR_DECODE: begin 
            end

            FETCH_DATA: begin 
            end 
            TRANSFER_DATA: begin 
                HREADY = 1;
                HRDATA = data_reg;
            end
            default: begin
            end

        endcase
    end
endmodule
