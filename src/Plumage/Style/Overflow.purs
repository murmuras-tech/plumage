module Plumage.Style.Overflow where

import React.Basic.Emotion (Style, css, hidden, str)

overflowHidden ∷ Style
overflowHidden = css { overflow: hidden }

overflowXHidden ∷ Style
overflowXHidden = css { overflowX: hidden }

overflowYHidden ∷ Style
overflowYHidden = css { overflowY: hidden }

textOverflowEllipsis ∷ Style
textOverflowEllipsis = css { textOverflow: str "ellipsis" }
