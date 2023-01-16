/*
==============================================================================
MIT License
Copyright 2022 Institute for Automotive Engineering of RWTH Aachen University.
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
==============================================================================
*/

#include <iostream>
#include <vector>

#include <tensorflow/cc/client/client_session.h>
#include <tensorflow/cc/ops/standard_ops.h>
#include <tensorflow/core/framework/tensor.h>
#include <tensorflow/core/public/version.h>

using namespace std;


int main(int argc, char **argv) {

  // create new session
  auto scope = tensorflow::Scope::NewRootScope();
  tensorflow::ClientSession session(scope);

  // define graph of operations
  auto A = tensorflow::ops::Const(scope, {{1, 2}, {3, 4}});
  auto x = tensorflow::ops::Const(scope, {{1}, {2}});
  auto b = tensorflow::ops::MatMul(scope, A, x);

  // run graph and fetch outputs of A, x, and b
  vector<tensorflow::Tensor> outputs;
  tensorflow::Status status = session.Run({A, x, b}, &outputs);
  if (!status.ok())
    throw std::runtime_error("Failed to run TensorFlow graph: " + status.ToString());

  // print results
  cout << "Hello from TensorFlow C++ " << TF_VERSION_STRING << "!" << endl << endl;
  cout << "A = " << endl << outputs[0].tensor<int, 2>() << endl << endl;
  cout << "x = " << endl << outputs[1].tensor<int, 2>() << endl << endl;
  cout << "A * x = " << endl << outputs[2].tensor<int, 2>() << endl;

  return 0;
}