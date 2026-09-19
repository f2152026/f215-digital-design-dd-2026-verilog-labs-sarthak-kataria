module tb;

  reg  [1:0] t_a;
  reg  [1:0] t_b;
  wire       t_gt;
  wire       t_lt;
  wire       t_eq;

  integer i, j;
  integer errors;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  reg exp_gt, exp_lt, exp_eq;

  initial begin
    errors = 0;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        
        #5;

        exp_eq = (t_a == t_b);
        exp_gt = (t_a >  t_b);
        exp_lt = (t_a <  t_b);

        if ((t_gt + t_lt + t_eq) !== 1) begin
          $display("FAIL [One-Hot Violation] at time %0t: A=%0d, B=%0d | GT=%b LT=%b EQ=%b (Sum of outputs != 1)",
                   $time, t_a, t_b, t_gt, t_lt, t_eq);
          errors = errors + 1;
        end

        // Check 2: Functional correctness against expected values
        if (t_gt !== exp_gt || t_lt !== exp_lt || t_eq !== exp_eq) begin
          $display("FAIL [Value Mismatch] at time %0t: A=%0d, B=%0d | Got: GT=%b LT=%b EQ=%b | Expected: GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    #5
    if (errors == 0) begin
        $display ("-------------------------------");
        $display ("ALL 16 TESTS PASSED SUCCESFULLY");
        $display ("-------------------------------");

    end else begin
        $display ("-------------------------------");
        $display ("SIMULATION FAILED WITH %0d ERRORS", errors);
        $display ("-------------------------------");
    end

    $finish;
  end
endmodule
