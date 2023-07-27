#!/bin/bash

# To setup Host Version
if [ "$1" == "PYPATH" ]
then
    Ins_DIR_Host=${PWD}/python3_HOST_Installer
    if [ -d ${Ins_DIR_Host}/bin ]
	then
		continue
	else
		wget https://www.python.org/ftp/python/3.9.14/Python-3.9.14.tgz
		tar -xvf Python-3.9.14.tgz
		mkdir build_host
		cd build_host
		../Python-3.9.14/configure --prefix=${PWD}/python3_HOST_Installer
		cd -
	fi
	export PATH=${Ins_DIR_Host}/bin:$PATH
fi

if [ "$1" == "FPU" ]
then
#Path to riscv-gnu-toolchain installation
RISCV_COMPILER_PATH=/path/to/riscv/compiler/installer

echo "Building FPU version"

rm -rf build_FPU

mkdir build_FPU

Ins_DIR=$PWD/python_3_9_14_FPU_Install

Install_path=${PWD}/build_Deps_FPU

mkdir build_Deps_FPU

cd build_Deps_FPU

echo "Installing OPENSSL PACKAGE"

git clone https://github.com/openssl/openssl.git

cd openssl

git checkout openssl-3.0

./Configure --prefix=${Install_path}/openssl_install_riscv_fpu linux-generic64 --cross-compile-prefix=riscv64-unknown-linux-gnu- CFLAGS="-fPIC -march=rv64imafd -mabi=lp64d" CXXFLAGS="-fPIC -march=rv64imafd -mabi=lp64d"

make -j8

make install

cd ../

echo "Installing ZLIB PACKAGE"

git clone https://github.com/madler/zlib.git

cd zlib

CXXFLAGS="-fPIC -march=rv64imafd -mabi=lp64d" CCFLAGS="-fPIC -march=rv64imafd -mabi=lp64d" CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc ./configure --prefix=${Install_path}/zlib_install_riscv_fpu

make -j8

make install

cd ../

echo "Installing LIBFFI PACKAGE"

git clone https://github.com/libffi/libffi.git

cd libffi

./autogen.sh

./configure --prefix=${Install_path}/libffi_install_riscv_fpu --build=x86 --host=riscv64-unknown-linux-gnu CFLAGS="-fPIC -march=rv64imafd -mabi=lp64d" CXXFLAGS="-fPIC -march=rv64imafd -mabi=lp64d"

make -j8

make install

cd ../
cd ../
OpenSSL_DIR=${Install_path}/openssl_install_riscv_fpu

Zlib_DIR=${Install_path}/zlib_install_riscv_fpu

libFFI_DIR=${Install_path}/libffi_install_riscv_fpu

wget https://www.python.org/ftp/python/3.9.14/Python-3.9.14.tgz

tar -xvf Python-3.9.14.tgz

cd build_FPU

../Python-3.9.14/configure --prefix=${Ins_DIR} --host=riscv64-unknown-linux-gnu --build=x86_64-pc-linux-gnu --disable-ipv6 ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=yes --with-openssl=${OpenSSL_DIR} CFLAGS="-march=rv64imafd -mabi=lp64d -fPIC" CXXFLAGS="-march=rv64imafd -mabi=lp64d -fPIC" CPPFLAGS="-I${libFFI_DIR}/include/ -I${Zlib_DIR}/include/" LDFLAGS="-L${Zlib_DIR}/lib -L${libFFI_DIR}/lib" ax_cv_c_float_words_bigendian=no

make -j4

make install

cd -

mkdir build_python_packages

cd build_python_packages

echo "Installing PIP PACKAGE"

git clone https://github.com/pypa/pip.git

cd pip

FFLAGS="-std=legacy -fPIC" CFLAGS="-fPIC" CXXFLAGS="-fPIC" LAPACK=/home/projspace/Mayuri/OpenBLAS/install_FPU/ SCIPY_USE_G77_ABI_WRAPPER=0 F77=riscv64-unknown-linux-gnu-gfortran F90=riscv64-unknown-linux-gnu-gfortran F99=riscv64-unknown-linux-gnu-gfortran CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc LD_LIBRARY_PATH=${Install_path}/openssl_install_riscv_fpu/lib/:${Install_path}/zlib_install_riscv_fpu/lib/:${Install_path}/libffi_install_riscv_fpu/lib:${RISCV_COMPILER_PATH}/sysroot/lib/:$LD_LIBRARY_PATH qemu-riscv64FPU -L ${RISCV_COMPILER_PATH}/sysroot/ ${Ins_DIR}/bin/python3.9 setup.py install

