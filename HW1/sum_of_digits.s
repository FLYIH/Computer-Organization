# 112550194
.data
    input_msg: .asciiz "Enter an integer: "
    newline:   .asciiz "\n"

.text
.globl main

main:
    li $v0, 4
    la $a0, input_msg
    syscall
    li $v0, 5
    syscall
    move $a0, $v0

    jal sumOfDigits

    move $a0, $v0 
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall

sumOfDigits:
    beq $a0, $zero, base_case

    addi $sp, $sp, -8
    sw $ra, 4($sp)  # Save return address
    sw $s0, 0($sp)  # Save $s0 to use as accumulator

    # Calculate n % 10
    li $t0, 10
    div $a0, $t0
    mfhi $s0        # $s0 = n % 10 (current digit)
    mflo $a0        # $a0 = n / 10 (remaining digits)

    jal sumOfDigits

    # Add current digit to result
    add $v0, $v0, $s0

    # Restore stack
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

base_case:
    li $v0, 0
    jr $ra