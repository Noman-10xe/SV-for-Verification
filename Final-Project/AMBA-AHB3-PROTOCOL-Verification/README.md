# AHB3 Lite Protocol Verification - README

## Overview

This repository provides a verification environment for the AMBA 3 AHB-Lite protocol, a simplified version of the AMBA AHB protocol designed for high-performance, single-master systems. AHB-Lite facilitates high-bandwidth data transfer between a single bus master and multiple slaves with an efficient pipelined structure. 

The project aims to validate the functionality of the AHB-Lite interface, ensuring compliance with key protocol features such as burst transfers, and address decoding. This document describes a layered testbench approach used to test the protocol's different features.

## Features Verified:
- Basic read/write operations
- Alternate write/Read operations
- Reset State of Memory
- Burst transfers (single, incrementing, wrapping)
- Address alignment based on transfer size
- Wait state insertion via HREADY

## Layered Testbench
The testbench follows a layered architecture, enabling modularity and ease of testing various components of the AHB3-Lite protocol. The layers are designed as follows:

1. **Generator**: Randomly generates transactions such as read/write operations, burst types, and transfer sizes.
2. **Driver**: Drives the generated transactions to the AHB-Lite master interface.
3. **Monitor**: Captures bus activity and protocol compliance.
4. **Scoreboard**: Compares actual and expected outcomes to validate correct behavior.
   
### Prerequisites
- A compatible simulator (VCS, ModelSim, etc.)
- AMBA 3 AHB-Lite compliant design

### Customizing Tests
The testbench allows easy customization of the number of transactions, types of transfers, and response checks. Modify the "environment" file to tweak parameters or add new tests.

## License
For detailed protocol specifications, refer to the [AMBA 3 AHB-Lite Protocol Specification]([[Protocol Specification](https://www.eecs.umich.edu/courses/eecs373/readings/ARM_IHI0033A_AMBA_AHB-Lite_SPEC.pdf)].

---
