/* 
 *	Controller module for DD onboarding.
 *	Manages reading from memory, performing additions, and writing results back to memory.
 *
 *	This module can and should be modified but do not change the interface.
*/
module controller import calculator_pkg::*;(
	// DO NOT MODIFY THESE PORTS
  	input  logic              clk_i,
    input  logic              rst_i,
  
  	// Memory Access
    input  logic [ADDR_W-1:0] read_start_addr,
    input  logic [ADDR_W-1:0] read_end_addr,
    input  logic [ADDR_W-1:0] write_start_addr,
    input  logic [ADDR_W-1:0] write_end_addr,
  
  	// Memory Controls
    output logic 						write,
	output logic 						read,
    output logic [ADDR_W-1:0]			w_addr,
    output logic [MEM_WORD_SIZE-1:0]	w_data,
    output logic [ADDR_W-1:0]			r_addr,
    input  logic [MEM_WORD_SIZE-1:0]	r_data,

  	// Buffer Control (1 = upper, 0, = lower)
    output logic buffer_control,
  
  	// These go into adder
  	output logic [DATA_W-1:0] op_a,
    output logic [DATA_W-1:0] op_b,

	// Carry input for adder
	output logic carry_in,	// Carry input to adder
	input  logic carry_out, // Carry output from adder
	
	// What is being stored in the buffer
    input  logic [MEM_WORD_SIZE-1:0] buff_result
  
); 

	// DO NOT MODIFY THIS BLOCK: Count how many cycles the controller has been active
	logic [31:0] cycle_count;
	always_ff @(posedge clk_i) begin
		if (rst_i)
			cycle_count <= 32'd0;
		else
			cycle_count <= cycle_count + 1'b1;
	end
	//=========================================================================
	// You can change anything below this line. There is a skeleton but feel
	// free to modify as much as you want.
	//=========================================================================

	// Declare state machine states
    state_t state, next;
	//buffer_loc_t buffer_loc;

	// Registers to hold read data for current and next reads
	logic [ADDR_W-1:0] r_ptr, w_ptr;
  	logic carry_reg;
	//logic [MEM_WORD_SIZE-1:0] r_data_reg;
	logic [MEM_WORD_SIZE-1:0] w_data_reg;
	logic [MEM_WORD_SIZE-1:0] r_data_a;
	logic [MEM_WORD_SIZE-1:0] r_data_b;
	
	//Next state logic
	always_comb begin
		case (state)
			S_IDLE:      next = S_READ;   
			S_READ:      next = S_READ_WAIT;
			S_READ_WAIT: next = S_READ2;
			S_READ2:     next = S_READ2_WAIT;
			S_READ2_WAIT: next = S_ADD;
			S_ADD:       next = S_ADD2;
			S_ADD2:      next = S_LATCH_RESULT;
			S_LATCH_RESULT: next = S_WRITE_LOWER;
			S_WRITE_LOWER: next = S_WRITE_UPPER;
			S_WRITE_UPPER: begin
				if (w_ptr==write_end_addr) begin
					next = S_END;
				end
				else begin
					next = S_READ;
				end
			end
			S_END:       next = S_END;
			default:     next = S_IDLE;
		endcase
	end

	// Sequential part of state machine implementation, move points around
	// This code block is very redundant fix/simplify later.
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
			r_ptr <= read_start_addr;
			w_ptr <= write_start_addr;
			state <= S_IDLE;
			//buffer_loc <= LOWER;
			carry_reg <= 1'b0;
			r_data_a <= '0;
			r_data_b <= '0;
			w_data_reg <= '0;
		end
		else begin
			state <= next;
			case (state)
				S_IDLE: begin
					r_ptr <= r_ptr;
					w_ptr <= w_ptr;
					//buffer_loc <= buffer_loc;
					carry_reg <= 1'b0;
				end
				S_READ: begin
					//r_ptr <= r_ptr + 1'b1;
					//r_data_a <= r_data;
					w_ptr <= w_ptr;
					//buffer_loc <= buffer_loc;
					//carry_reg <= 1'b0;
				end
				S_READ_WAIT: begin
					r_data_a <= r_data;
				end
				S_READ2: begin
					//r_data_b <= r_data;
					r_ptr <= r_ptr;
					w_ptr <= w_ptr;
					//buffer_loc <= buffer_loc;
					carry_reg <= carry_reg;
				end
				S_READ2_WAIT: begin
					r_data_b <= r_data;
					//r_ptr <= r_ptr + 2'd2;
				end
				S_ADD: begin
					r_ptr <= r_ptr;
					w_ptr <= w_ptr;
					//buffer_loc <= LOWER;
					carry_reg <= carry_out;
				end
				S_ADD2: begin
					r_ptr <= r_ptr;
					w_ptr <= w_ptr;
					//buffer_loc <= UPPER;
					//w_data_reg <= buff_result;
					//carry_reg <= carry_out;
				end
				S_LATCH_RESULT: begin
					w_data_reg <= buff_result;
					carry_reg <= 1'b0;
				end
				S_WRITE_LOWER: begin
				end
				S_WRITE_UPPER: begin
					w_ptr <= w_ptr + 1'b1;
					r_ptr <= r_ptr + 2'd2;
					//buffer_loc <= UPPER;
					//carry_reg <= 1'b0;
				end
				S_END: begin
					r_ptr <= r_ptr;
					w_ptr <= w_ptr;
					//buffer_loc <= buffer_loc;
					carry_reg <= carry_reg;
				end
				default: begin
					r_ptr <= r_ptr;
					w_ptr <= w_ptr;
					//buffer_loc <= buffer_loc;
					carry_reg <= carry_reg;
				end
			endcase
		end
	end


	// Combinational output logic
	always_comb begin
        // Default values
        write = 1'b0;
        read = 1'b0;
		r_addr = r_ptr;
		w_addr = w_ptr;
		carry_in = 1'b0;
		op_a = '0;
		op_b = '0;
		buffer_control = 1'b0;
		w_data = w_data_reg;

        case (state)  
            S_IDLE: begin
                // Do nothing
            end
            S_READ: begin
                read = 1'b1;
				r_addr = r_ptr;				
            end
			S_READ_WAIT: begin
                //read = 1'b1;
				//r_addr = r_ptr;				
            end
			S_READ2: begin
				read = 1'b1;
				r_addr = r_ptr + 1'b1;
			end
			S_READ2_WAIT: begin
				//read = 1'b1;
				//r_addr = r_ptr + 1'b1;
			end
			S_ADD: begin
				// Check op_a and op_b assignments
				op_a = r_data_a[DATA_W-1:0];
				op_b = r_data_b[DATA_W-1:0];
				//carry_in = 1'b0;
				buffer_control = 1'b0;
			end
			S_ADD2: begin
				op_a = r_data_a[MEM_WORD_SIZE-1:DATA_W];
				op_b = r_data_b[MEM_WORD_SIZE-1:DATA_W];
				carry_in = carry_reg;
				buffer_control = 1'b1;
			end
			S_WRITE_LOWER: begin
				write = 1'b1;
				w_addr = w_ptr;
				buffer_control = 1'b0;
			end
			S_WRITE_UPPER: begin
				write = 1'b1;
				w_addr = w_ptr;
				buffer_control = 1'b1;
			end
            S_END: begin
                // Defaults
				//w_data = buff_result;
            end
        endcase
    end
  endmodule
