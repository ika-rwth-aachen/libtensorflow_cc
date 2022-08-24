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
  session.Run({A, x, b}, &outputs);

  // print results
  cout << "Hello from TensorFlow C++ " << TF_VERSION_STRING << "!" << endl << endl;
  cout << "A = " << endl << outputs[0].tensor<int, 2>() << endl << endl;
  cout << "x = " << endl << outputs[1].tensor<int, 2>() << endl << endl;
  cout << "A * x = " << endl << outputs[2].tensor<int, 2>() << endl;

  return 0;
}