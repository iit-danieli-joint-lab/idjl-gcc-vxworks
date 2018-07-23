# Copyright (C) 2018 Fondazione Istituto Italiano di Tecnologia (IIT)
# All Rights Reserved.

# See this reference on CMake toolchains files 
# * https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/CrossCompiling
# * https://cmake.org/cmake/help/v3.12/manual/cmake-toolchains.7.html 

# References to VxWorks toolchain found in the networks:
# * https://cmake.org/pipermail/cmake/2015-December/062386.html

set(CMAKE_SYSTEM_NAME Generic)

# Set a variable to true to have toolchain-specific CMake code 
set(IDJL_VXWORKS TRUE)

# specify the cross compiler
SET(CMAKE_C_COMPILER   ${CMAKE_CURRENT_LIST_DIR}/install/bin/i586-wrs-vxworks-gcc)
SET(CMAKE_CXX_COMPILER ${CMAKE_CURRENT_LIST_DIR}/install/bin/i586-wrs-vxworks-g++)

# Specify libraries
link_directories(${CMAKE_CURRENT_LIST_DIR}/install/lib)

# where is the target environment
SET(CMAKE_FIND_ROOT_PATH  ${CMAKE_CURRENT_LIST_DIR}/install)

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Skip checks 
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

# Includ system directories
include_directories(${CMAKE_CURRENT_LIST_DIR}/wrs-vxworks-headers/sys-include)
include_directories(${CMAKE_CURRENT_LIST_DIR}/include/)
include_directories(${CMAKE_CURRENT_LIST_DIR}/include/std/)
include_directories(${CMAKE_CURRENT_LIST_DIR}/install/include)
