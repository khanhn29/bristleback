# Bristleback: Smart Door Security System

This project implements a smart door security system using C and AVR microcontrollers. It reads data from various sensors, controls motors, and communicates with a PC via UART (RS232).

## Overview

The system monitors door status, gas concentration, and provides feedback to the user via a serial connection.  Key features include:

* **UART Communication:** Establishes a serial communication link with a PC for data logging and control.
* **Motor Control:** Controls motors for locking/unlocking the door (or other actuators).
* **Door Status Detection:** Detects the open/closed state of the door using a switch.
* **Gas Concentration Monitoring:** Reads gas concentration levels from a sensor.
* **Periodic Message Transmission:** Sends sensor data and system status updates to the PC at regular intervals.

## Hardware Requirements

* AVR Microcontroller (Specify the exact model used, e.g., ATmega328P)
* Door Switch (e.g., reed switch, microswitch)
* Gas Sensor (Specify the sensor model used, e.g., MQ-2, MQ-7)
* Motor Driver (Specify the driver IC, e.g., L298N, ULN2003)
* Motors (e.g., Servo motor, DC motor with appropriate gearing)
* RS232 Converter (for connecting to the PC's serial port)
* Jumper wires, breadboard (or PCB), power supply

## Software Requirements

* AVR Toolchain (e.g., avr-gcc, avrdude)
* Terminal program (e.g., PuTTY, RealTerm) for communication with the PC
* (Optional) Development environment (e.g., Atmel Studio, Eclipse with AVR plugin)

## Build Instructions

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/khanhn29/DoorGuard.git
   cd DoorGuard 
