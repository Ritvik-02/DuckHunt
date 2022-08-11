# DuckHunt

Duck Hunt -- built by Ritvik Goradia and Advaith Bala

We have recreated the popular NES game “Duck Hunt” on a DE10 Lite FPGA board. The game’s control mechanism utilizes a Mouse Controller, which acts as a gun. The project involves both hardware and software modules built over the FPGA board. We have implemented, using SystemVerilog, essential components such as the System Bus, RAM, Video Display, Controller, and other SPI protocols. Our design also includes a NIOS II CPU for the purposes of interfacing with the Arduino board that processes the input signals from the mouse via USB. We will also use C programming in order to write our game/app logic. Our goal is for a duck to move about the screen in random directions and the user to aim and shoot at the duck using a button on the controller, with each kill increasing the difficulty of the game.

