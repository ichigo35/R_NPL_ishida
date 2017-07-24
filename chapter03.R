# Ctrl+Enterで実行
x <- 1:10 #代入演算子(付値演算子)
x #オブジェクト
getwd() #ワークスペース 区切りは\ではなく/
# setwd()でワーキングスペースの偏向
# 通常ワークスペース(加工したデータをファイルとして
# 保存すること)は保存しない。スクリプトで再現可
# R/RStudioを起動して終了するまでをセッション
# NA(not available, 欠損値)
y <- c(1, 20, 100) # ベクトル(Javaでいう配列)
y
z <- c("あ", "いう", "えおか")
z
onetwothree <- c(1, "1", 2, "ニ", 3)
onetwothree
options(width = 50) #コンソールの表示幅
LETTERS
# [23]は右の要素が23番目を表す(添字)
LETTERS[c(1, 12, 23)]
sum(1:10)
?sum
# Alt + Shift + kでショートカット確認
df1 <- data.frame(クラス = c("B", "A", "A", "B", "C", "A"),
                     名前 = c("逢坂", "萩窪", "芽原", "金元", "原田", "佐倉"),
                     英語 = c(77, 90, 79, 76, 67, 72),
                     現文 = c(67, 86, 81, 75, 66, 84), 
                     数学 = c(45, 73, 45, 92, 54, 50))
df1

dat <- read.csv("data/classes.csv", fileEncoding = "CP932") # shift-jis = CP932

dat[1:3, c(2,5)] # [行, 列]
dat[1:3,]
colMeans(dat[, -c(1,2)]) # 各科目の平均点
dat$クラス # カテゴリ変数(因子, Factor , 内部的には数値として扱う), ラベルを水準(levels)
str(dat$クラス) # 
dat <- read.csv("data/classes.csv",
                fileEncoding = "CP932",
                stringsAsFactors = FALSE) # 文字列を因子にする機能を無効
str(dat)
# xlsx(エクセレックス, エクセルエックス)を読み込む
install.packages("readxl")
library(readxl) # 「読み込む」「ロード」するという
dat <- read_excel("data/classes.xlsx") # 拡張データ構造として管理する
head(dat)
# <chr> 文字(cahracter)型, <dbl>実数(double)型 

# 要素数がそれぞれ異なるベクトルをリストは当てはめることができる
# リストにはベクトルやデータフレームが入るので入れ子の処理が必要になる場合がある(使いにくい)
dat <- data.frame(A = c("A", "B", "C"), a = c("a", "b"))
# Error in data.frame(A = c("A", "B", "C"), a = c("a", "b")) : 
# 引数に異なる列数のデータフレームが含まれています: 3, 2 のエラーが出現する

dat <- list(A = c("A", "B", "C"), a = c("a", "b"))
dat
dat[[2]] #要素を指定する dat$a
dat$a

library(RMeCab)
RMeCabText("data/hon.txt")

# リストの繰り返し
myList <- list(A = 1:10, B = 12:18, C = 23:27)
myList
# リストの要素毎に指定した関数を実行するlapply()
lapply(myList, mean)
sapply(myList, mean) # s(simple), 返り値をベクトルに

# 行列 データの型が統一されている 行数(nrow), 列数(ncol)
mat <- matrix(1:9, nrow = 3)
mat
mat[2:3, 1:2]

# パイプ処理
install.packages("dplyr")
library(dplyr)

head(ToothGrowth)
# 伝統的処理方法
head(ToothGrowth[ToothGrowth$supp == "OJ", ])
# subset()を使用した処理方法(head()で囲むととたんにコードの見通しが悪くなる)
head(subset(ToothGrowth, supp == "OJ"))
# パイプ演算子 %>%(Ctrlを押したままで可能) 左から右に処理を流していく(ベストアクト)
# 括弧の中に処理を次々と入れ子にして、処理が中から外に向かうより処理が右に向かっていく方がわかりやすい
ToothGrowth %>% filter(supp == "OJ") %>% head()

