/*
 * This package defines common parameters used across various modules in the design to ensure consistency and ease of maintenance. 
 * It includes parameters for data width, memory word size, and address width (defined by size of SRAM).
 *
 * You can and should modify this file to add additional states as needed.
 */
`define functional
package calculator_pkg;
    //parameter for size of data (adder size)
    parameter DATA_W = 32;

    //parameter for size of memory word
    parameter MEM_WORD_SIZE = 64;

    parameter ADDR_W = 10   ;

    // TODO: Declare additional state(s) as needed
    // DO NOT REMOVE S_IDLE AND S_END STATES

    typedef enum logic [7:0] {S_IDLE, S_READ, S_READ_WAIT, S_READ2, S_READ2_WAIT, S_ADD, S_ADD2, S_LATCH_RESULT, S_WRITE_LOWER, S_WRITE_UPPER, S_END} state_t;
    typedef enum logic {LOWER, UPPER} buffer_loc_t;

endpackage
