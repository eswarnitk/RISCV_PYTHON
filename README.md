# RISCV_PYTHON
An Automated Script to Install PYTHON and it's components for RISCV Environment.

This script will install python 3.9.14 version, pip, setuptools, cython, numpy, scipy and oct2py. 

It will build openssl, zlib and libffi while installing python.

Installation Steps :

chmod +x Build_Riscv_Python_FPU.sh
#To Create a host version of Python, This will be used for creating cross-compile version.
source Build_Riscv_Python_FPU.sh PYPATH

#To create riscv python

./Build_Riscv_Python_FPU.sh FPU

#To Run
To Run python use QEMU with RISCV_ISA.
Add installation directory(python_3_9_14_FPU_Install) bin path to PATH Variable.
