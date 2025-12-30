# Building RISC-V Processors

In CPRE 3810 we learned RISC-V and VHDL, built various virtual processors to run RISC-V commands, and learned some other stuff (caching, virtual memory, and other fancy processor things not implemented in labs). However, this repo contains the work done in the lab portion of this course. 
The project portion of this course was done with a partner, so the other contributor to this repo is Shane Nebraska.

## Lab 1 & 2

These two labs were done independently during the first 5 weeks of class. They primarily consisted of getting familiar with VHDL (we built everything with VHDL) and building some of the basic processor components.
These two labs acted as a base for the coming project, as many components built here are used in the later labs. 

## Project part 1

This was where we built a single cycle virtual RISC-V processor. 
For more info on this part of the project see our [lab report](<https://github.com/Wise05/CPRE3810_Fall_2025/blob/main/Proj_part_1/Proj1_report.pdf>), which contains a schematic drawing, aswell as all the RISC-V commands covered.

## Project part 2
This was where we built the software and hardware scheduled processors. 
For more info on this part see our [lab report](<https://github.com/Wise05/CPRE3810_Fall_2025/blob/main/proj2_hw/Proj2_report.pdf>), which contains schematic drawings and other stuff. 

## Installation

If you have any desire to checkout what we did on your own machine, you must install Questasim and RARS. This is what the shell script toolflow requires. There might be some other stuff, but I just used the virtual machine that this class provided where everything was setup, so good luck.

## Where is what
Our VHDL code is in the /proj dir for the various projects (not lab 1 and 2). RISC-V tests are in /internal/boilerplate-riscv/ where we wrote some of our own riscv scripts to test to processor. 
proj2_sw is the software scheduled processor and proj2_hw is the hardware scheduled processor. 
