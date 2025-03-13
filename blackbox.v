import chisel3._
import chisel3.experimental.{BlackBox, HasBlackBoxInline}

class ModelDPIBlackBox extends BlackBox with HasBlackBoxInline {
  val io = IO(new Bundle {
    val clock       = Input(Clock())
    val reset       = Input(Bool())
    val cycle_valid = Input(Bool())
    val cycle_num   = Input(UInt(32.W))
    val done        = Output(Bool())
  })

  setInline("ModelDPI.sv",
    s"""
      |module ModelDPI (
      |    input  logic         clock,
      |    input  logic         reset,
      |    input  logic         cycle_valid,
      |    input  logic [31:0]  cycle_num,
      |    output logic         done
      |);
      |
      |    import "DPI-C" function void model_init(input string instr_filename, input int verbose, input bit dump_csv);
      |    import "DPI-C" function void model_cycle(input int cycle);
      |    import "DPI-C" function void model_finalize();
      |
      |    always_ff @(posedge clock) begin
      |        if (reset) begin
      |            model_init("instruction.txt", 1, 1);
      |        end else if (cycle_valid) begin
      |            model_cycle(cycle_num);
      |        end
      |    end
      |
      |    assign done = cycle_valid;
      |
      |endmodule
    """.stripMargin)
}
