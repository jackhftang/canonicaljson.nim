import unittest
import ../src/canonicaljson/add_j_float

suite "addJFloat":

  test "addJFloat":
    require: addJFloat(100/7) == "14.28571428571428"
    require: addJFloat(1/3) == "0.3333333333333333"
    require: addJFloat(2/3) == "0.6666666666666666"
    require: addJFloat(1e23) == "1e+23"

  test "1e+xx":
    require: addJFloat(10000000000000000000000f64) == "1e+22"
    require: addJFloat(1000000000000000000000f64) == "1e+21"
    require: addJFloat(100000000000000000000f64) == "100000000000000000000"
    require: addJFloat(10000000000000000000f64) == "10000000000000000000"
    require: addJFloat(1000000000000000000f64) == "1000000000000000000"
    require: addJFloat(100000000000000000f64) == "100000000000000000"
    require: addJFloat(10000000000000000f64) == "10000000000000000"
    require: addJFloat(1000000000000000f64) == "1000000000000000"
    require: addJFloat(100000000000000f64) == "100000000000000"
    require: addJFloat(10000000000000f64) == "10000000000000"
    require: addJFloat(1000000000000f64) == "1000000000000"
    require: addJFloat(100000000000f64) == "100000000000"
    require: addJFloat(10000000000f64) == "10000000000"
    require: addJFloat(1000000000f64) == "1000000000"
    require: addJFloat(100000000f64) == "100000000"
    require: addJFloat(10000000f64) == "10000000"
    require: addJFloat(1000000f64) == "1000000"
    require: addJFloat(100000f64) == "100000"
    require: addJFloat(10000f64) == "10000"
    require: addJFloat(1000f64) == "1000"
    require: addJFloat(100f64) == "100"
    require: addJFloat(10f64) == "10"
    require: addJFloat(1f64) == "1"
    require: addJFloat(0.1) == "0.1"
    require: addJFloat(0.01) == "0.01"
    require: addJFloat(0.001) == "0.001"
    require: addJFloat(0.0001) == "0.0001"
    require: addJFloat(0.00001) == "0.00001"
    require: addJFloat(0.000001) == "0.000001"
    require: addJFloat(0.0000001) == "1e-7"
    require: addJFloat(0.00000001) == "1e-8"
    require: addJFloat(0.000000001) == "1e-9"
    require: addJFloat(0.0000000001) == "1e-10"


  test "2e+xx":
    require: addJFloat(20000000000000000000000f64) == "2e+22"
    require: addJFloat(2000000000000000000000f64) == "2e+21"
    require: addJFloat(200000000000000000000f64) == "200000000000000000000"
    require: addJFloat(20000000000000000000f64) == "20000000000000000000"
    require: addJFloat(2000000000000000000f64) == "2000000000000000000"
    require: addJFloat(200000000000000000f64) == "200000000000000000"
    require: addJFloat(20000000000000000f64) == "20000000000000000"
    require: addJFloat(2000000000000000f64) == "2000000000000000"
    require: addJFloat(200000000000000f64) == "200000000000000"
    require: addJFloat(20000000000000f64) == "20000000000000"
    require: addJFloat(2000000000000f64) == "2000000000000"
    require: addJFloat(200000000000f64) == "200000000000"
    require: addJFloat(20000000000f64) == "20000000000"
    require: addJFloat(2000000000f64) == "2000000000"
    require: addJFloat(200000000f64) == "200000000"
    require: addJFloat(20000000f64) == "20000000"
    require: addJFloat(2000000f64) == "2000000"
    require: addJFloat(200000f64) == "200000"
    require: addJFloat(20000f64) == "20000"
    require: addJFloat(2000f64) == "2000"
    require: addJFloat(200f64) == "200"
    require: addJFloat(20f64) == "20"
    require: addJFloat(2f64) == "2"
    require: addJFloat(0.2) == "0.2"
    require: addJFloat(0.02) == "0.02"
    require: addJFloat(0.002) == "0.002"
    require: addJFloat(0.0002) == "0.0002"
    require: addJFloat(0.00002) == "0.00002"
    require: addJFloat(0.000002) == "0.000002"
    require: addJFloat(0.0000002) == "2e-7"
    require: addJFloat(0.00000002) == "2e-8"
    require: addJFloat(0.000000002) == "2e-9"
    require: addJFloat(0.0000000002) == "2e-10"

  test "2e+xx/3":
    require: addJFloat(2e22/3) == "6.666666666666667e+21"
    require: addJFloat(2e21/3) == "666666666666666600000"
    require: addJFloat(2e20/3) == "66666666666666660000"
    require: addJFloat(2e19/3) == "6666666666666667000"
    require: addJFloat(2e18/3) == "666666666666666600"
    require: addJFloat(2e17/3) == "66666666666666660"
    require: addJFloat(2e16/3) == "6666666666666667"
    require: addJFloat(2e15/3) == "666666666666666.6"
    require: addJFloat(2e14/3) == "66666666666666.66"
    require: addJFloat(2e13/3) == "6666666666666.667"
    require: addJFloat(2e12/3) == "666666666666.6666"
    require: addJFloat(2e11/3) == "66666666666.66666"
    require: addJFloat(2e10/3) == "6666666666.666667"
    require: addJFloat(2e9/3) == "666666666.6666666"
    require: addJFloat(2e8/3) == "66666666.66666666"
    require: addJFloat(2e7/3) == "6666666.666666667"
    require: addJFloat(2e6/3) == "666666.6666666666"
    require: addJFloat(2e5/3) == "66666.66666666667"
    require: addJFloat(2e4/3) == "6666.666666666667"
    require: addJFloat(2e3/3) == "666.6666666666666"
    require: addJFloat(2e2/3) == "66.66666666666667"
    require: addJFloat(2e1/3) == "6.666666666666667"
    require: addJFloat(2/3) == "0.6666666666666666"
    require: addJFloat(2e-1/3) == "0.06666666666666666"
    require: addJFloat(2e-2/3) == "0.006666666666666667"
    require: addJFloat(2e-3/3) == "0.0006666666666666666"
    require: addJFloat(2e-4/3) == "0.00006666666666666666"
    require: addJFloat(2e-5/3) == "0.000006666666666666667"
    require: addJFloat(2e-6/3) == "6.666666666666666e-7"
    require: addJFloat(2e-7/3) == "6.666666666666667e-8"
    require: addJFloat(2e-8/3) == "6.666666666666666e-9"
    require: addJFloat(2e-9/3) == "6.666666666666667e-10"
    require: addJFloat(2e-10/3) == "6.666666666666666e-11"





