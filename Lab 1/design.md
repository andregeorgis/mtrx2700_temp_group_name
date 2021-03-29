# Current Integration Program

From the documentation the current high level overview of the problem is:

1. Define variables for ascii checks and configure the serial port
2. Read a string from serial until carriage return is read
3. Check to see if button `PH0` has been pressed, if so go to step 4, otherwise go to step 5
4. Capitalize the string read from serial then go to step 6
5. Make the string read from serial uppercase
6. Transmit the modified string to serial then go to step 2



# Issues

The main issue is that in order for the serial communication to work, we employ polling which implies waiting for the serial to be ready. But at the same time the 7-Segment code uses delays and counters to ensure that the LEDs have enough time to turn on and that a specific 4-letter string is turned on for long enough to be legible. So we have conflicting intentions here.

If we spend too many cycles on the display, we may miss reading some bytes from serial. However, if we spend too many cycles on the serial, our display may look flickery.



# Approach #1

1. Define variables for ascii checks and configure the serial port
2. Display the current string, constantly checking for a byte from serial and if receiving one, turn off display and go to step 3
3. Read a string from serial until carriage return is read
4. Check to see if button `PH0` has been pressed, if so go to step 4, otherwise go to step 5
5. Capitalize the string read from serial then go to step 6
6. Make the string read from serial uppercase
7. Transmit the modified string to serial then go to step 2

The first approach is to simply stop displaying when a string is sent, and keep displaying when the whole string has been sent. This would require careful use of memory to keep track of where we are in the string, however time-wise is quite a simple approach and should have few issues.



# Approach #2

1. Define variables for ascii checks and configure the serial port
2. Read a byte from serial; if the byte is a carriage return go to step 4
3. Display a 4-character string on the 7-Segments then go back to step 2 - this string should be displayed a number of times before incrementing in the string
4. Check to see if button `PH0` has been pressed, if so go to step 4, otherwise go to step 5
5. Capitalize the string read from serial then go to step 6
6. Make the string read from serial uppercase
7. Transmit a byte of the modified string to serial; if the byte is the carriage return go to step 2
8. Display a 4-character string on the 7-Segments then go back to step 7 - this string should be displayed a number of times before incrementing in the string

The second approach is a lot more complicated and involves interweaving the display and the serial communication. It heavily relies on the fact that we are communicating at 9600 bps which means that less than 2500 cycles can be made before the next bit is sent:
$$
\frac{24000000}{9600} = 2500
$$
Currently to display one 4-character string takes approximately 4300 cycles in the code for Exercise Two, however we can easily shorten the delays to ensure that we are performing less than 2500 cycles - only issue is lights may be dimmer.