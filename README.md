# uvm-s02

#### 介绍
取自张强《UVM实战》第二章的UVM源码

#### 软件架构
    uvm_s02/
    ├── dut
    │   └── wrapper.v
    ├── sim
    │   ├── Makefile
    │   ├── rtl.list
    │   └── uvm.list
    └── testbench
        ├── component
        │   ├── agent
        │   │   └── agent.sv
        │   ├── case
        │   │   ├── case0.sv
        │   │   ├── case1.sv
        │   │   └── case2.sv
        │   ├── driver
        │   │   └── driver_dut.sv
        │   ├── env
        │   │   └── env.sv
        │   ├── model
        │   │   └── model.sv
        │   ├── monitor
        │   │   └── monitor.sv
        │   ├── scoreboard
        │   │   └── scoreboard.sv
        │   ├── sequencer
        │   │   └── sequencer.sv
        │   └── transaction
        │       └── transaction_dut.sv
        ├── interface
        │   └── interface_dut.sv
        └── tb_top.sv


#### 安装教程

1.  开发环境搭建参考：[UVM学习之路（1）— CentOS 7虚拟机下安装VCS开发环境](https://blog.csdn.net/qq_38113006/article/details/120803926)
2.  开发工具使用参考：[UVM学习之路（2）— 使用VCS+Verdi进行仿真调试](https://blog.csdn.net/qq_38113006/article/details/120921003)
3.  开发环境使用说明：[UVM学习之路（3）— 基于UVM的第一个Hello程序](https://blog.csdn.net/qq_38113006/article/details/120924689)
4.	本仓库的代码说明：[UVM学习之路（4）— 基本的UVM验证平台](https://blog.csdn.net/qq_38113006/article/details/121915720)

#### 使用说明

修改 sim/Makefile 中的`./simv +UVM_TESTNAME=case0`中的case0为case1和case2可使用不同的sequence传递方式
1.  case0: 使用default_sequence，通过config_db方式传递
    ```verilog
    // ./testbench/component/case/case0.sv 

    /* 1. use default_sequence */
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.in_agt.sqr.main_phase", 
                                            "default_sequence", case0_sequence::type_id::get());
    ```
2.  case1: 在uvm_test中手动创建sequence，并手动设置starting_phase供uvm_sequence的body()任务使用
    ```verilog
    // ./testbench/component/case/case1.sv 

    virtual task main_phase(uvm_phase phase);
        /* 2. not use default_sequence */
        case1_sequence seq;
        seq = case1_sequence::type_id::create("seq");
        // set starting_phase for uvm_sequence.body() task
        seq.starting_phase = phase;
        seq.start(env.in_agt.sqr);
    endtask 
    ```
3.  case2: 直接在uvm_test的main_phase方法中提起和释放objection，不再uvm_sequence的body()任务里使用
    ```verilog
    // ./testbench/component/case/case2.sv 

    virtual task main_phase(uvm_phase phase);
        /* 3. not use default_sequence, in addition set objection raise and drop in this */
        case2_sequence seq;
        phase.raise_objection(this);
        seq = case2_sequence::type_id::create("seq");
        seq.starting_phase = phase;
        seq.start(env.in_agt.sqr);
        phase.drop_objection(this);
    endtask art(env.in_agt.sqr);
    ```

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
