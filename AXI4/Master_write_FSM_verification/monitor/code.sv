class monitor;
    transaction_master_write_FSM tr;
    mailbox #(transaction_master_write_FSM) mbxm2s;
    virtual master_write_FSM_if vif;

    function new(  mailbox #(transaction_master_write_FSM) mbxm2s, 
                 virtual master_write_FSM_if vif);
        this.mbxm2s = mbxm2s;
        this.vif = vif;
    endfunction 

    task run();
        forever begin 
                    tr = new();

        @(posedge vif.clock);
            if(vif.AWVALID && vif.AWREADY) begin 
             tr.AWADDR = vif.AWADDR;
            tr.AWVALID = vif.AWVALID;
            tr.AWREADY = vif.AWREADY;
            tr.AWLEN = vif.AWLEN;
            tr.AWSIZE = vif.AWSIZE;
            tr.AWBURST = vif.AWBURST;

            break;
        end 
        end

            forever begin 
            @(posedge vif.clock);

                if(vif.WVALID && vif.WREADY) begin 
            tr.WDATA = vif.WDATA;
            tr.WLAST = vif.WLAST;
            tr.WSTRB = vif.WSTRB;
            tr.WVALID = vif.WVALID;
            tr.WREADY = vif.WREADY;
            if(vif.WLAST) begin 
            break;
        end 
       
            end
            end
        forever begin 
      @(posedge vif.clock);

            if(vif.BVALID && vif.BREADY) begin 
            tr.BRESP  = vif.BRESP;
            tr.BVALID = vif.BVALID;
            tr.BREADY = vif.BREADY;
             break;
        end 
        end

        tr.display("MON");
        mbxm2s.put(tr);
        end

    endtask
endclass 
