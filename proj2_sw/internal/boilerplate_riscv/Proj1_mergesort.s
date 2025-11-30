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
 jal x0, major   
 addi x0, x0, 0            # NOP
 addi x0, x0, 0            # NOP
 addi x0, x0, 0            # NOP
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
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    sw   x1, 24(x2)           # save return address
    sw   x10, 20(x2)          # save base
    sw   x12, 16(x2)          # save left
    sw   x13, 12(x2)          # save right
    sw   x14, 8(x2)           # save x14 (will hold mid)
    
    # Check if left < right
    bge  x12, x13, end_mergesort
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    
    # Calculate mid = (left + right) / 2
    add  x14, x12, x13
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    srli x14, x14, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    sw   x14, 8(x2)           # save mid value
    
    # First recursive call: mergesort(base, left, mid)
    addi x13, x14, 0          # right = mid
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    jal  x1, mergesort
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    
    # Restore all registers
    lw   x10, 20(x2)          # restore base
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x12, 16(x2)          # restore left
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x13, 12(x2)          # restore right
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x14, 8(x2)           # restore mid
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    
    # Second recursive call: mergesort(base, mid+1, right)
    addi x12, x14, 1          # left = mid + 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    jal  x1, mergesort
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    
    # Restore all registers again
    lw   x10, 20(x2)          # restore base
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x12, 16(x2)          # restore left
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x13, 12(x2)          # restore right
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x14, 8(x2)           # restore mid
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    
    # Call merge(base, left, mid, right)
    addi x11, x14, 0          # x11 = mid for merge
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    jal  x1, merge
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
end_mergesort:
    lw   x1, 24(x2)           # restore return address
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x2, x2, 28           # deallocate stack
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    jalr x6, 0(x1)            # return (changed from x0 to x6)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
############################################################
# merge(base=x10, left=x12, mid=x11, right=x13)
# Merges array[left..mid] and array[mid+1..right]
############################################################
merge:
    addi x2, x2, -48
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    sw   x1, 44(x2)
    sw   x10, 40(x2)
    sw   x11, 36(x2)
    sw   x12, 32(x2)
    sw   x13, 28(x2)
    
    #la   x14, temp            # temp array base
    lui x14, %hi(temp)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x14, x14, %lo(temp)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x15, x12, 0          # i = left
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x16, x11, 1          # j = mid+1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x17, x12, 0          # k = left (index for temp)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
merge_loop:
    blt  x11, x15, right_side # if mid < i, copy right side
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    blt  x13, x16, left_side  # if right < j, copy left side
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    
    # load A[i]
    slli x18, x15, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x19, x10, x18
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x20, 0(x19)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    
    # load A[j]
    slli x21, x16, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x22, x10, x21
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x23, 0(x22)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    
    # Compare and take smaller
    blt  x20, x23, take_left
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    j    take_right
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
take_left:
    slli x24, x17, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x25, x14, x24
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    sw   x20, 0(x25)
    addi x15, x15, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x17, x17, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    j    merge_loop
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
take_right:
    slli x24, x17, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x25, x14, x24
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    sw   x23, 0(x25)
    addi x16, x16, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x17, x17, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    j    merge_loop
left_side:
    blt  x11, x15, copy_done
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    slli x18, x15, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x19, x10, x18
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x20, 0(x19)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    slli x24, x17, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x25, x14, x24
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    sw   x20, 0(x25)
    addi x15, x15, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x17, x17, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    j    left_side
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
right_side:
    blt  x13, x16, copy_done
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    slli x21, x16, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x22, x10, x21
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x23, 0(x22)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    slli x24, x17, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x25, x14, x24
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    sw   x23, 0(x25)
    addi x16, x16, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x17, x17, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    j    right_side
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
copy_done:
    # Copy back from temp to array
    addi x17, x12, 0          # k = left
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
copyback_loop:
    blt  x13, x17, merge_exit
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    slli x24, x17, 2
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x25, x14, x24
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lw   x26, 0(x25)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    add  x27, x10, x24
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    sw   x26, 0(x27)
    addi x17, x17, 1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    j    copyback_loop
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
merge_exit:
    lw   x1, 44(x2)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x2, x2, 48
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    jalr x6, 0(x1)            # return (changed from x0 to x6)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
major: 
    #la   x10, array           # x10 = base address of array
    lui x10, %hi(array)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x10, x10, %lo(array)
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    lui   x5,  %hi(n)
    addi  x0,  x0,  0        # NOP
    addi  x0,  x0,  0        # NOP
    addi  x0,  x0,  0        # NOP
    addi  x5,  x5,  %lo(n)
    addi  x0,  x0,  0        # NOP
    addi  x0,  x0,  0        # NOP
    addi  x0,  x0,  0        # NOP
    lw    x11, 0(x5)         # x11 = contents of label n
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x12, x0, 0           # left index = 0
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x13, x11, -1         # right index = n-1
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    jal  x1, mergesort
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    addi x0, x0, 0            # NOP
    # Program finished — halt
    wfi
