# ⚡ 16-Bit Signed Booth Multiplier

<p align="center">
  <img src="https://img.shields.io/badge/HDL-Verilog-blue?style=for-the-badge&logo=verilog" alt="Verilog">
  <img src="https://img.shields.io/badge/Design-RTL-orange?style=for-the-badge" alt="RTL">
  <img src="https://img.shields.io/badge/Simulation-VIVADO-green?style=for-the-badge" alt="Icarus Verilog">
  <img src="https://img.shields.io/badge/Waveform-VIVADO-purple?style=for-the-badge" alt="GTKWave">
  <img src="https://img.shields.io/badge/FPGA-Vivado-red?style=for-the-badge" alt="Vivado">
</p>

<p align="center">
  <b>A 16-bit signed sequential Booth Multiplier designed from RTL using Verilog HDL.</b>
</p>

---

## 📌 Overview

This project implements a **16-bit signed Booth Multiplier** using **Verilog HDL**.

The design uses the **Booth multiplication algorithm** to perform signed binary multiplication using **two's complement arithmetic**.

The architecture is divided into:

* 🧠 **Control Path**
* 🔧 **Data Path**
* ➕ **Adder/Subtractor**
* 🔄 **Arithmetic Shift Unit**
* 🔢 **Iteration Counter**
* 📦 **A, M, Q and Q-1 Registers**
* ⚙️ **FSM-based Controller**

The final result is a **32-bit signed product**.

---

## ✨ Features

| Feature          | Description              |
| ---------------- | ------------------------ |
| 🔢 Operand Width | 16-bit                   |
| 📤 Product Width | 32-bit                   |
| ➕ Arithmetic     | Signed multiplication    |
| 🧮 Algorithm     | Booth Multiplication     |
| 🔄 Shift         | Arithmetic Right Shift   |
| 🧠 Controller    | FSM                      |
| 🏗️ Architecture | Control Path + Data Path |
| ⏱️ Operation     | Sequential               |
| 🧪 Simulation    | Icarus Verilog           |
| 📊 Waveform      | GTKWave                  |
| 🛠️ RTL Tool     | Vivado                   |
| 💻 Editor        | VS Code                  |

---

# 🏗️ Architecture

```text
                         ┌─────────────────────────┐
                         │    BOOTH MULTIPLIER     │
                         │        16 × 16          │
                         └────────────┬────────────┘
                                      │
                   ┌──────────────────┴──────────────────┐
                   │                                     │
          ┌────────▼────────┐                  ┌─────────▼────────┐
          │   CONTROL PATH  │                  │     DATA PATH     │
          │                 │                  │                   │
          │      FSM        │                  │   A Register      │
          │                 │                  │   M Register      │
          │  Control Logic  │◄────────────────►│   Q Register      │
          │                 │                  │   Q-1 Register    │
          │                 │                  │                   │
          └─────────────────┘                  │ Adder/Subtractor  │
                                               │ Arithmetic Shift  │
                                               │ Counter            │
                                               └─────────┬─────────┘
                                                         │
                                                         ▼
                                                  ┌─────────────┐
                                                  │  32-bit     │
                                                  │  PRODUCT    │
                                                  └─────────────┘
```

---

# 🧮 Booth Algorithm

Booth multiplication examines the two-bit pair:

```text
┌────┬──────┐
│ Q₀ │ Q-1  │
└────┴──────┘
```

The operation is determined using:

| Q₀ Q-1 | Operation    |
| :----: | ------------ |
|  `00`  | No operation |
|  `01`  | `A = A + M`  |
|  `10`  | `A = A - M`  |
|  `11`  | No operation |

After the required operation, an **arithmetic right shift** is performed on:

```text
┌───────┬───────┬──────┐
│   A   │   Q   │ Q-1  │
└───────┴───────┴──────┘
```

This process is repeated for **16 iterations**.

---

# 🔄 Operation Flow

```text
        START
          │
          ▼
   ┌──────────────┐
   │ Load M       │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │ Clear A,Q,Q-1│
   │ Counter = 16 │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │    Load Q    │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │ Check Q₀,Q-1 │
   └──────┬───────┘
          │
     ┌────┴─────┐
     │          │
   01/10       00/11
     │          │
     ▼          │
 ┌─────────┐    │
 │ A ± M   │    │
 └────┬────┘    │
      │         │
      └────┬────┘
           ▼
   ┌──────────────┐
   │ Arithmetic   │
   │ Right Shift  │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │ Decrement    │
   │ Counter      │
   └──────┬───────┘
          │
          ▼
      Counter = 0?
       │       │
      No      Yes
       │       │
       └───┐   ▼
           │  DONE
           │
           └──────► Repeat
```

