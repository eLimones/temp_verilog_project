module toplevel(sw,Led);

input [7:0] sw;
output [7:0] Led;

assign Led = sw;

endmodule