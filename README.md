# kpfm-matlab
This work supported by NSF Career Award DMR -1056861.
## Short description: 
Batch open matlab .txt files, track a point through multiple frames, output list of point positions tracked through frames.

## Long Description
These functions are designed to work in conjunction with igor .txt files.  This program is designed to work in conjunction with Kelvin Probe Force Microscopy (KPFM) studies (on an Atomic Force Microscope or AFM) to track points through multiple AFM images and output a point (or average and standard deviation of multiple points) to a file.  This allows the Density of States (DOS) information to be gleaned from the outputted file after processing.

### DOS_KPFM.m 
This program calculates and plots the DOS information using the three matlab functions (pull_po, batch_pull_po, and data_std).

### KPFM_graph_and_output.m
This program calculates and plots KPFM results of two points as a function of gate bias, outputs data from one point to a tab seperated list, and uses the tree matlab functions to do so (pull_po, batch_pull_po, and data_std).