# データフレームの操作
# 列の指定select()
ToothGrowth %>% select(length = len, supp_type = supp) %>% head()
# 行の指定filter()
ToothGrowth %>% filter(len > 25, dose == 2.0) %>% head()
# 値の操作mutate()
ToothGrowth %>% mutate(len2 = len * 0.039) %>% head()

library(magrittr) # %<>% 左辺を右辺の関数の実行結果で上書きできる
ToothGrowth %<>% mutate(len = len * 0.039)
ToothGrowth

vignette("compatibility", package = "dplyr") #ビネットという資料

# 制御構文
x <- 1:10
tmp <- 0
for (i in x){ # iはベクトル xの要素をiに代入
  tmp <- tmp + i
}
tmp
# 同様の処理
x <- 1:10
sum(x) # 「ベクトル演算に対応している」
# Rにおててデータはベクトルを基本単位としているため、
# 関数のほとんどがベクトルから要素を一つずつ取り出す仕組みが備わっている
# したがって、Rではループ処理を行うことが少ない

# 条件分布if()
x <- 8
if(x %% 2 == 0) { # %%は除算演算子
  print("偶数") # 真(TRUE)
} else {
  print("奇数") # 偽(FALSE)
}

# 関数の定義(関数の実装)
mySum <- function(vec) {
  tmp <- 0
  for (i in vec){
    tmp <- tmp + i
  }
  tmp
}
# 実行してみる
x <- 1:10
mySum(x)

# ユーザが関数を定義するにはfunction()を使用する、本来は引数のチェック（検証）をするべき
# Rにはこうしたエラーチェック（例外処理）が細かく設定されている


summary(ToothGrowth) # 基本統計量一覧 
mean(ToothGrowth$len) # 平均
var(ToothGrowth$len) # 分散
sd(ToothGrowth$len) # 標準偏差
median(ToothGrowth$len) # 中央値
length(ToothGrowth$len) # 長さ（要素数）
nrow(ToothGrowth) # 行数
ncol(ToothGrowth) # 列数
head(ToothGrowth, n = 10) # 冒頭を表示
head(ToothGrowth, n = 10) # 末尾を表示
aggregate() # 要約 データをカテゴリ水準ごとにグループ化して統計量を求められる
aggregate(len ~ supp, data = ToothGrowth, FUN = mean)
# 左辺の変数を右辺のカテゴリでグループ化する FUNでグループ毎に指定された関数を適応する

# 検索用の演算子 %in%
aiu <- c("あ", "い", "う", "え", "お")
aiu %in% c("え", "い")
aiu[aiu %in% c("え", "い")]

# 文字列の結合 paste() paste0()は半角スペースを挟まない
paste("被験者", 1:30, sep = "-")

# 名前付きベクトル (属性)
animals <- c(犬 = 1, 猫 = 2, 猿 = 3)
animals
names(animals) # 名前だけを取り出す chr型
animals * 3
# Rはデータ解析・グラフィックス作成環境と呼ばれる
install.packages("ggplot2")
# グラフィックスソフトウェアでいうレイヤーに近い概念を使用している
# ⇒画像の土台としてデータを指定して、これに散布図、棒を重ねるという手順で作成する
library(ggplot2)
# p1(plot1)
# ggplot()で描画の対象となるデータとその変数を指定する(iris)
# aes()で描画する対象を選ぶ
# p1はグラフィックスの土台
library(dplyr)
library(ggplot2)
p1 <- iris %>% ggplot(aes(x = Sepal.Length, y = Sepal.Width, color = Species))
# 種類(レイヤー)を指定する +で追加 geom_point()は散布図
# 散布図
p1 + geom_point(size=4, alpha=0.3)
# 折れ線グラフ
p1 + geom_path(size=1, linetype="dashed") # データ順に結ぶ
p1 + geom_line(size=1) # x軸上の順で結ぶ
p1 + geom_step(size=1) # 階段状に結ぶ
# ヒストグラム、密度曲線
p1


# .Rprofileでフォントの設定
source("http://rmecab.jp/R/Rprofile.R")
