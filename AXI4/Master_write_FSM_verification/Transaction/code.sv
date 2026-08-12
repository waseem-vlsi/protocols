class transaction_master_write_FSM;
rand logic        write_req;
rand logic [31:0] address;
rand logic [31:0] data;
rand logic [7:0]  awlen;
rand logic [2:0]  awsize;
rand logic [1:0]  awburst;

logic [31:0] AWADDR;
logic        AWVALID;
logic [7:0]  AWLEN;
logic [2:0]  AWSIZE;
logic [1:0]  AWBURST;
logic        AWREADY;

logic [31:0] WDATA;
logic        WVALID;
logic [3:0]  WSTRB;
logic        WLAST;
logic        WREADY;

logic        BVALID;
logic [1:0]  BRESP;
logic        BREADY;


  constraint write_req_const{
    write_req dist {0:=10, 1:=90};
  }

  constraint address_const{
    address dist {32'd0 := 1, 32'd11111 := 5, 32'd7 := 56};
  }

  constraint awsize_const{
    awsize dist {3'd0 := 2, 3'd2 := 1, 3'd1 := 0};
  }

constraint awburst_const {
    awburst == 2'b01;
}
  
  function new();

    write_req = 1'b0;
    address   = 32'd0;
    data      = 32'd0;
    awlen     = 8'd0;
    awsize    = 3'd0;
    awburst   = 2'd0;

endfunction
  
function transaction_master_write_FSM copy();

    transaction_master_write_FSM tr_copy;

    tr_copy = new();

    tr_copy.write_req = this.write_req;
    tr_copy.address   = this.address;
    tr_copy.data      = this.data;
    tr_copy.awlen     = this.awlen;
    tr_copy.awsize    = this.awsize;
    tr_copy.awburst   = this.awburst;

    return tr_copy;

endfunction



  function void display( input string tag);
    $display("[%0s] : write_req = %0d, address = %0d, data = %0d, awlen = %0d, awsize = %0d, awburst = %0d ",
              tag,write_req, address, data, awlen, awsize, awburst);

  endfunction
       
             
  
    

endclass 
