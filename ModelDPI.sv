module ModelDPI (
    input  logic         clock,
    input  logic         reset,
    input  logic         cycle_valid, // 外部触发推进周期
    input  logic [31:0]  cycle_num,   // 当前周期数
    output logic         done         // 当前周期已完成
);

    // 导入 C 接口函数
    import "DPI-C" function void model_init(input string instr_filename, input int verbose, input bit dump_csv);
    import "DPI-C" function void model_cycle(input int cycle);
    import "DPI-C" function void model_finalize();

    // 状态机示例：复位时调用 model_init，之后在每个周期调用 model_cycle
    always_ff @(posedge clock) begin
        if (reset) begin
            // 在复位期间调用初始化函数（可通过参数传入固定文件名、verbose 等）
            model_init("instruction.txt", 1, 1);
        end else if (cycle_valid) begin
            model_cycle(cycle_num);
        end
    end

    // 结束信号：这里仅作示例，实际可以设计一个合适的结束时机
    assign done = cycle_valid;

endmodule
