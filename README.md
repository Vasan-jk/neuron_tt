
# Adaptive Serial Pattern Detector

A TinyTapeout-compliant configurable sequence detector that can detect user-defined bit patterns of variable length (up to 32 bits) in a serial data stream.

## Features

* Detects **variable-length serial patterns** (1 to 32 bits).
* **Configurable at runtime** (pattern and sequence length can be set through inputs).
* **Overlap detection** supported (e.g., detecting `1011` in `10111`).
* Outputs a **match pulse** when the pattern is found.
* Compact design based on a **shift register and comparator**.

## I/O Mapping

### Inputs (`ui_in`)

| Bits   | Name        | Description                                |
| ------ | ----------- | ------------------------------------------ |
| [0]    | data_in     | Serial data input (1-bit per clock cycle). |
| [5:1]  | seq_len     | Sequence length (1–31).                    |
| [7:6]  | pattern_hi  | Upper 2 bits of the pattern (if needed).   |

### Inputs (`uio_in`)

| Bits   | Name        | Description                           |
| ------ | ----------- | ------------------------------------- |
| [7:0]  | pattern_lo  | Lower 8 bits of the sequence pattern. |

*(For longer patterns, unused higher bits are zero-padded.)*

### Outputs (`uo_out`)

| Bits   | Name   | Description                                                            |
| ------ | ------ | ---------------------------------------------------------------------- |
| [0]    | match  | High (1) for one clock cycle when the configured sequence is detected. |
| [7:1]  | unused | Reserved, tied to 0.                                                   |

### Outputs (`uio_out`, `uio_oe`)

* Not used, tied to `0`.

## Modes of Operation

| Input Stream | seq_len | Pattern Configured | Action / Output                               |
| ------------ | -------- | ------------------ | --------------------------------------------- |
| `1011xxxx`   | 4        | `1011`             | `uo_out[0] = 1` (at cycle 4).                 |
| `110110`     | 3        | `110`              | Pulse on detection at cycles 3 & 4 (overlap). |
| `0000`       | 4        | `1011`             | No match → output stays 0.                    |

---

## How it Works

1. Serial input bits are shifted into a **32-bit shift register** on each clock edge.
2. A **mask** is generated based on `seq_len` to ignore unused bits.
3. The masked shift register is compared with the masked pattern.
4. If they match, the `match` output goes high for one clock cycle.

---

## How to Test

1. **Reset**: Hold `rst_n = 0` to clear the shift register.
2. **Configure sequence**:

   * Set `seq_len` (1–31) on `ui_in[5:1]`.
   * Load pattern bits into `uio_in[7:0]` (and `ui_in[7:6]` if needed).
3. **Feed serial data**: Apply bits one at a time to `ui_in[0]` (data\_in).
4. **Check output**: Observe `uo_out[0]`. A high pulse indicates the pattern was detected.


## Example Test Case

**Pattern**: `1011` (`seq_len = 4`).
**Input Stream**: `1 → 0 → 1 → 1 → 1 → 0 → 1 → 1`.

| Cycle | Input Bit | Shift Reg | Match Output  |
| ----- | --------- | --------- | ------------- |
| 1     | 1         | `1`       | 0             |
| 2     | 0         | `10`      | 0             |
| 3     | 1         | `101`     | 0             |
| 4     | 1         | `1011`    | **1 (match)** |
| 5     | 1         | `0111`    | 0             |
| 6     | 0         | `1110`    | 0             |
| 7     | 1         | `1101`    | **1 (match)** |
| 8     | 1         | `1011`    | **1 (match)** |


## Applications

* Serial protocol parsers (detecting headers, sync words, etc.).
* Pattern recognition in data streams.
* Teaching hardware design concepts like **FSMs** and **sequence detectors**.
* Useful for FPGA/TinyTapeout projects requiring configurable detection logic.
