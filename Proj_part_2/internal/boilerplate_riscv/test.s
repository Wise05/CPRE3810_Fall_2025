      addi s3, x0, 67
      sw   s3, 4(sp)
      lw   s4, 4(sp)      # Get value from array F[n-1]
      add  s2, s3, s4    # F[n]
      wfi
