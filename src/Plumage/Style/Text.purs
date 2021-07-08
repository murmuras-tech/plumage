module Plumage.Style.Text where

import Prelude

import React.Basic.Emotion (Style, css, int, rem)

textSized :: Number -> Number -> Style
textSized fs lh = css { fontSize: fs # rem, lineHeight: lh # rem } 

textBase :: Style
textBase = textSized 1.0 1.5
textXs :: Style
textXs = textSized 0.75 1.0
textSm :: Style
textSm = textSized 0.875 1.25
textLg :: Style
textLg = textSized 1.125 1.75
textXl :: Style
textXl =  textSized 1.25 1.75
text2xl :: Style
text2xl = textSized 1.5 2.0
text3xl :: Style
text3xl = textSized 1.875 2.25
text4xl :: Style
text4xl = textSized 2.25 2.5
text5xl :: Style
text5xl = textSized 3.0 1.0
text6xl :: Style
text6xl = textSized 3.75 1.0
text7xl :: Style
text7xl = textSized 4.5 1.0
text8xl :: Style
text8xl = textSized 6.0 1.0
text9xl :: Style
text9xl = textSized 8.0 1.0

fontThin :: Style
fontThin = css { fontWeight: int 100 }
fontExtralight :: Style
fontExtralight = css { fontWeight: int 200 }
fontLight :: Style
fontLight = css { fontWeight: int 300 }
fontNormal :: Style
fontNormal = css { fontWeight: int 400 }
fontMedium :: Style
fontMedium = css { fontWeight: int 500 }
fontSemibold :: Style
fontSemibold = css { fontWeight: int 600 }
fontBold :: Style
fontBold = css { fontWeight: int 700 }
fontExtrabold :: Style
fontExtrabold = css { fontWeight: int 800 }
fontBlack :: Style
fontBlack = css { fontWeight: int 900 }