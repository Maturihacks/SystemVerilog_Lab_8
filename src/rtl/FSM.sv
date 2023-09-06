module mult_fsm#(parameter N = 8) 
    (
    input logic clk ,
    input logic Q0,
    input logic Q_1,
    input logic Valid,
    input logic ticks,
    input logic reset,
    output mult_control_t mult_control,
    output logic Done
) ;

typedef enum logic [2:0]   {stand_by    = 3'b000,
                            first_state = 3'b001,
                            addition_state = 3'b010,
                            substraction_state = 3'b100,
			                shifting_state = 3'b101,
			                end_state = 3'b110
					        } state_vector;

//state_vector current_state
state_vector  current_state, next_state;

//Sequential Logic
always_ff@(posedge clk or posedge reset)
        if (reset)   
            current_state <= stand_by;
        else  
            current_state <= next_state;



always_comb
begin

    unique case (current_state) // Ensure a paralell case
        stand_by: begin 
        //Stay in stand_by while there is no valid data
                if (Valid) begin
			next_state = first_state;
			end
                else 
                    next_state = stand_by;
            end

        first_state : begin
		if (Q0 == Q_1)
		        next_state = shifting_state;
		else 	begin
				if (Q0)
				next_state = addition_state;
				else
				next_state = substraction_state;
			end
	      end
        addition_state: begin
		            next_state = shifting_state;
            end
        substraction_state: begin
		            next_state = shifting_state;
            end
        shifting_state: begin
                if (ticks)
                        next_state = end_state;
                else
		next_state = first_state;
            end
	end_state : begin
		            next_state = stand_by;
		end
	        default : next_state = stand_by;
    endcase
end




// output state logic
always_comb
begin
    mult_control = '{default:'0};
    Done = 0; 
    unique case (current_state) // Ensure a paralell case (no priority)
        stand_by: begin 
                mult_control = '{load_A : 1, load_B : 1, load_add : 0, shift_HQ_LQ_Q_1 : 0, add_sub : 0};
		        Done = 0;
            end
        first_state: begin
		        mult_control = '{default:'0};
		        Done = 0;
            end
	    addition_state : begin
                mult_control = '{load_A : 0, load_B : 0, load_add : 1, shift_HQ_LQ_Q_1 : 0, add_sub : 1};
		        Done = 0;
            end
	    substraction_state : begin
                mult_control = '{load_A : 0, load_B : 0, load_add : 1, shift_HQ_LQ_Q_1 : 0, add_sub : 0};
		        Done = 0;
            end
	    shifting_state : begin
                mult_control = '{load_A : 0, load_B : 0, load_add : 0, shift_HQ_LQ_Q_1 : 1, add_sub : 0};
		        Done = 0;
            end
        end_state : begin
                mult_control = '{load_A : 0, load_B : 0, load_add : 0, shift_HQ_LQ_Q_1 : 0, add_sub : 0};
		        Done = 1;
            end
        default :   begin
                mult_control = '{default:'0};
                Done = 0;
        end 
    endcase
end
endmodule