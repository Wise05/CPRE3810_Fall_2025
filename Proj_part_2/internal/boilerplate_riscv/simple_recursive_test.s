.data
result: .word 0

.text
.globl main

############################################################
# MAIN
############################################################
main:
    lui     x2, 0x10010        # set up stack base
    addi    x2, x2, -4         # stack pointer
    addi    x10, x0, 5         # argument: n = 5
    la      ra, main_ret       # set return address
    j       countdown          # call countdown(5)


############################################################
# COUNTDOWN - Simple recursive function
# Counts down from n to 0, returns 0
# countdown(n):
#   if n <= 0: return 0
#   else: return countdown(n-1)
############################################################
countdown:
    addi    x2, x2, -16        # push frame
    sw      ra, 12(x2)         # save return address
    sw      x10, 8(x2)         # save n
    
    # Base case: if n <= 0, return 0
    addi    x6, x0, 1          # x6 = 1
    blt     x10, x6, base_case # if n < 1, go to base case
    
    # Recursive case: countdown(n-1)
    addi    x10, x10, -1       # n = n - 1
    la      ra, countdown_ret  # set return address
    j       countdown          # recursive call
    
countdown_ret:
    # After recursion returns
    lw      x10, 8(x2)         # restore original n (though we return 0 anyway)
    
base_case:
    addi    x10, x0, 0         # return value = 0
    lw      ra, 12(x2)         # restore return address
    addi    x2, x2, 16         # pop frame
    jr      ra                 # return

main_ret:
    la      x3, result
    sw      x10, 0(x3)         # store result
    wfi                        # end of program
