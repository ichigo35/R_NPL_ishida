library(RMeCab)

# 短い文章向け
RMeCabC("本を読んだ") # リストで返す

# ベクトル変換(品詞情報はベクトルの要素名)
RMeCabC("今日は本を読んだ") %>% unlist()
# 特定の品詞
hon <- RMeCabC("今日は本を読んだ。") %>% unlist()
hon[names(hon) %in% c("名詞", "動詞")]
# 表層語を原型に
RMeCabC("今日は本を読んだ。", 1) %>% unlist()

?RMeCabC

# 解析結果をすべて取り込む
file.exists("data/hon.txt") # ファイルが存在するか

RMeCabText("data/hon.txt")

# 一時ファイルを作成
tmp <- tempfile()
writeLines("本を買った", con = tmp)
x <- RMeCabText(tmp)
# 一時ファイルを削除
unlink(tmp)
# 解析結果を確認
x

# リストから要素を取り出す purrrパッケージ
install.packages("purrr")
library(purrr)
x %>% map_chr(extract(9))

tmp <- data.frame(BUN = "本を買った", stringAsFactor = FALSE)
x <- docDF(tmp, "BUN", type = 1)
x

# 頻度表の作成
merosu <- RMeCabFreq("data/merosu.txt") # 活用語は原型 ※品詞を指定できない
merosu %>% head()

# 延べ語数(トークン)、異なり語(タイプ)
# Term(単語(形態素)), 品詞大分類Info1, 品詞大分類Info2, 頻度Freq

# 品詞を限定して抽出
merosu <- docDF("data/merosu.txt",
                type = 1, pos = c("名詞", "形容詞", "動詞"))
merosu %>% head()

# 並び替え dplyrのarrange()
library(magrittr)
library(dplyr)
merosu %<>% rename(FREQ = merosu.txt) %>% arrange(FREQ)
merosu %>% tail()

# 形態素の検索
merosu %>% filter(TERM == "メロス")

merosu2 <- merosu %>% select(TERM, POS1, FREQ) %>%
  group_by(TERM, POS1) %>% # 品詞細分類は無視する(グループ化)
  summarize(FREQ = sum(FREQ)) # FREQ列を合計して１行にまとめる

merosu2 %>% NROW() # 行数(レコード数を表示)
merosu2 %>% filter(TERM == "メロス")

# 品詞の種別合計
merosu2 %>% group_by(POS1) %>% summarise(SUM = sum(FREQ))
# 割合
merosu2 %>% group_by(POS1) %>% summarize(SUM = sum(FREQ)) %>%
  mutate(PROP = SUM / sum(SUM))

# 大分類が○○で再分類が△△のような検索方法
merosu %>% filter(POS1 %in% c("動詞", "形容詞"), POS2 == "自立") %>% NROW()

##################################
# 共起語(collocation)
##################################

# キーワードや中心語、ノード(node)
# 前後の語数を指定した範囲をスパン(span)またはウィンドウ(window)という
res <- collocate("data/kumo.txt", node = "極楽", span = 3)
res %>% tail(15)
# Span出現頻度, Total全ての出現頻度
# スパンの総語数70-10(極楽)=60
# 総単語数 1808語 総タイプ数 413語

# 二つの単の頻度が有意に大きいか
# 正規分布を前提 単語は文法や書き手の意図に
# よるものなので正規分布を使うのは適切ではないという批判もある
# T値 = 実測値-期待値 / 実測値の平方根
# 1.65以上で二つの単語の共起は偶然ではないと考えられる

#MI値 相互情報量(ある記号が出現することが、別の特定の出現を予測させる度合い)
# 二つの単語の独立性を測る指標
# MI値 = log共起回数/共起語の期待値(対数の底は2)
# MI値は低頻度語を強調する傾向があるｍた、専門語のような
# テキストを特徴づける単語を抽出するのに役に立つ

log2(4/((4/1808) * 3 * 2 * 10))

