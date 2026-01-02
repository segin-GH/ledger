
# Ledger

**Ledger** is a binary-first logging and diagnostics system for embedded devices.

It is designed to capture _what happened_ inside a device with **minimal runtime cost**, while enabling **rich, human-readable analysis off-device** using build artifacts such as ELF and DWARF.

Ledger is not a printf replacement. It is a **recording system**.

----------

## Problem Ledger Solves

Traditional embedded logging is built around formatted strings and serial consoles. This approach breaks down when:

-   Bandwidth is constrained (BLE, RTT, SWO)
    
-   Logs must survive resets or crashes
    
-   Devices run unattended in the field
    
-   Performance and determinism matter
    
-   Debug context is needed _after_ failure
    

Ledger addresses these by separating **recording** from **interpretation**.

----------

## Core Philosophy

Ledger is built on a few strict principles:

-   **Binary-first**: Devices emit structured binary records, not strings
    
-   **Append-only**: Logs are treated as an immutable event history
    
-   **RTOS-agnostic**: No dependency on a specific OS or scheduler
    
-   **Transport-agnostic**: BLE, flash, SD card, UART are interchangeable
    
-   **Loss-tolerant**: Logging never blocks application execution
    
-   **Decode off-device**: Human-readable meaning is reconstructed later
    

----------

## High-Level Architecture

```
Application Code
      ↓
Ledger API (macros)
      ↓
Binary Record Buffer
      ↓
Transport Layer
  (BLE / Flash / SD / UART)
      ↓
Host Decoder
  (ELF + DWARF)

```

Ledger itself does **not**:

-   Format strings
    
-   Allocate memory dynamically
    
-   Decode logs
    
-   Depend on a debugger
    

----------

## What Gets Logged

Ledger records _facts_, not prose.

Typical records include:

-   Event occurrences
    
-   Callsite identifiers
    
-   Timestamps
    
-   Numeric arguments
    
-   Crash snapshots (PC, SP, LR)
    

Meaning is restored later using the firmware’s ELF and DWARF information.

----------

## ELF- and DWARF-Based Decoding

Ledger leverages standard toolchain artifacts to reconstruct context:

-   Program counters identify log callsites
    
-   ELF symbols map addresses to functions
    
-   DWARF maps execution to source lines
    

This enables:

-   Human-readable logs without transmitting strings
    
-   Accurate backtraces after crashes
    
-   Consistent decoding across transports
    

The device records _coordinates_; the host reconstructs the _map_.

----------

## Logging vs Diagnostics

Ledger distinguishes between two classes of data:

-   **Operational events**: Stable, numeric, suitable for long-term storage
    
-   **Diagnostic traces**: High-volume, symbol-decoded, debug-oriented
    

Both use the same recording infrastructure, but may be enabled and transported differently.

----------

## Loss Model

Ledger is explicitly designed for **lossy paths**.

-   Logging never blocks application logic
    
-   Buffers are bounded and deterministic
    
-   Dropped records are detected and counted
    

Completeness is secondary to correctness.

----------

## Typical Use Cases

-   BLE-based live debug streaming
    
-   Post-mortem crash analysis
    
-   Field diagnostics without UART access
    
-   Low-overhead tracing in timing-critical code
    
-   Black-box style event recording
    

----------

## Non-Goals

Ledger intentionally does not try to be:

-   A printf-style logging framework
    
-   A cloud logging SDK
    
-   A guaranteed-delivery event queue
    
-   A human-readable on-device logger
    

Those are different problems.

----------

## Design Intent

Ledger is meant to be:

-   Boring in the firmware
    
-   Powerful in tooling
    
-   Predictable under stress
    
-   Useful years after deployment
    

It favors **long-term diagnosability** over short-term convenience.

----------

## Status

Ledger is a foundational system. Its value comes from disciplined use and tooling around it.

Implementation details, transports, and decoders are intentionally kept separate from this core vision.

----------

_Ledger records the truth. Interpretation comes later
