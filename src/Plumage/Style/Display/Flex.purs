module Plumage.Style.Display.Flex where


import React.Basic.Emotion (Style, center, column, css, flex, flexEnd, flexStart, int, nowrap, row, spaceAround, spaceBetween, spaceEvenly, str, wrap, px)

flexCol ∷ Style
flexCol =
  css
    { display: flex
    , flexDirection: column
    }

flexRow ∷ Style
flexRow =
  css
    { display: flex
    , flexDirection: row
    }

flexGrow :: Int -> Style
flexGrow g = css { flexGrow: int g }

flexWrap :: Style
flexWrap = css { flexWrap: wrap }

flexNoWrap :: Style
flexNoWrap = css { flexWrap: nowrap }

flexWrapReverse :: Style
flexWrapReverse = css { flexWrap: str "wrap-reverse" }

gap :: Int -> Style
gap x = css { gap: px x }

justifyStart :: Style
justifyStart = css { justifyContent: flexStart }
justifyEnd :: Style
justifyEnd = css { justifyContent: flexEnd }
justifyCenter :: Style
justifyCenter = css { justifyContent: center }
justifyBetween :: Style
justifyBetween = css { justifyContent: spaceBetween}
justifyAround :: Style
justifyAround = css { justifyContent: spaceAround}
justifyEvenly :: Style
justifyEvenly = css { justifyContent: spaceEvenly}