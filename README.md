# idjl-vxworks-gcc
Helpers script to compile a version of GCC that crosscompiles to VxWorks. 

Table of Contents
=================
  * [Installation from binaries and usage](#installation-from-binaries-and-usage)
    * [Windows](#windows)
  * [Compilation from source code](#compilation-from-source-code)
    * [Windows with MSYS2](#windows-with-msys2) 
    * [Ubuntu](#ubuntu)

## Installation from binaries and usage

### Windows 
To use the GCC-based VxWorks compiler on Windows, you need to install [`CMake`](https://cmake.org/), [`Ninja`](https://ninja-build.org/) and [`Git for Windows`](https://gitforwindows.org/). Make sure that both `CMake` and `Ninja` executables are on the [`Path` enviromental variable](https://superuser.com/questions/297947/is-there-a-convenient-way-to-edit-path-in-windows-7), so that if you type `cmake` or `ninja` in the Git Bash, the commands are execute out of the box. 

To install the compiler, you can download the binaries at https://github.com/iit-danieli-joint-lab/idjl-gcc-vxworks/releases/download/v0.1.0/idjl-gcc-vxworks-windows-x64.zip, and unzip them in any directory.

To use the GCC-based VxWorks compiler, open the Git bash and source the `setup.sh` file:
~~~
source /path/where/you/downloaded/idjl-gcc-vxworks/setup.sh
~~~

To generate a CMake project that target VxWorks, create a `build-vxworks` directory and pass `idjl_vxworks_toolchain.cmake` as the [`CMAKE_TOOLCHAIN_FILE`](https://cmake.org/cmake/help/v3.10/variable/CMAKE_TOOLCHAIN_FILE.html) option, using the `Ninja` generator.
~~~
mkdir build-vxworks
cd build-vxworks
cmake -GNinja -DCMAKE_TOOLCHAIN_FILE=/path/where/you/downloaded/idjl-gcc-vxworks/idjl_vxworks_toolchain.cmake /path/of/the/cmake/project/srcs 
~~~
then, you can compile your code using the `ninja` command:
~~~
ninja
~~~

## Compilation from source code

For compiling the GCC compiler with VxWorks support, you need a bash like enviroment. 
The enviroment in which this has been tested have been Ubuntu 18.04 and on Windows the MSYS2 enviroment. 

## Windows with MSYS2 

First, install the [MSYS2](https://www.msys2.org/) enviroment using the [installer](http://repo.msys2.org/distrib/x86_64/msys2-x86_64-20180531.exe). 

Then, open an `MSYS2 MSYS` terminal (not a `MSYS2 MinGW 32-bit` or  `MSYS2 MinGW 64-bit` one!) and first install the development tools:
~~~
pacman -S base-devel
~~~

Then, clone the repo and run the script:
~~~
git clone https://github.com/iit-danieli-joint-lab/idjl-gcc-vxworks
cd  idjl-gcc-vxworks
./build_idjl_gcc_vxworks.sh 
~~~
the build can take some time (one hour). 
If the build ends successfully (i.e. it prints  'Success!' at the end of the output), then the compiler is ready to be used. 


### Ubuntu 18.04 

Install development tools: 
~~~
sudo apt install build-essentials
~~~

Clone this repository and cd in the directory:
~~~
git clone https://github.com/iit-danieli-joint-lab/idjl-gcc-vxworks
cd  idjl-gcc-vxworks
~~~

Launch the building script (warning: the build can take more than an hour. To avoid losing time if there are problems and the build needs to restart, it is recommended to use [ccache](https://ccache.samba.org/)):
~~~
./build_idjl_gcc_vxworks.sh 
~~~

If the build ends successfully (i.e. it prints  'Success!' at the end of the output), then the compiler is ready to be used. 
