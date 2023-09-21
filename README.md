# Bluetooth-Controlled-Smart-Fan

Bluetooth is a short-range Wireless Personal Area Network (WPAN) technology, operating in the globally unlicensed industrial, scientific, and medical (ISM) band in the frequency range of 2.4 GHz to 2.485 GHz. In Bluetooth technology, data is divided into packets. Each packet is transmitted on one of the 79 designated Bluetooth channels. The bandwidth of each channel is 1 MHz. Bluetooth implements the frequency-hopping spread spectrum (FHSS) scheme to switch a carrier between multiple frequency channels by using a pseudorandom sequence known to the transmitter and the receiver. The Bluetooth standard specifies these PHY modes: Basic rate (BR) - Mandatory mode, uses Gaussian frequency shift keying (GFSK) modulation with a data rate of 1 Mbps. Enhanced data rate (EDR) - Optional mode, uses phase shift keying (PSK) modulation with these two variants: • EDR2M: Uses pi/4-DQPSK with a data rate of 2 Mbps • EDR3M: Uses 8-DPSK with a data rate of 3 Mbps This end-to-end Bluetooth BR/EDR PHY simulation determines BER and PER performance of one Bluetooth packet that has RF impairments and AWGN. Each packet is generated over a loop of a vector equal to length of the energy-to-noise density ratio (Eb/No) using the bluetoothWaveformGenerator function by configuring the bluetoothWaveformConfig object. To accumulate the error rate statistics, the generated waveform is altered with RF impairments and AWGN before passing through the receiver. These RF impairments are used to distort the packet: • DC offset • Carrier frequency offset • Static timing offset • Timing drift White Gaussian noise is added to the generated Bluetooth BR/EDR waveforms. The distorted and noisy waveforms are processed through a practical Bluetooth receiver performing these operations: • Remove DC offset • Detect the signal bursts • Perform matched filtering • Estimate and correct the timing offset • Estimate and correct the carrier frequency offset • Demodulate BR/EDR waveform
• Perform forward error correction (FEC) decoding • Perform data de-whitening • Perform header error check (HEC) and cyclic redundancy check (CRC) • Outputs decoded bits and decoded packet statistics based on decoded lower address part (LAP), HEC, and CRC.

Introduction: In this project, we will explore how to control a DC motor's speed and direction via Bluetooth through a mobile app. We will use pulse-width modulation (PWM) and direction control signals to adjust the motor's speed and direction, respectively. This project is not only fun and engaging but also provides an excellent opportunity to learn about microcontrollers, motor drivers, Bluetooth modules, and mobile app development.
Objectives: The primary objectives of this project are:
• To build a circuit that controls the speed and direction of a DC motor using a microcontroller board and a motor driver IC.
• To establish a Bluetooth connection between the microcontroller board and a mobile device using a Bluetooth module.
• To develop a mobile app that can send commands to the microcontroller board to control the DC motor's speed and direction.
Methodology: The project will involve the following steps:
• Selecting a suitable DC motor and motor driver IC that can handle the motor's voltage and current requirements.
• Setting up the motor driver circuit and connecting the DC motor to the circuit.
• Choosing a microcontroller board and a Bluetooth module that are compatible with each other.
• Connecting the microcontroller board and the Bluetooth module to the motor driver circuit.
• Developing a mobile app that can send PWM and direction control signals to the microcontroller board.
• Writing the code for the microcontroller board to receive data from the Bluetooth module and control the DC motor's speed and direction.
• Testing the circuit by connecting the mobile app to the Bluetooth module and sending commands to the microcontroller board to control the DC motor.
Expected Results: Upon completion of this project, we expect to have a functional circuit that can control the speed and direction of a DC motor using a mobile app via Bluetooth. We will also have gained practical knowledge of microcontrollers, motor drivers, Bluetooth modules, and mobile app development.
Conclusion: This project provides an excellent opportunity to learn about the basics of electronics, microcontrollers, and mobile app development. It also demonstrates how to control a DC motor's speed and direction using pulse-width modulation and direction control signals via Bluetooth. With this project, we hope to inspire others to explore the world of electronics and embedded systems.
Components Required
We will need:
• An Arduino Uno.
• A Bluetooth Low Energy (BLE) module, such as the HC-06 which is a slave only, or the HC-05 that can be a master or slave. Either will work because the module will be used as a slave. They also share the same four middle pins, which are the only ones we need.
• An L293D motor driver IC. This 16-pin dual H-bridge motor driver will allow us to control the spinning direction and speed of the motor.
• A 12V DC motor.
• A 12V battery pack.
• A power source for the Arduino.
• Jumper wires and a breadboard.
