# **PUEC** 2017年度調布祭AI対戦システム

## ゲーム概要

本ゲームは2017年度調布祭のAI対戦用のシステムです。  
それぞれがAIを設計し、AI同士を戦わせます。  
AI設計のための言語は [Processing](https://processing.org/) を利用します。

## 操作方法

### キャラ選択画面

* 十字キー: 移動  
* Zキー: 決定  
* Xキー: キャラ選択解除, 戻る

## 仕様

本ゲームはバトルロイヤル (last-man-standing) というジャンルで、  
最後の一人になるまで戦い合うというルールです。  
細かいルールは以下のようになります。

* ターン制でキャラクターは 1 ターンに一回行動できます。
* 行動は「待機」「武器を拾う」「アイテムを拾う」「東西南北に移動」「東西南北に攻撃」の  
  3+2*4=11 通りの行動を行うことが出来ます。
* フィールドは碁盤の目のようになっており、移動は 1 マスごとで、攻撃は武器によって射程が異なります。
* フィールドには家と小屋の 2 種類の建物のマス(現在のバージョンでは赤いマスが家、青いマスが小屋)があり、  
  そのマスには武器もしくはアイテムが落ちています。
* 家の中には武器が、小屋の中にはアイテムが落ちている可能性が高いです。
* 家と小屋の中には敵の攻撃は届きませんが、小屋の中から外へ攻撃することは出来ません。
* 小屋の中にいる際は周囲のAIに見つかりません。
* それぞれの武器には再び攻撃するのに必要なターン数があります。
* ターンが経過するとマップの四隅からダメージを受ける毒が広がっていきます。
* 毒は 15 ターン以降、5 ターンかけて毒が広がり、5 ターンは動きません。
* プレイヤーは自動生成されたマップ上にランダムにスポーンします。
* 最初に持っている武器はフライパン、最初に持っているアイテムはちくわです。
* 攻撃した際に周囲に攻撃した音が鳴り、AIはその音がした方角を捉えることが出来ます。
* プレイヤーの最大体力は100で、体力が0になると死亡判定となり行動できなくなります。

## AI作成の方法

1. このゲームは [Processing](https://processing.org/) で書かれています。Processingの開発環境を整えて下さい。
1. ProcessingでダウンロードしたPUEC.pdeを開き、一番右にあるタブの  
   `sampleAI`のタブを開いて下さい。
1. 1~3,9行目の`sampleAI`を自分のAIの名前に、4行目の`sampleAI.png`を  
   使いたいアイコンの名前を拡張子も含めて記入して下さい。
1. 15行目と17行目の間に記述した内容の返り値によって行われる行動が変わります。  
   返り値と行動はそれぞれ以下の通りになります。  
   ```text
    0: 何もしない
    1: 北に移動
    2: 南に移動
    3: 西に移動
    4: 東に移動
    5: 足元の武器と持っている武器を交換する
    6: 足元のアイテムと持っているアイテムを交換する
    7: アイテムを使う
    8: 北に向かって攻撃する
    9: 南に向かって攻撃する
   10: 西に向かって攻撃する
   11: 東に向かって攻撃する
   ```
1. 完成したらファイル名を自分のAIの名前に変えて下さい。
1. このままだとキャラクター選択画面に現れないので、PUBG.pdeの  
   44行目から48行目の間に `playerList[0~19] = new "AIの名前"()` のように記述して下さい。
1. dataフォルダに 3. で書いた名前の画像を置いて下さい。  
   これがAIのアイコンになります。 (必ず正方形に形を変えるため、正方形のほうが見栄えはいいでしょう。)

## AI作成のルール

* AIの処理でゲームの処理を行っている変数を不正に書き換えたりしないでください。
* AIの処理で不正な処理（ファイルの操作など）をしないでくさい。
* マップの情報やAIの情報の取得の際は以下の欄の関数以外を使用しないで下さい。

## 関数一覧

### プレイヤー自身の情報

`this.getX()`  
自分のいるX座標を返します。  
値は `int` 型で 0 以上の整数です。

`this.getY()`  
自分のいるY座標を返します。  
値は `int` 型で 0 以上の整数です。

`this.getItem()`  
自分の持っているアイテムIDを返します。  
値は `int` 型で 0 以上の整数です。

`this.getWeapon()`  
自分の持っている武器IDを返します。  
値は `int` 型で 0 以上の整数です。

`this.getDroppedItem()`  
自分の足元に落ちているアイテムIDを返します。  
値は `int` 型で 0 以上の整数です。

`this.getDroppedWeapon()`  
自分の足元に落ちている武器IDを返します。  
値は `int` 型で 0 以上の整数です。

`this.getHp()`  
自分の体力を返します  
値は `int` 型で 0 以上の整数です。

`this.getReloadTime()`  
自分の次の攻撃までにかかる時間を返します。  
 0 の場合は攻撃できます。  
値は `int` 型で 0 以上の整数です。

### 周囲の情報

`this.hearingGunSound()`  
自分の周囲 5 マスの攻撃した音の方角を配列で返します。  
{ 北西, 南西, 北東, 南東 } に音が聞こえたら 1 を返し、聞こえなかったら 0 を返します。

`this.searchingOtherPlayer(x,y)`  
自分の周囲 3 マス以内の座標を指定し、そこに敵がいるか確認します。  
範囲外,指定されたマスが小屋、もしくは敵がいなかった場合負の値を返し、居たら正の値を返します。  
値は `boolean` 型です。

### 指定位置の情報

`checkingStructure(x,y)`  
指定された座標の建物を返します。  

```text
0: なし
1: 家
2: 小屋
```

値は `int` 型です。

`checkingPoison(x,y)`  
指定された座標に毒が広がっているかどうかを返します。  
範囲外もしくは毒が広がっていない場合 0 を返し、毒が広がっていたら 1 を返します。  
値は `int` 型です。

`checkingCheckPoison(x,y)`  
指定された座標が次の毒が広がるときに、毒が広がるかどうかを返します。  
範囲外もしくは毒が広がらない場合 0 を返し、毒が広がる場合は 1 を返します。  
値は `int` 型です。

## アイテムと武器

### 武器

* ハンドガン
  * アイテムID: 1
  * 威力: 20
  * 射程: 2
  * リロード時間: 2

* ショットガン
  * アイテムID: 2
  * 威力: 30
  * 射程: 2
  * リロード時間: 3

* ライフル
  * アイテムID: 3
  * 威力: 25
  * 射程: 2
  * リロード時間: 3

* フライパン
  * アイテムID: 9
  * 威力: 15
  * 射程: 0 (自分のいるマスのみ攻撃範囲)
  * リロード時間: 0

### アイテム

* 包帯
  * アイテムID: 1
  * 回復量: 10

* 救急キット
  * アイテムID: 2
  * 回復量: 25

* 鎮痛剤
  * アイテムID: 3
  * 回復量: 15

* ちくわ
  * アイテムID: 9
  * 回復量: 5
