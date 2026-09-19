module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  
  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

 
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
 
    t_a = 4'd5; t_b = 4'd3; t_op = 1'b0;
    #10;
    $display("Test 1 (Add): 5 + 3 = %0d | Expected: 8", t_result);

  
    t_op = 1'b1;
    #10;
    $display("Test 2 (Op toggle): 5 - 3 = %0d | Expected: 2", t_result);

  
    t_a = 4'd9; t_b = 4'd4; t_op = 1'b1;
    #10;
    $display("Test 3 (Sub): 9 - 4 = %0d | Expected: 5", t_result);


    t_a = 4'd7; t_b = 4'd2; t_op = 1'b1;
    #10;
    $display("Test 4 (Sub): 7 - 2 = %0d | Expected: 5", t_result);

    #10 $finish;
  end

  initial
    $monitor($time, " a=%0d b=%0d op=%b | result=%0d", t_a, t_b, t_op, t_result);

endmodule