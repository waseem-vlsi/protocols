class driver ;
    transaction_master_write_FSM tr;
  mailbox #(transaction_master_write_FSM ) mbxg2d;
  virtual master_write_FSM_if vif;
  event reset_done;

  function new(  mailbox #(transaction_master_write_FSM ) mbxg2d,
                 virtual master_write_FSM_if vif)

    this.mbxg2d = mbxg2d;
    this.vif    = vif;

  endfunction

  task reset();
    @(posedge vif.clock);
    vif.reset_n <= 1'b0;
    repeat(3)@(posedge vif.clock);
    vif.reset_n <= 1'b1;
    @(posedge vif.clock);
    ->reset_done;    
  endtask

  task run();
    wait(reset_done);
    forever begin 
      mbxg2d.get(tr);
      vif.write_req <= tr.write_req;
      vif.address <= tr.address;
      vif.data    <= tr.data;
      vif.awlen   <= tr.awlen;
      vif.awsize  <= tr.awsize;
      vif.awburst <= tr.awburst;

      @(posedge vif.clock);
      tr.display("DRV");
      vif.write_req <= 1'b0;
      vif.address <= 32'd0;
      vif.data    <= 32'd0;
      vif.awlen   <= 8'd0;
      vif.awsize  <= 3'd0;
      vif.awburst <= 2'd0; 
      @(posedge vif.clock);
    end 
  endtask
endclass
