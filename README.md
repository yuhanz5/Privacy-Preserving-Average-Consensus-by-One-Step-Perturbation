# Privacy-Preserving-Average-Consensus-by-One-Step-Perturbation

本项目是论文《Privacy-Preserving Average Consensus by One-Step Perturbation》的实验代码，提供了论文中提出的一步扰动多智能体系统平均一致性算法的MATLAB仿真代码。
代码结构按照论文中的不同实验内容进行组织，可用于复现论文中的主要实验结果与性能对比分析。

论文链接：https://ieeexplore.ieee.org/abstract/document/11354898

This project contains the experimental code for the paper "Privacy-Preserving Average Consensus by One-Step Perturbation", providing MATLAB simulation implementations of the one-step perturbation based average consensus algorithm for multi-agent systems proposed in the paper.

Link:https://ieeexplore.ieee.org/abstract/document/11354898

---

## 目录（Table of Contents）

### `comparison/`

不同算法之间性能对比的运行脚本以及实验数据文件，包括：

- 算法运行轨迹对比（fig.1），代码文件对应`comparison/algo_*.m`
- 总误差（total error）对比（fig.2），代码文件对应`comparison/totalerror.m`
- 运行效率（runtime）对比（fig.3），代码文件对应`comparison/timetest.m`
- 隐私性能验证（fig.4），代码文件对应`comparison/algo_our.m`

### `multi-dimensional`

用于验证所提算法在多维状态多智能体系统中的适用性和高效性，包含两种可适用于多维状态平均一致性算法的对比代码以及实验数据配置文件。

该部分主要包括：

- 总误差（total error）对比（fig.5.a），代码文件对应`multi-dimensional/comp_total.m`
- 运行效率（runtime）对比（fig.5.b），代码文件对应`multi-dimensional/timetest2.m`

---


## 使用方法 Getting Started

运行不同实验前，请先进入对应目录：

```matlab
cd comparison
cd multi-dimensional
```

### Fig.1: Algorithm Trajectory Comparison

运行不同算法的一致性状态轨迹对比实验：

```matlab
algo_*.m
```

该实验用于生成论文中的 Fig.1，展示不同算法的状态收敛过程与运行轨迹。

---

### Fig.2: Total Error Comparison

运行总误差对比实验：

```matlab
totalerror.m
```

该实验对应论文中的 Fig.2，用于比较不同算法在一致性过程中的 total error 变化情况。

---

### Fig.3: Runtime Comparison

运行算法运行效率测试：

```matlab
timetest.m
```

该实验对应论文中的 Fig.3，用于比较不同算法的 runtime 与 computational efficiency。

---

### Fig.4: Privacy Performance

运行隐私保护性能验证实验：

```matlab
algo_our.m
```

该实验对应论文中的 Fig.4，用于展示所提算法在隐私保护性能方面的实验结果。

---

### Fig.5 Multi-Dimensional Scenarios Comparison

运行多维状态下总误差和算法运行效率对比实验：

```matlab
comp_total.m
timetest2.m
```

---

## 依赖 Requirements

- MATLAB R2021a or later

无需额外工具箱依赖。

---



## 项目声明 Project Statement

本项目的作者及单位如下：

- 项目名称（Project Name）: Privacy-Preserving-Average-Consensus-by-One-Step-Perturbation
- 项目作者（Author）: Hanyu Zhao, Yinyan Zhang
- 作者单位（Affiliation）: College of Cyber Security, Jinan University
