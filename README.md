# iOSMLBook

技術書「[Core ML Tools実践入門](https://shu223.booth.pm/items/1723495)」のサンプルコードです。

## 書籍の概要

**KerasやTensorFlowを用いて構築したカスタムモデルをiOSで利用する**ために必要な変換ツールである「Core ML Tools」（ライブラリ名／Pythonパッケージ名としては`coremltools`）の利用方法を**さまざまなモデルをつくりながら**学んでいきます。

最初はごくごくシンプルな画像分類CNNの構築方法からはじめてKerasやCore ML Toolsに入門しつつ、出力も画像となるタイプのモデルや、Core ML 3の目玉新機能である「オンデバイス学習」等も解説していきます。

<div align="center">

<img src="on-device-training.gif">
<br/>
(On-Device Training)
</div>

また`coremltools`, `tfcoreml`を駆使して学習済みモデルをCore MLモデルに変換する方法も、本書では詳しく解説します。インターネット上に数多く公開されている優れたモデル達を自らCore MLモデルに変換し、**必要に応じてカスタマイズ・改善**できるようになれば大きく引き出しが広がるでしょう。

<div align="center">

<img src="styletransfer.gif">
<br/>
(On-Device Training)
</div>

B5版、本文120ページ。

## 目次

第1章 準備

- 1.1 Core ML Toolsとは
- 1.2 Kerasとは
  - 1.2.1 KerasとCore ML Tools
  - 1.2.2 tf.kerasとスタンドアロン版Keras
- 1.3 Keras/TensorFlow/Core ML Toolsの環境構築

第2章 Keras & Core ML Tools入門

- 2.1 2行のコードで学習済みモデルをロードする
- 2.2 Core MLモデル形式に変換する
- 2.3 変換したモデルを.mlmodelファイルとして保存
- 2.4 保存したCore MLモデルファイルをXcodeで確認する

第3章 Kerasでカスタムモデル作成

- 3.1 モデルのネットワークを定義する
  - 3.1.1 Sequential モデル(とKeras functinal API)
  - 3.1.2 Conv2D
  - 3.1.3 MaxPooling2D
  - 3.1.4 Dropout
  - 3.1.5 Flatten
  - 3.1.6 Dense
  - 3.1.7 モデルのサマリを確認
- 3.2 モデルのコンパイル
  - 3.2.1 損失関数
  - 3.2.2 最適化アルゴリズム
  - 3.2.3 評価関数
- 3.3 モデルの学習
- 3.4 評価
- 3.5 モデルの保存

第4章 Kerasの学習済みモデルをCore MLモデルへ変換

- 4.1 Core ML Toolsで.mlmodelに変換する
- 4.2 Core MLモデルの入力の型を変更する
- Core MLモデルから自動生成されるSwiftコード
- 4.3 iOSで推論を実行
- Visionはどのように画像分類モデルを判定するか？

第5章 オンデバイス学習 - UpdatableなCore MLモデルの作成

- 5.1 モデルのパーソナライゼーション
- 5.2 ベースとなるモデルの作成
- 5.3 Updatableなモデルに変換する
- 5.4 損失関数をセットする
- 5.5 最適化アルゴリズムをセットする
- 5.6 エポック数をセットする
- 5.7 モデルを保存する

第6章 オンデバイス学習 - iOSで学習

- 6.1 MLUpdateTask
  - 6.1.1 mlmodelc
  - 6.1.2 MLBatchProvider, MLArrayBatchProvider
  - 6.1.3 MLTask
  - 6.1.4 オンデバイスモデル更新タスクの全体感
- 6.2 学習データの準備
- 6.3 学習タスクの実行
- 6.4 オンデバイスで学習したモデルを保存する / MLUpdateContext, MLWritable
- 6.5 推論処理の実行

第7章 TensorFlowモデルの変換 - 基礎編

- 7.1 tfcoreml
- 7.2 tfcoremlを用いたCore MLモデルへの変換（最小実装）
  - 7.2.1 学習済みモデル(.pbファイル)を読み込む 
  - 7.2.2 出力テンソルの名前を取得する 
  - 7.2.3 tfcoremlを用いて変換する 
- 7.3 より扱いやすいCoreMLモデルに変換する
  - 7.3.1 クラスラベルを指定する
  - 7.3.2 入力の型を画像に変更する
- 7.4 iOSで推論を実行 
- 7.5 入力画像の前処理を指定する

第8章 TensorFlowモデルの変換 - 画風変換モデル

- 8.1 学習済みモデルからグラフ定義を読み込む
- 8.2 変換に必要なグラフの情報を取得する
  - 8.2.1 入力テンソルの名前を取得する
  - 8.2.2 出力テンソルの名前を取得する
- 8.3 tfcoremlを用いて変換する
  - 8.3.1 入力テンソルのshapeを指定する
- 8.4 Core MLモデルの出力の型を変更する
- 8.5 iOSで画風変換を実行
  - 8.5.1 複数の入力を持つCore MLモデルをVisionで使う
  - 8.5.2 出力画像を取得する

第9章 モデルの可視化- 9.1 Netron
- 9.2 coremltoolsのvisualize_spec
- 9.3 TensorBoard
  - 9.3.1 TensorFlowモデルのグラフを可視化
  - 9.3.2 Kerasでの学習状況を可視化
- 9.4 Kerasのplot_model

付録A coremltools逆引きリファレンス
- A.1 モデルのSpecを取得する
  - A.1.1 .mlmodelファイルから取得する  - A.1.2 MLModelオブジェクトから取得する- A.2 MLModelオブジェクトを生成する  - A.2.1 Specから生成する  - A.2.2 .mlmodelファイルから生成する- A.3 NeuralNetworkBuilderを生成する- A.4 .mlmodelファイルの保存・読み込み  - A.4.1 .mlmodelファイルを読み込む  - A.4.2 .mlmodelファイルとして保存する  - A.5 モデルの中身を調べる  - A.5.1 モデルを可視化（ビジュアライズ）する  - A.5.2 モデルのバージョン（Specification Version）を確認する  - A.5.3 Specをログに出力する
  - A.5.4 モデルのレイヤー一覧を出力する
  - A.5.5 モデルの入力・出力を調べる
- A.6 Core MLモデルにクラスラベルを与える  - A.6.1 ラベル文字列の配列を渡す  - A.6.2 クラスラベルファイルのパスを渡す- A.7 モデルの入力・出力をカスタマイズする
  - A.7.1 入力・出力名を指定する  - A.7.2 変換時に入力の型を画像型にする
  - A.7.3 変換済みモデルの入力・出力の型を画像型にする  - A.7.4 入力テンソルのshapeを指定する
  - A.7.5 入力画像の前処理を指定する
- A.8 オンデバイス学習関連
  - A.8.1 モデルがUpdatableかどうかを調べる
  - A.8.2 Updatableなレイヤー一覧を出力  - A.8.3 Updatableなモデルに変換する
  - A.8.4 学習で使用する損失関数をセットする  - A.8.5 損失関数のサマリを確認する
  - A.8.6 学習で使用する最適化アルゴリズム（オプティマイザ）をセットする
  - A.8.7 最適化アルゴリズムを確認する
  - A.8.8 エポック数をセットする
