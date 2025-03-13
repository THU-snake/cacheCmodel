// model_wrapper.cpp
#include "l1_data_cache.h"
#include "DEBUG_L2_model.h"
#include "l1_data_cache.h"
#include <iostream>
#include <fstream>
#include <string>
#include "your_test_env_header.h" // 假设 test_env 定义在此文件中

// 声明对外接口时，记得加 extern "C"
#ifdef __cplusplus
extern "C" {
#endif

    // 定义内部全局变量保存环境实例和文件流
    static test_env* env = nullptr;
    static std::ifstream* instr_file = nullptr;
    static std::ofstream* waveform_file = nullptr;

    /**
     * @brief 模型初始化接口
     * @param instr_filename 指令文件名（仿真用）
     * @param verbose 调试信息级别
     * @param dump_csv 是否导出 CSV 波形
     */
    void model_init(const char* instr_filename, int verbose, bool dump_csv) {
        // 创建 test_env 实例
        env = new test_env(verbose, dump_csv);
        // 打开指令输入文件
        instr_file = new std::ifstream(instr_filename);
        if (!instr_file->is_open()) {
            std::cerr << "Error: cannot open file " << instr_filename << std::endl;
            return;
        }
        // 打开波形输出文件
        waveform_file = new std::ofstream("waveform_result.csv");
        // 输出配置摘要和波形标题
        env->print_config_summary();
        env->DEBUG_waveform_title(*waveform_file);
    }

    /**
     * @brief 推进模型一个周期，调用仿真环境中的周期函数
     * @param cycle 当前周期数
     */
    void model_cycle(int cycle) {
        if (env && instr_file && waveform_file) {
            // 调用 DEBUG_cycle 推进一个周期，波形写入 waveform_file
            env->DEBUG_cycle(cycle, *instr_file, *waveform_file);
        }
    }

    /**
     * @brief 模型结束接口，释放资源并关闭文件
     */
    void model_finalize() {
        if (waveform_file) {
            waveform_file->close();
            delete waveform_file;
            waveform_file = nullptr;
        }
        if (instr_file) {
            instr_file->close();
            delete instr_file;
            instr_file = nullptr;
        }
        if (env) {
            delete env;
            env = nullptr;
        }
    }

#ifdef __cplusplus
}
#endif
