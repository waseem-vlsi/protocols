class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  mailbox #(transaction_master_write) mbxg2d;
  mailbox #(transaction_master_write) mbxg2s;
  mailbox #(transaction_master_write) mbxm2s;

  transaction_master_write tr;
  interface master_write_FSM_if vif;

    function new(virtual vif);
      mbxg2d = new();
      mbxg2s = new();

      gen = new(mbxg2d, mbxg2s);
      drv = new(mbxg2d, vif);

      mbxm2s = new();

      mon = new(mbxm2s);
      sco = new(mbxg2s, mbxm2s);
      this.vif = vif;

      
    endfunction

    task pre_test();
      drv.reset();
    endtask

    task test();
        fork
          gen.run();
          drv.run();
          mon.run();
          sco.run();
        join_any
    endtask

    task post_test();
      wait(gen.done.triggered);
      $finish();
    endtask

    task run();
      pre_test();
      test();
      post_test();
    endtask
  
endclass 
