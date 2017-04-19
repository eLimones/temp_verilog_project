
main:
    move $t0, 0 ; c = 0

        ;outer loop start
    move $t1, 0 ; for(int i = 0, _, _)
   j outer_loop_condition
outer_loop_block:

        ;inner loop start
   move $t2, 0 ; for(int j = 0, _, _)
   j inner_loop_condition
inner_loop_block:

    add $t0, $t0, 1;  c++

    add $t2, $t2, 1;  for(_, _, j++)
inner_loop_condition:
    blt $t2, 40, inner_loop_block ; for(_, j < 40, _)
        ;inner loop end

    add $t1, $t1, 1;  for(_, _, j++)
outer_loop_condition:
    blt $t1, 1000, outer_loop_block ; for(_, i < 1000, _)
        ; outer loop end

    move $v0, $t0; return c
    jr $ra