cd -

echo "Installing CYTHON PACKAGE"

git clone https://github.com/cython/cython.git

cd cython

FFLAGS="-std=legacy -fPIC" CFLAGS="-fPIC" CXXFLAGS="-fPIC" LAPACK=/home/projspace/Mayuri/OpenBLAS/install_FPU/ SCIPY_USE_G77_ABI_WRAPPER=0 F77=riscv64-unknown-linux-gnu-gfortran F90=riscv64-unknown-linux-gnu-gfortran F99=riscv64-unknown-linux-gnu-gfortran CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc LD_LIBRARY_PATH=${Install_path}/openssl_install_riscv_fpu/lib/:${Install_path}/zlib_install_riscv_fpu/lib/:${Install_path}/libffi_install_riscv_fpu/lib:${RISCV_COMPILER_PATH}/sysroot/lib/:$LD_LIBRARY_PATH qemu-riscv64FPU -L ${RISCV_COMPILER_PATH}/sysroot/ ${Ins_DIR}/bin/python3.9 setup.py install

cd -

echo "Installing SETUPTOOLS PACKAGE"

git clone https://github.com/pypa/setuptools.git

cd setuptools

FFLAGS="-std=legacy -fPIC" CFLAGS="-fPIC" CXXFLAGS="-fPIC" LAPACK=/home/projspace/Mayuri/OpenBLAS/install_FPU/ SCIPY_USE_G77_ABI_WRAPPER=0 F77=riscv64-unknown-linux-gnu-gfortran F90=riscv64-unknown-linux-gnu-gfortran F99=riscv64-unknown-linux-gnu-gfortran CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc LD_LIBRARY_PATH=${Install_path}/openssl_install_riscv_fpu/lib/:${Install_path}/zlib_install_riscv_fpu/lib/:${Install_path}/libffi_install_riscv_fpu/lib:${RISCV_COMPILER_PATH}/sysroot/lib/:$LD_LIBRARY_PATH qemu-riscv64FPU -L ${RISCV_COMPILER_PATH}/sysroot/ ${Ins_DIR}/bin/python3.9 setup.py install

cd -

echo "Installing NUMPY PACKAGE"

git clone https://github.com/numpy/numpy.git

cd numpy

git submodule update --init

#sed -i 's/sys.executable/\"python3\"/' setup.py
#python3.9 tools/cythonize.py numpy/random

sed -i 's/sys.executable/\"python3\"/' setup.py

FFLAGS="-std=legacy -fPIC" CFLAGS="-fPIC" CXXFLAGS="-fPIC" LAPACK=/home/projspace/Mayuri/OpenBLAS/install_FPU/ SCIPY_USE_G77_ABI_WRAPPER=0 F77=riscv64-unknown-linux-gnu-gfortran F90=riscv64-unknown-linux-gnu-gfortran F99=riscv64-unknown-linux-gnu-gfortran CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc LD_LIBRARY_PATH=${Install_path}/openssl_install_riscv_fpu/lib/:${Install_path}/zlib_install_riscv_fpu/lib/:${Install_path}/libffi_install_riscv_fpu/lib:${RISCV_COMPILER_PATH}/sysroot/lib/:$LD_LIBRARY_PATH qemu-riscv64FPU -L ${RISCV_COMPILER_PATH}/sysroot/ ${Ins_DIR}/bin/python3.9 setup.py install

cd -

echo "Installing PYBIND11 PACKAGE"

git clone https://github.com/pybind/pybind11.git

cd pybind11

