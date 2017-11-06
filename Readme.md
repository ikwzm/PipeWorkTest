Testbench for PipeWork Components
=================================

ダウンロード
------------

```
shell$ git clone https://github.com/ikwzm/PipeWorkTest.git
shell$ cd PipeWorkTest
shell$ git submodule init
shell$ git submodule update
```

GHDLによるシミュレーション
---------------------------

### Dummy_Plugのシミュレーション用ライブラリの構築

```
shell$ pushd Dummy_Plug/sim/ghdl/dummy_plug
shell$ make
shell$ popd
```

### PipeWorkのシミュレーション用ライブラリの構築

```
shell$ pushd PipeWork/sim/ghdl
shell$ make
shell$ popd
```

### AXI4_ADAPTERのシミュレーション

```
shell$ pushd sim/ghdl/axi4_adapter
shell$ make
shell$ popd
```

### PUMP_AXI4のシミュレーション

```
shell$ pushd sim/ghdl/pump_axi4
shell$ make
shell$ popd
```

ライセンス
----------

二条項BSDライセンス (2-clause BSD license) で公開しています。
