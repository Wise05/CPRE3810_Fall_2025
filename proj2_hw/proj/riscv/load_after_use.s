    .text
    .global main

main:
    # --- SETUP: Initialize Base Register x10 and Memory ---
    addi x10, x0, 0xAA     # x10 = 0xAA (Data to be stored/loaded)
    addi sp, sp, -4        # Adjust stack pointer
    sw x10, 0(sp)          # Store 0xAA at 0(sp)


    # -------------------------------------------------------------------
    # TEST #4: Load-Use Data Stall (1-Cycle Stall)
    # Hazard: I2 needs x1, but I1 is a Load.
    #
    # Timeline:
    # I1 (Load) is in EX.
    # I2 (Consumer) is in ID, detects the hazard.
    #
    # Expected Action: HDU stalls (I2 and subsequent instructions wait)
    # for 1 cycle, inserting a NOP.

    # I1: PRODUCER (Load)
    lw x1, 0(sp)           # I1: x1 = 0xAA (Result available WB)

    # I2: CONSUMER (Uses the load result x1 IMMEDIATELY)
    addi x2, x1, 1         # I2: Reads x1 (Rs1) immediately.
                           # ACTION: HDU forces a 1-cycle stall (NOP) at this point.
                           # After the stall, forwarding from the MEM/WB register resolves the dependency.
                           # Expected: x2 = 0xAA + 1 = 0xAB

    # I3: VERIFICATION (To ensure pipeline resumes correctly)
    slli x3, x2, 1         # I3: Uses the stalled result x2.
                           # Expected: x3 = 0xAB * 2 = 0x156


    # -------------------------------------------------------------------
    # PROGRAM TERMINATION
    addi sp, sp, 4
    wfi                    # Halt the processor.
