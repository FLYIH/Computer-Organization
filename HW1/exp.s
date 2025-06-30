# 112550194
.data
    input_msg1: .asciiz "Enter base (positive integers): "
    input_msg2: .asciiz "Enter exponent (positive integers): "
    newline:    .asciiz "\n"
    buffer:     .space 32
    
.text
.globl main
main:
    li $v0, 4
    la $a0, input_msg1
    syscall
    li $v0, 5
    syscall
    move $s0, $v0
   
    li $v0, 4
    la $a0, input_msg2
    syscall
    li $v0, 5
    syscall
    move $s1, $v0

    move $a0, $s0
    move $a1, $s1
    jal exp
    move $s2, $v0  # low 32-bit
    move $s3, $v1  # high 32-bit
    
    # change to 10-based integer
    move $a0, $s3  # high 32-bit
    move $a1, $s2  # low 32-bit
    jal print_longlong
  
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall

# 函數：exp(base, exp)
# 輸入: $a0 = base, $a1 = exp
# 輸出: $v0 = base^exp 的低 32-bit，$v1 = 高 32-bit
exp:
    beq $a1, $zero, exp_base_case
    
    addi $sp, $sp, -20
    sw   $a0, 16($sp)  
    sw   $a1, 12($sp)  
    sw   $ra, 8($sp)   
    sw   $s0, 4($sp)   
    sw   $s1, 0($sp)   
    
  
    addi $a1, $a1, -1  
    jal exp            
    
    move $s0, $v0      # low 32-bit
    move $s1, $v1      # high 32-bit
   
    lw   $a0, 16($sp) 
    
    multu $s0, $a0
    mflo $v0           # LO
    mfhi $t0           # HI
    
  
    multu $s1, $a0
    mflo $t1           # LO
    mfhi $t2           # HI
    
    # combine the results
    addu $v1, $t0, $t1  # high 32-bit = ($s0 * $a0) high 32-bit + ($s1 * $a0) low 32-bit
    
    lw   $s1, 0($sp)    # restore $s1
    lw   $s0, 4($sp)    # restore $s0
    lw   $ra, 8($sp)    # restore return address
    addi $sp, $sp, 20   # pop stack
    jr   $ra            
    
exp_base_case:
    li $v0, 1           
    li $v1, 0
    jr $ra

# input: $a0 = high 32-bit, $a1 = low 32-bit
# output: print the long long integer
print_longlong:
    addi $sp, $sp, -28
    sw $ra, 24($sp)
    sw $s0, 20($sp)  # high 32-bit
    sw $s1, 16($sp)  # low 32-bit
    sw $s2, 12($sp)  # buffer pointer
    sw $s3, 8($sp)   # divisor 10 low 32-bit
    sw $s4, 4($sp)   # divisor 10 high 32-bit
    sw $s5, 0($sp)   # remainder
    
    move $s0, $a0    
    move $s1, $a1
    
    or $t0, $s0, $s1
    bnez $t0, not_zero
    li $v0, 11       # print character
    li $a0, 48       # ASCII '0'
    syscall
    j print_done
    
not_zero:
    la $s2, buffer
    addi $s2, $s2, 31 
    sb $zero, 0($s2)   # null-terminated string
    addi $s2, $s2, -1  # move pointer to the last character
    
    # set divisor to 10
    li $s3, 10   # divisor low 32-bit
    li $s4, 0    # divisor high 32-bit
    
divide_loop:
    or $t0, $s0, $s1
    beqz $t0, print_buffer

    li $t2, 0    # remainder
    
    # high 32-bit
    li $t9, 32  
high_division:
    sll $t2, $t2, 1
    srl $t0, $s0, 31
    or $t2, $t2, $t0
    sll $s0, $s0, 1
    
    slti $t0, $t2, 10
    bnez $t0, skip_sub_high
    addi $t2, $t2, -10
    ori $s0, $s0, 1
skip_sub_high:
    addi $t9, $t9, -1
    bnez $t9, high_division
    
    # low 32-bit
    li $t9, 32
low_division:
    sll $t2, $t2, 1
    srl $t0, $s1, 31
    or $t2, $t2, $t0
    sll $s1, $s1, 1
    

    slti $t0, $t2, 10
    bnez $t0, skip_sub_low
    addi $t2, $t2, -10
    ori $s1, $s1, 1
skip_sub_low:
    addi $t9, $t9, -1
    bnez $t9, low_division
    

    addi $t2, $t2, 48 
    sb $t2, 0($s2)     
    addi $s2, $s2, -1  
    
    j divide_loop

print_buffer:
    addi $s2, $s2, 1
    
    li $v0, 4
    move $a0, $s2
    syscall
    
print_done:
    lw $s5, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    jr $ra