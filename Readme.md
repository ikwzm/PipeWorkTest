*Testbench for PipeWork Components*
===================================

ダウンロード
------------

git clone https://github.com/ikwzm/PipeWorkTest.git
cd PipeWorkTest
git submodule init
git submodule update

GHDLによるシミュレーション
---------------------------

####Dummy_Plugのシミュレーション用ライブラリの構築####

pushd Dummy_Plug/sim/ghdl/dummy_plug
make
popd

####PipeWorkのシミュレーション用ライブラリの構築####

pushd PipeWork/sim/ghdl
make
popd

####AXI4_ADAPTERのシミュレーション####

pushd sim/ghdl/axi4_adapter
make
popd

####PUMP_AXI4のシミュレーション####

pushd sim/ghdl/pump_axi4
make
popd

ライセンス
----------

二条項BSDライセンス (2-clause BSD license) で公開しています。