FFLAGS="-std=legacy -fPIC" CFLAGS="-fPIC" CXXFLAGS="-fPIC" LAPACK=/home/projspace/Mayuri/OpenBLAS/install_FPU/ SCIPY_USE_G77_ABI_WRAPPER=0 F77=riscv64-unknown-linux-gnu-gfortran F90=riscv64-unknown-linux-gnu-gfortran F99=riscv64-unknown-linux-gnu-gfortran CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc LD_LIBRARY_PATH=${Install_path}/openssl_install_riscv_fpu/lib/:${Install_path}/zlib_install_riscv_fpu/lib/:${Install_path}/libffi_install_riscv_fpu/lib:${RISCV_COMPILER_PATH}/sysroot/lib/:$LD_LIBRARY_PATH qemu-riscv64FPU -L ${RISCV_COMPILER_PATH}/sysroot/ ${Ins_DIR}/bin/python3.9 setup.py install

cd -

FFLAGS="-std=legacy -fPIC" CFLAGS="-fPIC" CXXFLAGS="-fPIC" LAPACK=/home/projspace/Mayuri/OpenBLAS/install_FPU/ SCIPY_USE_G77_ABI_WRAPPER=0 F77=riscv64-unknown-linux-gnu-gfortran F90=riscv64-unknown-linux-gnu-gfortran F99=riscv64-unknown-linux-gnu-gfortran CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc LD_LIBRARY_PATH=${Install_path}/openssl_install_riscv_fpu/lib/:${Install_path}/zlib_install_riscv_fpu/lib/:${Install_path}/libffi_install_riscv_fpu/lib:${RISCV_COMPILER_PATH}/sysroot/lib/:$LD_LIBRARY_PATH qemu-riscv64FPU -L ${RISCV_COMPILER_PATH}/sysroot/ ${Ins_DIR}/bin/python3.9 -m pip install pythran

echo "Installing SCIPY PACKAGE"

git clone https://github.com/scipy/scipy.git

cd scipy

git submodule update --init

#sed -i 's/generate_cython()/pass/' setup.py
#sed -i 's/pass:/generate_cython():/' setup.py
sed -i 's/sys.executable/\"python3\"/' setup.py
sed -i 's/sys.executable/\"python3\"/' scipy/special/setup.py 
sed -i 's/sys.executable/\"python3\"/' scipy/sparse/setup.py

python3.9 tools/cythonize.py scipy

FFLAGS="-std=legacy -fPIC" CFLAGS="-fPIC" CXXFLAGS="-fPIC" LAPACK=/home/projspace/Mayuri/OpenBLAS/install_FPU/ SCIPY_USE_G77_ABI_WRAPPER=0 F77=riscv64-unknown-linux-gnu-gfortran F90=riscv64-unknown-linux-gnu-gfortran F99=riscv64-unknown-linux-gnu-gfortran CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc LD_LIBRARY_PATH=${Install_path}/openssl_install_riscv_fpu/lib/:${Install_path}/zlib_install_riscv_fpu/lib/:${Install_path}/libffi_install_riscv_fpu/lib:${RISCV_COMPILER_PATH}/sysroot/lib/:$LD_LIBRARY_PATH qemu-riscv64FPU -L ${RISCV_COMPILER_PATH}/sysroot/ ${Ins_DIR}/bin/python3.9 setup.py install

cd -

echo "Installing OCT2PY PACKAGE"

FFLAGS="-std=legacy -fPIC" CFLAGS="-fPIC" CXXFLAGS="-fPIC" LAPACK=/home/projspace/Mayuri/OpenBLAS/install_FPU/ SCIPY_USE_G77_ABI_WRAPPER=0 F77=riscv64-unknown-linux-gnu-gfortran F90=riscv64-unknown-linux-gnu-gfortran F99=riscv64-unknown-linux-gnu-gfortran CXX=riscv64-unknown-linux-gnu-g++ CC=riscv64-unknown-linux-gnu-gcc LD_LIBRARY_PATH=${Install_path}/openssl_install_riscv_fpu/lib/:${Install_path}/zlib_install_riscv_fpu/lib/:${Install_path}/libffi_install_riscv_fpu/lib:${RISCV_COMPILER_PATH}/sysroot/lib/:$LD_LIBRARY_PATH qemu-riscv64FPU -L ${RISCV_COMPILER_PATH}/sysroot/ ${Ins_DIR}/bin/python3.9 -m pip install oct2py==3.6
cd -
fi
