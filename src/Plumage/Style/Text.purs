module Plumage.Style.Text where

import Prelude
import React.Basic.Emotion (Style, css, em, int, rem, str)

textSized ∷ Number → Number → Style
textSized fs lh = css { fontSize: fs # rem, lineHeight: lh # rem }

textBase ∷ Style
textBase = textSized 1.0 1.5

textXs ∷ Style
textXs = textSized 0.75 1.0

textSm ∷ Style
textSm = textSized 0.875 1.25

textLg ∷ Style
textLg = textSized 1.125 1.75

textXl ∷ Style
textXl = textSized 1.25 1.75

text2xl ∷ Style
text2xl = textSized 1.5 2.0

text3xl ∷ Style
text3xl = textSized 1.875 2.25

text4xl ∷ Style
text4xl = textSized 2.25 2.5

text5xl ∷ Style
text5xl = textSized 3.0 3.0

text6xl ∷ Style
text6xl = textSized 3.75 3.75

text7xl ∷ Style
text7xl = textSized 4.5 4.5

text8xl ∷ Style
text8xl = textSized 6.0 6.0

text9xl ∷ Style
text9xl = textSized 8.0 8.0

fontThin ∷ Style
fontThin = css { fontWeight: int 100 }

fontExtralight ∷ Style
fontExtralight = css { fontWeight: int 200 }

fontLight ∷ Style
fontLight = css { fontWeight: int 300 }

fontNormal ∷ Style
fontNormal = css { fontWeight: int 400 }

fontMedium ∷ Style
fontMedium = css { fontWeight: int 500 }

fontSemibold ∷ Style
fontSemibold = css { fontWeight: int 600 }

fontBold ∷ Style
fontBold = css { fontWeight: int 700 }

fontExtrabold ∷ Style
fontExtrabold = css { fontWeight: int 800 }

fontBlack ∷ Style
fontBlack = css { fontWeight: int 900 }

trackingTighter ∷ Style
trackingTighter = css { letterSpacing: -0.05 # em }

trackingTight ∷ Style
trackingTight = css { letterSpacing: -0.025 # em }

trackingNormal ∷ Style
trackingNormal = css { letterSpacing: 0.0 # em }

trackingWide ∷ Style
trackingWide = css { letterSpacing: 0.025 # em }

trackingWider ∷ Style
trackingWider = css { letterSpacing: 0.05 # em }

trackingWidest ∷ Style
trackingWidest = css { letterSpacing: 0.1 # em }

fontFamilyOrSans ∷ String → Style
fontFamilyOrSans ff = css { fontFamily: str $ ff <> ", sans-serif" }

fontFamilyOrSerif ∷ String → Style
fontFamilyOrSerif ff = css { fontFamily: str $ ff <> ", serif" }

fontFamilyOrMono ∷ String → Style
fontFamilyOrMono ff = css { fontFamily: str $ ff <> ", monospace" }

underline :: Style
underline = css { textDecoration: str "underline" }