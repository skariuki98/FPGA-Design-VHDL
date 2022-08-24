# Client-Server Divider Model
The project presented here is a client-server model of a divider which uses a handshake protocol to transmit data between the client and server.

When values are entered into the server, the server first checks for either divider of 0 or any undefined values. If the divider is 0, the server sets an error flag to 1 and the d_valid is set to 0.

If both values entered a valid, the d_valid flag is set to 1 and the server sends a ready signal to the client, which signals intent to send data.
The client then receives the values and checks for errors, e.g, dividing by zero using d_valid signal.

If no errors are present, the division is done, the quotient is sent to the server along with the ack (acknowledgement). Next, the Remainder is sent to the server and the ack is set to 0.

The server receives the Ack signal and sets done = 1 to terminate the program.

client_driver.vhd contains the testbench run for simulation

server.vhd contains the server set up

client.vhdl contains the client set up
