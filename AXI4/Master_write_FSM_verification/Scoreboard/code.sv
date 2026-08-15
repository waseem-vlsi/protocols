class scoreboard;

    transaction_master_write_FSM tr;
    transaction_master_write_FSM trref;

    mailbox #(transaction_master_write_FSM) mbxg2s;
    mailbox #(transaction_master_write_FSM) mbxm2s;

    logic [31:0] ref_address[$];
    logic [31:0] ref_data[$];

    logic [31:0] expected_data;
    logic [31:0] expected_address;

    function new(
        mailbox #(transaction_master_write_FSM) mbxg2s,
        mailbox #(transaction_master_write_FSM) mbxm2s
    );

        this.mbxg2s = mbxg2s;
        this.mbxm2s = mbxm2s;

    endfunction


    task run();

        forever begin

            mbxg2s.get(trref);
            mbxm2s.get(tr);

            ref_address.push_back(trref.address);

            $display("[SCO] : Address %0d stored into queue",
                     trref.address);

            ref_data.push_back(trref.data);

            $display("[SCO] : Data %0d stored into queue",
                     trref.data);


            if((ref_address.size() != 0) &&
               (ref_data.size() != 0)) begin

                expected_address = ref_address.pop_front();
                expected_data    = ref_data.pop_front();

                if((expected_data == tr.WDATA) &&
                   (expected_address == tr.AWADDR)) begin

                    $display("[SCO] Transaction matched!!!");

                end
                else begin

                    $display("[SCO] Transaction mismatched!!!");

                    $display("[SCO] Expected Address = %0d",
                             expected_address);

                    $display("[SCO] Actual Address = %0d",
                             tr.AWADDR);

                    $display("[SCO] Expected Data = %0d",
                             expected_data);

                    $display("[SCO] Actual Data = %0d",
                             tr.WDATA);

                end
              end
               end
    endtask

endclass
