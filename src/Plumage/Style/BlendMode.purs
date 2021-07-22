module Plumage.Style.BlendMode where

import Plumage.Style.BlendMode.Types (BlendMode, blendModeToStyleProperty)
import React.Basic.Emotion (Style, css)

mixBlendMode ∷ BlendMode → Style
mixBlendMode bm = css { mixBlendMode: blendModeToStyleProperty bm }

backgroundBlendMode ∷ BlendMode → Style
backgroundBlendMode bm = css { backgroundBlendMode: blendModeToStyleProperty bm }
