cmake_minimum_required(VERSION 3.5.2)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(directory_test)
#set(CMAKE_BUILD_TYPE Release)
set(CMAKE_BUILD_TYPE Debug)

#Bring the headers, such as *.h into the project - over here you need to paste *your* path to the python environment of choice
include_directories(/usr/include/python3.8)
include_directories(/lus/theta-fs0/software/thetagpu/conda/2021-06-26/mconda3/lib/python3.8/site-packages/numpy/core/include)
 
#However, the file(GLOB...) allows for wildcard additions:
file(GLOB SOURCES "*.cpp")

#For the shared library:
find_library(PYTHONLIB python3.8 HINTS /usr/lib/x86_64-linux-gnu/)
 
#Generate the shared library from the sources
add_executable(app ${SOURCES})

# Link to final executable
target_link_libraries(app ${PYTHONLIB})


