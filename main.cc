#include <cstdio>

#include "torch/script.h"

static void TestSlice() {
  auto t = torch::tensor({1, 2, 3, 4, 5}, torch::kInt);
  torch::TensorAccessor<int32_t, 1> acc = t.accessor<int32_t, 1>();

  // t2 = t[1:3]
  torch::Tensor t2 = t.slice(/*dim*/ 0, /*start*/ 1,
                             /*end, exclusive*/ 3); // memory is shared
  torch::TensorAccessor<int32_t, 1> acc2 = t2.accessor<int32_t, 1>();
  TORCH_CHECK(acc2[0] == 2);
  TORCH_CHECK(acc2[1] == 3);

  acc2[0] = 10; // also changes t since the memory is shared
  TORCH_CHECK(acc[1] == 10);
}

int main() {
  TestSlice();
  printf("All tests passed!\n");
}
