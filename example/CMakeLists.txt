cmake_minimum_required(VERSION 3.0.2)
project(hello_tensorflow VERSION 1.0.0 LANGUAGES CXX)

find_package(TensorFlow REQUIRED)

add_executable(${PROJECT_NAME} hello_tensorflow.cpp)

include_directories(${PROJECT_NAME} ${TensorFlow_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${TensorFlow_LIBRARIES})