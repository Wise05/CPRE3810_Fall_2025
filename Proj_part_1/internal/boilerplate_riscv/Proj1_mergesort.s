############################################################
# merge_sort_test.s
# Recursive Merge Sort implemented using only allowed RV32I
# instructions. Works in RARS.
############################################################
.data
array:  .word 9, 3, 7, 1, 8, 2, 6, 4
n:      .word 8
temp:   .space 32           # temporary buffer (8 words * 4B)
newline: .asciiz "\n"

.text
.globl main

############################################################
# main: entry point
############################################################
main:
    la   x10, array          # x10 = base address of array
    lw   x11, n              # x11 = number of elements
    addi x12, x0, 0          # left index = 0
    addi x13, x11, -1        # right index = n-1
    jal  x1, mergesort
    # Program finished — halt
    wfi

############################################################
# mergesort(base=x10, left=x12, right=x13)
# if left < right:
#   mid = (left + right) / 2
#   mergesort(left, mid)
#   mergesort(mid+1, right)
#   merge(left, mid, right)
############################################################
mergesort:
    addi x2, x2, -28          # stack frame (7 slots * 4 bytes)
    sw   x1, 24(x2)           # save return address
    sw   x10, 20(x2)          # save base
    sw   x12, 16(x2)          # save left
    sw   x13, 12(x2)          # save right
    sw   x14, 8(x2)           # save x14 (will hold mid)
    
    # Check if left < right
    bge  x12, x13, end_mergesort
    
    # Calculate mid = (left + right) / 2
    add  x14, x12, x13
    srli x14, x14, 1
    sw   x14, 8(x2)           # save mid value
    
    # First recursive call: mergesort(base, left, mid)
    addi x13, x14, 0          # right = mid
    jal  x1, mergesort
    
    # Restore all registers
    lw   x10, 20(x2)          # restore base
    lw   x12, 16(x2)          # restore left
    lw   x13, 12(x2)          # restore right
    lw   x14, 8(x2)           # restore mid
    
    # Second recursive call: mergesort(base, mid+1, right)
    addi x12, x14, 1          # left = mid + 1
    jal  x1, mergesort
    
    # Restore all registers again
    lw   x10, 20(x2)          # restore base
    lw   x12, 16(x2)          # restore left
    lw   x13, 12(x2)          # restore right
    lw   x14, 8(x2)           # restore mid
    
    # Call merge(base, left, mid, right)
    addi x11, x14, 0          # x11 = mid for merge
    jal  x1, merge

end_mergesort:
    lw   x1, 24(x2)           # restore return address
    addi x2, x2, 28           # deallocate stack
    jalr x0, 0(x1)            # return

############################################################
# merge(base=x10, left=x12, mid=x11, right=x13)
# Merges array[left..mid] and array[mid+1..right]
############################################################
merge:
    addi x2, x2, -48
    sw   x1, 44(x2)
    sw   x10, 40(x2)
    sw   x11, 36(x2)
    sw   x12, 32(x2)
    sw   x13, 28(x2)
    
    la   x14, temp            # temp array base
    addi x15, x12, 0          # i = left
    addi x16, x11, 1          # j = mid+1
    addi x17, x12, 0          # k = left (index for temp)

merge_loop:
    blt  x11, x15, right_side # if mid < i, copy right side
    blt  x13, x16, left_side  # if right < j, copy left side
    
    # load A[i]
    slli x18, x15, 2
    add  x19, x10, x18
    lw   x20, 0(x19)
    
    # load A[j]
    slli x21, x16, 2
    add  x22, x10, x21
    lw   x23, 0(x22)
    
    # Compare and take smaller
    blt  x20, x23, take_left
    j    take_right

take_left:
    slli x24, x17, 2
    add  x25, x14, x24
    sw   x20, 0(x25)
    addi x15, x15, 1
    addi x17, x17, 1
    j    merge_loop

take_right:
    slli x24, x17, 2
    add  x25, x14, x24
    sw   x23, 0(x25)
    addi x16, x16, 1
    addi x17, x17, 1
    j    merge_loop

left_side:
    blt  x11, x15, copy_done
    slli x18, x15, 2
    add  x19, x10, x18
    lw   x20, 0(x19)
    slli x24, x17, 2
    add  x25, x14, x24
    sw   x20, 0(x25)
    addi x15, x15, 1
    addi x17, x17, 1
    j    left_side

right_side:
    blt  x13, x16, copy_done
    slli x21, x16, 2
    add  x22, x10, x21
    lw   x23, 0(x22)
    slli x24, x17, 2
    add  x25, x14, x24
    sw   x23, 0(x25)
    addi x16, x16, 1
    addi x17, x17, 1
    j    right_side

copy_done:
    # Copy back from temp to array
    addi x17, x12, 0          # k = left

copyback_loop:
    blt  x13, x17, merge_exit
    slli x24, x17, 2
    add  x25, x14, x24
    lw   x26, 0(x25)
    add  x27, x10, x24
    sw   x26, 0(x27)
    addi x17, x17, 1
    j    copyback_loop

merge_exit:
    lw   x1, 44(x2)
    addi x2, x2, 48
    jalr x0, 0(x1)
