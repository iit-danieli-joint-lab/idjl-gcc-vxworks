# idjl-vxworks-gcc
Helpers script to compile a version of GCC that crosscompiles to VxWorks. 

## Installation

**Note: For the time being, this procedure have been tested only on Ubuntu Linux 18.04, however it should be easily portable to Windows using the [MinGW toolchain](https://gcc.gnu.org/wiki/WindowsBuilding).** 

Clone this repository and cd in the directory:
~~~
git clone https://github.com/iit-danieli-joint-lab/idjl-gcc-vxworks
cd  idjl-gcc-vxworks
~~~

Launch the building script (warning: the build can take more than an hour. To avoid losing time if there are problems and the build needs to restart, it is recommended to use [ccache](https://github.com/iit-danieli-joint-lab/idjl-gcc-vxworks)):
~~~
./build_idjl_gcc_vxworks.sh 
~~~

If the build ends successfully (i.e. it prints  'Success!' at the end of the output), then the compiler is ready to be used. 

## Usage 
In the terminal where you want to use the compiled, modify and source the `setup.sh` file:
~~~
source /path/where/you/downloaded/idjl-gcc-vxworks/setup.sh
~~~
To generate a CMake project that target VxWorks, pass `idjl_vxworks_toolchain.cmake` as the [`CMAKE_TOOLCHAIN_FILE`](https://cmake.org/cmake/help/v3.10/variable/CMAKE_TOOLCHAIN_FILE.html) option:
~~~
cmake -DCMAKE_TOOLCHAIN_FILE=/path/where/you/downloaded/idjl-gcc-vxworks/idjl_vxworks_toolchain.cmake /path/of/the/cmake/project/srcs 
~~~
