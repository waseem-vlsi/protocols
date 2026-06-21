module slave_read_fsm(
    input logic clock,
    input logic reset,
    input logic [31:0]HADDR,
    input logic HWRITE,
    input logic [1:0]HTRANS,

    output logic [31:0]HRDATA,
    output logic HREADY

);



    always@(posedge clock or posedge reset) begin 

        if(reset) 
            present_state <= IDLE;
        else 
            present_state <= next_state;
    end 

always_ff @(posedge clock or posedge reset) begin 
    if(reset)
        addr_reg <= 32'd0;
    else if(present_state == IDLE &&
            HTRANS == NONSEQ &&
            HWRITE == 0)
        addr_reg <= HADDR;
end
    
always_ff @(posedge clock or posedge reset) begin 
    if(reset) 
        data_reg <= 32'd0;

    else if(present_state == FETCH_DATA)
        data_reg <= mem[addr_reg];
end



    always@(*) begin 
        present_state = next_state;
        case(present_state)
        IDLE: 


        endcase 
    

    end 


    always@(*) begin 
        HREADY = 0;
        HRDATA = 0;

        case(present_state)
            IDLE: begin 
            end 

            ADDRESS_DECODE: begin 
            end

            FETCH_DATA: begin 
            end 
            TRANSFER_DATA: begin 
                HREADY = 1;
                HRDATA = data_reg;
            end

        endcase
    end
