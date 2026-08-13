class generator;

  transaction_master_write_FSM tr;
  mailbox #(transaction_master_write_FSM) mbxg2d;
  mailbox #(transaction_master_write_FSM) mbxg2s;
  int count;

  function new(  mailbox #(transaction_master_write_FSM) mbxg2d,
                 mailbox #(transaction_master_write_FSM) mbxg2s)

    tr = new();
    this.mbxg2d = mbxg2d;
    this.mbxg2s = mbxg2s;

  endfunction

  task run();
    repeat(count) begin 
      assert(tr.randomize()) else  begin 
      $error("Randomization failed!!!");
    end 
    tr.display("Gen");

    mbxg2d.put(tr.copy());
    mbxg2s.put(tr.copy());
    end 
  endtask
    endclass 
