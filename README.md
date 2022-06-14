# CE213 -  Digital System Design with HDL Project

# Overview
This is a sha256 project implemented on hardware using verilog HDL and software using python.\
The project implements a maximum of 2 blocks, that is the maximum possible input message is 119 characters.\
The project includes Controller and Datapath.\
The steps to implement Sha256 algorithm by Python and Verilog are based on [SHA256 Algorithm](https://en.wikipedia.org/wiki/SHA-2)

# Controller
We break down encryption using sha256 algorithm into 10 states.\
&emsp; State 0: state waiting for start signal.\
&emsp; State 1: state to read input - `data_valid` = 1.\
&emsp; State 2: save block number and reset core block.\
&emsp; State 3: append bit 1 and k bit 0.\
&emsp; State 4: append input length.\
&emsp; State 5: initialize and load initial hash value.\
&emsp; State 6: calculate the first hash in the block.\
&emsp; State 7: iterate 64 times to calculate the hash value. If `loop_finish` = 1, go to next state.\
&emsp; State 8: update hash value. if `block_num` = 0, go to state 9, else go to state 6.\
&emsp; State 9: output the result - `done` = 1.

# Datapath
Datapath includes padding block and core block.
- The padding block will be responsible for writing input message, bit "1", k bits "0" and length of input message in the register file.
- The core block include Message scheduler to generate words for encryption computation and the hash computation block used to encrypt

# Verify
- Structure of Verify\
![verify](https://github.com/sonce139/SHA256-Verilog/blob/main/img/verify.png)
- Structure of Testbench\
![testbench](https://github.com/sonce139/SHA256-Verilog/blob/main/img/testbench.png)

# How to run
- Use command `python SHA256.py -m your_input` to run algorithm with input you want.
- Use command `python SHA256.py -g pre` to run algorithm with input file `messages.txt` with each line in the file will be a corresponding input. Mode `-g post` is similar to mode pre.
- In mode pre (testcases used in pre-synthesis) and post (testcases used in post-synthesis)), we will automatically generate the input file messages.txt. The number of testcases created is defined in the variable `numTestCases`. You can fix it or turn off automatic file creation and add your input file.
- The result of mode pre is `software_results.txt` saved in `SourceCode/` and the result of mode post saved in `SourceCode/simulation/modelsim/`.
- The result after running pre-synthesis and post-synthesis on modelsim is `hardware_results.txt` and saved in the respective folder as above.

# Result
- After running the simulation with ModelSim, we will compare 2 files `software_results.txt` and `hardware_results.txt`.
- Here are the frequency and resource consumption results from the Quartus report (board Cyclone II)
![frequency](https://github.com/sonce139/SHA256-Verilog/blob/main/img/frequency.png)
![resource](https://github.com/sonce139/SHA256-Verilog/blob/main/img/resource.png)

# Team member:
|No.| Full name             |Student ID     |Github|
|:-:|:---------------------:|:---------:|:--------:|
| 1	|[Lê Hoàng Minh](mailto:19520158@gm.uit.edu.vn)| 19520158	|[Le-M1nh](https://github.com/Le-M1nh)|
| 2	|[Lê Xuân Minh](mailto:19521838@gm.uit.edu.vn)| 19521838	  |[XuanMinh201](https://github.com/XuanMinh201)|
| 3	|[Trần Quốc Sơn](mailto:19522142@gm.uit.edu.vn)| 19522142	  |[sonce139](https://github.com/sonce139)|
