
module master_write_fsm(

    input  logic        clock,
    input  logic        reset,
    input  logic        write_req,
    input  logic [31:0] write_data,
    input  logic [31:0] write_addr,
    input  logic        HREADY,

    output logic        HWRITE,
    output logic [31:0] HADDR,
    output logic [31:0] HWDATA,
    output logic [1:0]  HTRANS,
    output logic        write_done
);

    typedef enum logic [1:0] {
        IDLE,
        ADDR,
        DATA_STATE
    } state_t;

    state_t present_state, next_state;

    localparam IDLE_TRANS   = 2'b00;
    localparam NONSEQ_TRANS = 2'b10;

    logic [31:0] addr_reg;
    logic [31:0] data_reg;

    always_ff @(posedge clock or posedge reset) begin
        if(reset)
            present_state <= IDLE;
        else
            present_state <= next_state;
    end

    always_ff @(posedge clock or posedge reset) begin
        if(reset)
            addr_reg <= 32'd0;
        else if(present_state == IDLE && write_req)
            addr_reg <= write_addr;
    end

    always_ff @(posedge clock or posedge reset) begin
        if(reset)
            data_reg <= 32'd0;
        else if(present_state == IDLE && write_req)
            data_reg <= write_data;
    end

    always_comb begin

        next_state = present_state;

        case(present_state)

            IDLE: begin
                if(write_req)
                    next_state = ADDR;
                else
                    next_state = IDLE;
            end

            ADDR: begin
                next_state = DATA_STATE;
            end

            DATA_STATE: begin
                if(HREADY)
                    next_state = IDLE;
                else
                    next_state = DATA_STATE;
            end

            default: begin
                next_state = IDLE;
            end

always_comb begin 

    HADDR      = 32'd0;
    HWRITE     = 1'b0;
    HTRANS     = IDLE_TRANS;
    HWDATA     = 32'd0;
    write_done = 1'b0;

    case(present_state)

        IDLE: begin
        end

        ADDR: begin 
            HADDR  = addr_reg;
            HWRITE = 1'b1;
            HTRANS = NONSEQ_TRANS;
        end

        DATA_STATE: begin 
            HADDR  = addr_reg;
            HWRITE = 1'b1;
            HTRANS = NONSEQ_TRANS;
            HWDATA = data_reg;

            if(HREADY)
                write_done = 1'b1;
        end 

        default: begin
        end 

    endcase

end       
        endcase
    end
endmodule
