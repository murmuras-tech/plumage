module Plumage.Style.PseudoElements where

import Prelude

import React.Basic.Emotion (Style, css, nested, str)

beforeElement ∷ Style → Style
beforeElement style = css { "&::before": nested style, content: str "''" }

afterElement ∷ Style → Style
afterElement style = css { "&::after": nested style, content: str "''" }

content ∷ String → Style
content c = css { content: str $ "'" <> c <> "'" }

firstLetter ∷ Style → Style
firstLetter style = css { "&::first-letter": nested style }

firstLine style = css { "&::first-line": nested style }

selection style = css { "&::selection": nested style }