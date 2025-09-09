# 2-Layer Digital Neuron Network

A TinyTapeout-compliant digital neural network that demonstrates basic perceptron-style computation with weighted sums, biases, and thresholds.
The design has two input features, two first-layer neurons, and one second-layer neuron that produces the final output.


## Features

* **2 input features** (`x0`, `x1`), each 4-bit wide.
* **3 neurons total**:

  * Layer 1: Neuron N1, Neuron N2.
  * Layer 2: Neuron N3 (combines N1 and N2 outputs).
* **Parameterizable weights, bias, and threshold** for each neuron.
* **Single-bit decision output** (`uo_out[0]`).
* **Clocked + resettable** design for synchronous operation.


## I/O Mapping

### Inputs (`ui_in`)

| Bits   | Name | Description           |
| ------ | ---- | --------------------- |
| \[3:0] | x0   | 4-bit input feature 0 |
| \[7:4] | x1   | 4-bit input feature 1 |

Other signals:

* `clk` → System clock.
* `rst_n` → Active-low reset.
* `ena` → Enable (currently unused, but provided by TinyTapeout wrapper).

### Outputs (`uo_out`)

| Bits   | Name | Description                     |
| ------ | ---- | ------------------------------- |
| \[0]   | y    | Final neuron output (N3 result) |
| \[7:1] | —    | Unused (always 0)               |

### Bidirectional IOs

* `uio_in`, `uio_out`, `uio_oe` → Unused (tied to zero).


## Neuron Configuration

Each neuron implements:

```
sum = W0 * x0 + W1 * x1 + BIAS
y   = (sum > THRESH) ? 1 : 0
```

| Neuron | Layer | W0 | W1 | BIAS | THRESH | Inputs           |
| ------ | ----- | -- | -- | ---- | ------ | ---------------- |
| N1     | 1     | 2  | 1  | 1    | 6      | x0, x1           |
| N2     | 1     | 1  | 3  | 2    | 10     | x0, x1           |
| N3     | 2     | 2  | 2  | 0    | 2      | N1\_out, N2\_out |


## Modes of Operation

Unlike the voting machine, this design doesn’t use explicit mode control — it operates continuously:

* **Reset (rst\_n = 0)**: All neuron outputs reset to 0.
* **Active (rst\_n = 1)**: Neurons compute their outputs every clock cycle.
* **Final Decision**: Available on `uo_out[0]`.


## How it Works

1. Inputs `x0` and `x1` are applied through `ui_in[3:0]` and `ui_in[7:4]`.
2. **Layer 1**:

   * N1 and N2 compute weighted sums and output binary activations.
3. **Layer 2**:

   * N3 takes `N1_out` and `N2_out`, treats them as 1-bit inputs (extended to 4 bits), and produces the final result.
4. Final output (`uo_out[0]`) represents the classification/decision of the network.


## How to Test

1. **Reset**: Drive `rst_n = 0` → ensures all outputs = 0.
2. **Apply Inputs**: Provide values for `x0` and `x1` via `ui_in`.
3. **Observe Outputs**:

   * N1 and N2 activate based on thresholds.
   * N3 decides based on N1 and N2.
   * Final decision available on `uo_out[0]`.


## Example Evaluation

For example, if `x0 = 3 (0011)` and `x1 = 5 (0101)`:

* N1: `2*3 + 1*5 + 1 = 12`, threshold = 6 → Output = 1.
* N2: `1*3 + 3*5 + 2 = 20`, threshold = 10 → Output = 1.
* N3: `2*1 + 2*1 + 0 = 4`, threshold = 2 → Output = 1.

**Final Output: `uo_out[0] = 1`**

## Notes

* This project is **TinyTapeout-compliant**.
* Good demonstration of **neuromorphic computing in hardware**.
* Can be extended with more neurons, inputs, or layers.