---

# 📂 Project Structure

```text
Booth-Multiplier/
│
├── RTL/
│   ├── Booth_multi.v
│   ├── Control_Path.v
│   └── Data_Path.v
│
├── Simulation/
│   └── BM_tb.v
│
├── Waveforms/
│   └── booth_waveform.png
│
├── README.md
└── .gitignore
```

---

# 🧩 RTL Modules

### `Booth_multi.v`

Top-level module connecting the complete Booth multiplier.

### `Control_Path.v`

Implements the FSM and generates control signals for the datapath.

### `Data_Path.v`

Contains:

```text
A Register
M Register
Q Register
Q-1 Flip-Flop
Adder/Subtractor
Shift Unit
Counter
```

### `BM_tb.v`

Testbench used for functional verification of signed multiplication.

---

# 🧪 Simulation

## 1️⃣ Compile

Using **Icarus Verilog**:

```bash
iverilog -g2012 -o simv BM_tb.v Booth_multi.v Control_Path.v Data_Path.v
```

## 2️⃣ Run

```bash
vvp simv
```

## 3️⃣ Generate Waveform

The testbench generates:

```text
booth.vcd
```

## 4️⃣ Open GTKWave

```bash
gtkwave booth.vcd
```

---

# 📊 Verification

The design was tested with signed operands including:

| Multiplicand | Multiplier | Expected Product |
| :----------: | :--------: | :--------------: |
|      `5`     |     `3`    |       `15`       |
|     `-5`     |     `3`    |       `-15`      |
|      `5`     |    `-3`    |       `-15`      |
|     `-5`     |    `-3`    |       `15`       |

### Example

```text
Multiplicand = -5
Multiplier   = 3

Result = -15
```

---

# 📈 GTKWave

Waveform verification can be performed by observing:

```text
clk
rst
data_in
A
M
Q
Q-1
q_out
count
state
done
data_out
```

These signals allow the complete Booth multiplication sequence to be examined cycle-by-cycle.

---

# 🛠️ Tools & Technologies

<p align="center">

| Tool                  | Purpose                 |
| --------------------- | ----------------------- |
| 🟦 **Verilog HDL**    | RTL Design              |
| 🔴 **Vivado**         | FPGA / RTL Development  |
| 🟢 **Icarus Verilog** | Simulation              |
| 🟣 **GTKWave**        | Waveform Analysis       |
| 🖥️ **VS Code**       | Development Environment |
| 🐙 **GitHub**         | Version Control         |

</p>

---

# 📚 Key Concepts

Through this project, I explored:

```text
✓ Booth Multiplication
✓ Signed Binary Arithmetic
✓ Two's Complement
✓ Sequential RTL Design
✓ FSM Design
✓ Control Path & Data Path
✓ Arithmetic Right Shift
✓ Register Design
✓ Adder/Subtractor Design
✓ Counter Design
✓ Verilog Module Instantiation
✓ Testbench Development
✓ RTL Simulation
✓ Waveform Analysis
```

---

# 🚀 Future Improvements

* [ ] Parameterized Booth Multiplier
* [ ] Radix-4 Modified Booth Multiplier
* [ ] Pipelined Booth Multiplier
* [ ] Wallace Tree Multiplier
* [ ] Array Multiplier Comparison
* [ ] FPGA Resource Utilization Analysis
* [ ] Timing Analysis
* [ ] Power Analysis
* [ ] Integration with an ALU
* [ ] Integration into a Processor Datapath

---

# 🎯 Learning Outcome

This project strengthened my understanding of **RTL design and digital hardware architecture**, particularly the interaction between a **finite state machine and datapath**.

It also provided practical experience with **signed arithmetic, sequential logic, Verilog HDL, simulation, debugging, and waveform-based verification**.

---

# 👨‍💻 Author

### **Sarih**

🎓 Electronics & Communication Engineering
💻 VLSI & Digital Design Enthusiast

Currently exploring:

```text
Verilog HDL
       ↓
Digital VLSI
       ↓
Computer Architecture
       ↓
Processor Design
       ↓
ASIC / FPGA Design
```

---

## ⭐ If you find this project useful

Feel free to **⭐ star the repository** and explore the RTL implementation.

---

<p align="center">
  <b>⚡ Building Digital Hardware • One RTL Block at a Time ⚡</b>
</p>

<p align="center">
  <sub>Designed with Verilog HDL | Simulated with Icarus Verilog | Verified with GTKWave</sub>
</p>
