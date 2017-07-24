uni <- c("北海道大学獣医学部", "東北大学工学部", "東京大学教養学部",
         "名古屋大学情報学部", "京都大学医学部", "広島大学総合科学部",
         "九州大学農学部")
uni

grep("医学", uni) # 検索を行う関数
uni[c(1, 5)]
grep("医学", uni, value = TRUE) # 要素番号でなく文字列そのもの
sub("医学", "薬学", uni) # 置換「医学」⇒「薬学」

install.packages("stringr")
library(stringr)

# 検索
uni %>% str_detect("医学") # TRUE or FALSE
uni %>% str_subset("医学") # 文字列を表示

# 置換
uni %>% str_replace("京都", "東京")

# 部分抽出
uni %>% str_extract("医学")
# 役に立つ例
tel <- c("電話番号 00-123-5678", "市外局番 03", "電話は 09-876-5433")
tel %>% str_extract("\\d{2}-\\d{3}-\\d{4}")

# 正規表現
# 「いずれかの数字１つと一致する」
tel %>% str_extract("1|2|3|4|5|6|7|8|9|0") # 「あるいは」、「または」

## \\d(最初のバックスラッシュをエスケープ文字, \dをメタ文字という)
tel %>% str_extract("\\d") # \dは数字
tel %>% str_extract("\\d+") # +は１回以上の繰り返し
# 一致する全ての要素
tel %>% str_extract_all("\\d+") # 返り値はリスト型

# メタ文字の例
# \\d 数字 \\D 数字以外 \\w アルファベット, 数字, アンダーバー
# \\W アルファベットと数字、アンダーバーを除く文字
# \\s 空白文字 \\S 空白文字以外
# . 任意の文字 ^ 文字列の先頭 $ 文字列の末尾
# \n 改行 /t タブ

# 量指定子
# + 直前のパターンが１回以上続く
# ? 直前のパターンが0ないし1回続く
# * 直前のパターンが0回以上続く
# {n} 直前のパターンがちょうどn回繰り返す
# {n,} 直前のパターンがn回続く
# {n, m} 直前のパターンがn回以上m回以下続く

# 正規表現の制御式
# [] 指定された文字列のいずれか（文字クラス）
# () グループ化・後方参照
# \\p{Hiragana} Unicode プロパティー

weatehr <- c("今日は雪です", "昨日は雨でした", "明後日は晴れです")
weatehr %>% str_replace("[雪雨]", "晴れ")
# 角括弧を使って任意の文字を一致させる方法を「文字クラス」という

# 半角スペースで挟んだ氏名の氏だけ取り出したい場合
pm <- c("安倍 晋三", "野田 佳彦", "菅 直人", "鳩山 由紀夫", "麻生 太郎")
# 後方参照 グループ化したものは\\1, \\2のように参照できる
pm %>% str_replace("(\\w+) (\\w+)", "\\1")
# \\p{}はひらがなやカタナカ、漢字、ASCII文字を指定することができる
# Unicodeプロパティーを利用するにはstringrパッケージが必要
x <- "ひらがな hiragana カタカナ katakana 日本語 12345"
x %>% str_replace_all("\\p{ASCII}", "")
x %>% str_replace_all("\\p{Hiragana}", "")
x %>% str_replace_all("\\p{Katakana}", "")
x %>% str_replace_all("\\p{Han}", "") # 漢字

##########################################
# 英語文章
##########################################

install.packages("tm")
library(tm)
# VCorpusは一時的(volatile)にメモリ上に展開するために使う
# DirSource()では、文字コードや言語をreaderControl引数にリストとして指定できる
# XMLやPDFも可
alice <- VCorpus(DirSource(dir = "data/alice/"),
                 readerControl = list(language = "english"))

getReaders() %>% head() # 対応フォーマット

alice
alice %>% inspect # 情報
alice[[1]] %>% as.character() # テキスト本文表示
# ("")は冒頭2行が改行のみのため # tmの出力はリスト構造

# 空白文字などの削除(タブや改行も含む)
alice1 <- alice %>% tm_map(stripWhitespace)
alice1[[1]] %>% as.character()
library(magrittr)
# .,?などを削除
alice1 %<>% tm_map(removePunctuation) 
alice1[[1]] %>% as.character()
# 大文字小文字の統一
alice1 %<>% tm_map(content_transformer(tolower)) #大文字toupper
alice1[[1]] %>% as.character() 

# ストップワード(itやthe)の削除(後に半角処理必須)
alice1 %<>% tm_map(removeWords, stopwords("english"))
alice1[[1]] %>% as.character()
alice1 %<>% tm_map(stripWhitespace)

# ステミング(複数の語形をまとめる)
install.packages("SnowballC")
library(SnowballC)
alice1 %<>% tm_map(stemDocument)
alice1[[1]] %>% as.character()

# 一般にテキストマイニングでは複数のテキストを単語などの単位に分解した結果を行列にまとめる
# 単語文章行列の作成(単語文章行列はスパース(疎)が多い)
dtm <- TermDocumentMatrix(alice1)
dtm %>% inspect() # 行列の情報
# 一定回数以上出現の単語を調べる
dtm %>% findFreqTerms(3)
# 相関を調べる
dtm %>% findAssocs("alic", 0.8)

vignette("tm")

# 入力データとしてtmパッケージの出力を想定している場合がある
