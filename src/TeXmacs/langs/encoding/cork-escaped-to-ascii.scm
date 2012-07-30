;; Escaping one-byte-per-character strings internally used by
;; texmacs (cork encoding) to ascii-only strings suitable to be
;; incorporated in xml.
;; Since the output is ascii-only it can also be considered as utf-8

;; This file was added to escape texmacs code for embedding into
;; svg images 

;; (C) 2012  P. Joyez
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.


;; ! we need to input double backslash to really get only one
;; and 8 (!!!) to really get two! 

("#00"	"\\x00");!! this character occurs in postscript images raw-data but never gets
;; escaped through here. Don't know why. That breaks xml...
("#01"	"\\x01")
("#02"	"\\x02")
("#03"	"\\x03")
("#04"	"\\x04")
("#05"	"\\x05")
("#06"	"\\x06")
("#07"	"\\x07")
("#08"	"\\x08")
("#09"	"\\t")
("#0A"	"\\n")
("#0B"	"\\x0b")
("#0C"	"\\x0c")
("#0D"	"\\r")
("#0E"	"\\x0e")
("#0F"	"\\x0f")
("#10"	"\\x10")
("#11"	"\\x11")
("#12"	"\\x12")
("#13"	"\\x13")
("#14"	"\\x14")
("#15"	"\\x15")
("#16"	"\\x16")
("#17"	"\\x17")
("#18"	"\\x18")
("#19"	"\\x19")
("#1A"	"\\x1a")
("#1B"	"\\x1b")
("#1C"	"\\x1c")
("#1D"	"\\x1d")
("#1E"	"\\x1e")
("#1F"	"\\x1f")
("#20"	" ")
("#21"	"!")
("#22"	"&quot;")
("#23"	"#")
("#24"	"$")
("#25"	"%")
("#26"	"&amp;")
("#27"	"\\'")
("#28"	"(")
("#29"	")")
("#2A"	"*")
("#2B"	"+")
("#2C"	",")
("#2D"	"-")
("#2E"	".")
("#2F"	"/")
("#30"	"0")
("#31"	"1")
("#32"	"2")
("#33"	"3")
("#34"	"4")
("#35"	"5")
("#36"	"6")
("#37"	"7")
("#38"	"8")
("#39"	"9")
("#3A"	":")
("#3B"	";")
("#3C"	"&lt;")
("#3D"	"=")
("#3E"	"&gt;")
("#3F"	"?")
("#40"	"@")
("#41"	"A")
("#42"	"B")
("#43"	"C")
("#44"	"D")
("#45"	"E")
("#46"	"F")
("#47"	"G")
("#48"	"H")
("#49"	"I")
("#4A"	"J")
("#4B"	"K")
("#4C"	"L")
("#4D"	"M")
("#4E"	"N")
("#4F"	"O")
("#50"	"P")
("#51"	"Q")
("#52"	"R")
("#53"	"S")
("#54"	"T")
("#55"	"U")
("#56"	"V")
("#57"	"W")
("#58"	"X")
("#59"	"Y")
("#5A"	"Z")
("#5B"	"[")
("#5C"	"\\\\\\\\") ; believe it or not this what's needed to get "\" -> "\\" in the end!
("#5D"	"]")
("#5E"	"^")
("#5F"	"_")
("#60"	"`")
("#61"	"a")
("#62"	"b")
("#63"	"c")
("#64"	"d")
("#65"	"e")
("#66"	"f")
("#67"	"g")
("#68"	"h")
("#69"	"i")
("#6A"	"j")
("#6B"	"k")
("#6C"	"l")
("#6D"	"m")
("#6E"	"n")
("#6F"	"o")
("#70"	"p")
("#71"	"q")
("#72"	"r")
("#73"	"s")
("#74"	"t")
("#75"	"u")
("#76"	"v")
("#77"	"w")
("#78"	"x")
("#79"	"y")
("#7A"	"z")
("#7B"	"{")
("#7C"	"|")
("#7D"	"}")
("#7E"	"~")
("#7F"	"\\x7f")
("#80"	"\\x80")
("#81"	"\\x81")
("#82"	"\\x82")
("#83"	"\\x83")
("#84"	"\\x84")
("#85"	"\\x85")
("#86"	"\\x86")
("#87"	"\\x87")
("#88"	"\\x88")
("#89"	"\\x89")
("#8A"	"\\x8a")
("#8B"	"\\x8b")
("#8C"	"\\x8c")
("#8D"	"\\x8d")
("#8E"	"\\x8e")
("#8F"	"\\x8f")
("#90"	"\\x90")
("#91"	"\\x91")
("#92"	"\\x92")
("#93"	"\\x93")
("#94"	"\\x94")
("#95"	"\\x95")
("#96"	"\\x96")
("#97"	"\\x97")
("#98"	"\\x98")
("#99"	"\\x99")
("#9A"	"\\x9a")
("#9B"	"\\x9b")
("#9C"	"\\x9c")
("#9D"	"\\x9d")
("#9E"	"\\x9e")
("#9F"	"\\x9f")
("#A0"	"\\xa0")
("#A1"	"\\xa1")
("#A2"	"\\xa2")
("#A3"	"\\xa3")
("#A4"	"\\xa4")
("#A5"	"\\xa5")
("#A6"	"\\xa6")
("#A7"	"\\xa7")
("#A8"	"\\xa8")
("#A9"	"\\xa9")
("#AA"	"\\xaa")
("#AB"	"\\xab")
("#AC"	"\\xac")
("#AD"	"\\xad")
("#AE"	"\\xae")
("#AF"	"\\xaf")
("#B0"	"\\xb0")
("#B1"	"\\xb1")
("#B2"	"\\xb2")
("#B3"	"\\xb3")
("#B4"	"\\xb4")
("#B5"	"\\xb5")
("#B6"	"\\xb6")
("#B7"	"\\xb7")
("#B8"	"\\xb8")
("#B9"	"\\xb9")
("#BA"	"\\xba")
("#BB"	"\\xbb")
("#BC"	"\\xbc")
("#BD"	"\\xbd")
("#BE"	"\\xbe")
("#BF"	"\\xbf")
("#C0"	"\\xc0")
("#C1"	"\\xc1")
("#C2"	"\\xc2")
("#C3"	"\\xc3")
("#C4"	"\\xc4")
("#C5"	"\\xc5")
("#C6"	"\\xc6")
("#C7"	"\\xc7")
("#C8"	"\\xc8")
("#C9"	"\\xc9")
("#CA"	"\\xca")
("#CB"	"\\xcb")
("#CC"	"\\xcc")
("#CD"	"\\xcd")
("#CE"	"\\xce")
("#CF"	"\\xcf")
("#D0"	"\\xd0")
("#D1"	"\\xd1")
("#D2"	"\\xd2")
("#D3"	"\\xd3")
("#D4"	"\\xd4")
("#D5"	"\\xd5")
("#D6"	"\\xd6")
("#D7"	"\\xd7")
("#D8"	"\\xd8")
("#D9"	"\\xd9")
("#DA"	"\\xda")
("#DB"	"\\xdb")
("#DC"	"\\xdc")
("#DD"	"\\xdd")
("#DE"	"\\xde")
("#DF"	"\\xdf")
("#E0"	"\\xe0")
("#E1"	"\\xe1")
("#E2"	"\\xe2")
("#E3"	"\\xe3")
("#E4"	"\\xe4")
("#E5"	"\\xe5")
("#E6"	"\\xe6")
("#E7"	"\\xe7")
("#E8"	"\\xe8")
("#E9"	"\\xe9")
("#EA"	"\\xea")
("#EB"	"\\xeb")
("#EC"	"\\xec")
("#ED"	"\\xed")
("#EE"	"\\xee")
("#EF"	"\\xef")
("#F0"	"\\xf0")
("#F1"	"\\xf1")
("#F2"	"\\xf2")
("#F3"	"\\xf3")
("#F4"	"\\xf4")
("#F5"	"\\xf5")
("#F6"	"\\xf6")
("#F7"	"\\xf7")
("#F8"	"\\xf8")
("#F9"	"\\xf9")
("#FA"	"\\xfa")
("#FB"	"\\xfb")
("#FC"	"\\xfc")
("#FD"	"\\xfd")
("#FE"	"\\xfe")
("#FF"	"\\xff")
