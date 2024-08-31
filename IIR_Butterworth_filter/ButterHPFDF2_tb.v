//Dillip S
//ButterHPFDF2

module iir_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    parameter SIM_TIME = 10000; // Simulation time in ns

    // Inputs
    reg signed [15:0] data_in; // Composite input signal

    // Clock and reset
    reg clk;
    reg rst;

    // Outputs
    wire signed [15:0] data_out;

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Instantiate the iir module
    pipelined_iir iir_inst (
        .clk(clk),
        .reset(rst),
        .x(data_in), // Pass composite signal as input
        .y(data_out)
    );

    // Testbench stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        data_in = 0;

        // Wait for a few clock cycles
        #10;

        // Release reset
        //rst = 0;

        // Generate input for the duration of simulation time
        repeat (SIM_TIME / CLK_PERIOD) begin
            // Generate composite signal (100 Hz and 200 Hz components)
            integer freq1 = 100; // Frequency of first component (100 Hz)
            integer freq2 = 200; // Frequency of second component (200 Hz)
            integer amplitude1 = 10000; // Amplitude of first component
            integer amplitude2 = 5000; // Amplitude of second component
            
            // Calculate composite signal
            integer composite_signal = amplitude1 * $sin(2 * $realtime * 3.14 * freq1) +
                                       amplitude2 * $sin(2 * $realtime * 3.14 * freq2);
            
            // Assign composite signal to data_in
            data_in = composite_signal;
            
            #CLK_PERIOD; // Wait for one clock cycle
        end

        // End simulation
        #10;
        $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("Time = %0dns, Input = %d, Output = %d", $time, data_in, data_out);
    end

endmodule