module slave_read_fsm(
    input logic clock,
    input logic reset,
    input logic [31:0]HADDR,
    input logic HWRITE,
    input logic [1:0]HTRANS,

    output logic [31:0]HRDATA,
    output logic HREADY

);
