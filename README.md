# The-Very-Hungry-Caterpillar
CPE 2300 team project designing a Very Hungry Caterpillar game in RISC-V Assembly code
.equ FB,      0x20000000    #offset
.equ PAL,     0x21000000    #palette location
.equ PRESENT, 0x21001008     
.equ W,       128            #screen width for conversion

.text
color:
    li t0, PAL
    li t1, 0x449D44         #green
    sw t1, 0(t0)
    li t1, 0x66BF55         #light green
    sw t1, 4(t0)
    li t1, 0x375F38         #dark green
    sw t1, 8(t0)
    li t1, 0xFFA500         #orange
    sw t1, 12(t0)

show:
    li   t0, PRESENT
    sw   t0, 0(t0)
    li   a7, 10
    ecall

draw_func:
    mv t1, a2          #starting y
    add t3, t1, a3     #end y
y_check:
    beq t1, t3, end
    mv t0, a0          #starting x
    add t2, t0, a1     #end x
convert:
    addi sp, sp, -4
    sw t1, 4(sp)
    beq t0, t2, next_y
    li t5, W
    mul t6, t1, t5        
    add t6, t6, t0     #convert to domain position
    li t4, FB
    add t6, t6, t4     #add color offset
    sb a4, 0(t6)       #load color in chosen pixel
    addi t0, t0, 1
    j convert
next_y:
    addi t1, t1, 1
    j y_check
end:
    ret
fruit_func:
    mv   t4, a0          # center x
    mv   t5, a1          # center y
    mv   t6, a2          # radius
    mv   a4, a3          # color
    mul  a5, t6, t6      # radius squared
    sub  a1, zero, t6    #-radius
circle_y:
    bgt  a1, t6, circle_done
    sub  a0, zero, t6    #-radius
circle_x:
    bgt  a0, t6, next_y  
    mul  t0, a0, a0      
    mul  t1, a1, a1
    add  t0, t0, t1
    bgt  t0, a5, skip
    add  t2, t4, a0
    add  t3, t5, a1
    li   t0, W
    mul  t3, t3, t0
    add  t3, t3, t2
    li   t0, FB
    add  t3, t3, t0
    sb   a4, 0(t3)
skip:
    addi a0, a0, 1
    j circle_x
next_y_center:
    addi a1, a1, 1
    j circle_y
circle_done:
    ret
