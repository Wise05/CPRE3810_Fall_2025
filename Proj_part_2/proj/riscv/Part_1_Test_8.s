# Test 8: AUIPC Forwarding
auipc x5, 0
add   x6, x5, x1     # must forward AUIPC result
wfi
