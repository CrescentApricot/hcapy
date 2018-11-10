# hcapy

hca2wav wrapper working on Python3.

## 概要

[@Nyagamon](https://github.com/Nyagamon)さんの[HCADecoder](https://github.com/Nyagamon/HCADecoder)をベースにしたhcaデコーダ、[hca2wav](https://github.com/CrescentApricot/hca2wav)のPython3ラッパーです。<br>

## 依存
- Python3
- C++11

## インストール

```
pip3 install git+ssh://git@github.com/CrescentApricot/hcapy.git
```

## 使い方

```python
import hcapy

d = hcapy.Decoder(961961961961961)  # 鍵指定

d.decode_file("target_file.hca")  # target_file.hcaを指定した鍵でデコード

try:
  with open("target_file.hca", "rb") as f, open("decoded.wav", "wb") as f2:
    f2.write(d.decode(f.read()).read())  # bytesからデコード、io.BytesIOでリターンする
except hcapy.InvalidHCAError:
  print("invalid hca!")
```

### 鍵について

上記コードでは `961961961961961` のようなintで指定していますが、`"0x36ae63907b9e9"`のような形式でも、`"36ae63907b9e9"`のような形式でも、`"3907b9e9", "36ae"`のような形式でも指定可能です。

### 出力ファイルパスについて

`decode_file` の場合、出力ファイルパスを引数 `dest` に指定することができますが、指定しないこともできます。指定しない場合、`src` と同じディレクトリに生成されます。

## 実装予定

- ~~`bytes` からのデコード~~ (無理やり実装済み)
- コマンドラインツール
- パッケージ構成の正規化（hcapy.Decoder, hcapy.exceptions.Invalid...）
