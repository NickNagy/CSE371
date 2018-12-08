# Digital Design

IMPORTANT NOTES: 

DE1_SoC.sv and top.v modified from: https://class.ece.uw.edu/271/hauck2/de1/index.html

Additional files from same directory (ie not included in this repository) are required for this project to compile.

top.sv is the top-level module for all files except for DE1_SoC.sv. It is for driving audio through the DE1 board, between mic in and line out. It instantiates audioLooper.sv, a module I designed for the purposes of sampling and looping audio.

There is a module called audioLooperAdvanced.sv, which is a modified/expaned upon version of audioLooper.sv, but has more bugs/is incomplete.

The DE1_SoC.sv file is for a course project, which asked us to incorporate audio, video and additional peripherals, using them however we want to. I take pride in the audio portion of the project, but the rest of the design I care less about as it feels irrelevant to what my goal was (in fact it was detrimental to my sampling memory constraints), and prefer to think of top.sv as my true overall design. I have included DE1_SoC.sv nonetheless.
