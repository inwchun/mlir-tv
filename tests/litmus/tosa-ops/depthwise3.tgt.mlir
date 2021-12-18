func @depthwise_conv(%arg0 : tensor<2x7x5x3xf32>, %arg1 : tensor<3x1x3x11xf32>, %arg2 : tensor<33xf32>) -> tensor<2x5x5x11xf32> {
  %in = tensor.extract_slice %arg0[0,0,0,2][2,7,5,1][1,1,1,1]: tensor<2x7x5x3xf32> to tensor<2x7x5x1xf32>
  %fil = tensor.extract_slice %arg1[0,0,2,0][3,1,1,11][1,1,1,1]: tensor<3x1x3x11xf32> to tensor<3x1x1x11xf32>
  %bias = tensor.extract_slice %arg2[22][11][1]: tensor<33xf32> to tensor<11xf32>
  %filperms = "tosa.const"() {value = dense<[3, 0, 1, 2]> : tensor<4xi64>} : () -> tensor<4xi64>
  %fil2 = "tosa.transpose"(%fil, %filperms) : (tensor<3x1x1x11xf32>, tensor<4xi64>) -> tensor<11x3x1x1xf32>
  %0 = "tosa.conv2d"(%in, %fil2, %bias) { pad = [0, 0, 0, 0], stride = [1, 1], dilation = [1, 1] } : (tensor<2x7x5x1xf32>, tensor<11x3x1x1xf32>, tensor<11xf32>)  -> (tensor<2x5x5x11xf32>)
  return %0 : tensor<2x5x5x11xf32>
}