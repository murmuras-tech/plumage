module Plumage.Style.PseudoClasses
  ( active
  , checked
  , default
  , disabled
  , empty
  , enabled
  , first
  , firstChild
  , firstOfType
  , focus
  , fullscreen
  , hover
  , inRange
  , indeterminate
  , invalid
  , lastChild
  , lastOfType
  , left
  , link
  , nthOfType
  , onlyChild
  , onlyOfType
  , optional
  , outOfRange
  , readOnly
  , readWrite
  , required
  , right
  , root
  , scope
  , target
  , valid
  , visited
  ) where

import Prelude

import Foreign.Object (Object)
import Foreign.Object as Object
import React.Basic.Emotion (Style, StyleProperty, css, nested)
import Unsafe.Coerce (unsafeCoerce)

css_ :: Object StyleProperty -> Style
css_ = unsafeCoerce

active ∷ Style → Style
active style = css { "&:active": nested style }

checked ∷ Style → Style
checked style = css { "&:checked": nested style }

default ∷ Style → Style
default style = css { "&:default": nested style }

disabled ∷ Style → Style
disabled style = css { "&:disabled": nested style }

empty ∷ Style → Style
empty style = css { "&:empty": nested style }

enabled ∷ Style → Style
enabled style = css { "&:enabled": nested style }

first ∷ Style → Style
first style = css { "&:first": nested style }

firstChild ∷ Style → Style
firstChild style = css { "&:first-child": nested style }

firstOfType ∷ Style → Style
firstOfType style = css { "&:first-of-type": nested style }

fullscreen ∷ Style → Style
fullscreen style = css { "&:fullscreen": nested style }

focus ∷ Style → Style
focus style = css { "&:focus": nested style }

hover ∷ Style → Style
hover style = css { "&:hover": nested style }

indeterminate ∷ Style → Style
indeterminate style = css { "&:indeterminate": nested style }

inRange ∷ Style → Style
inRange style = css { "&:in-range": nested style }

invalid ∷ Style → Style
invalid style = css { "&:invalid": nested style }

lastChild ∷ Style → Style
lastChild style = css { "&:last-child": nested style }

lastOfType ∷ Style → Style
lastOfType style = css { "&:last-of-type": nested style }

left ∷ Style → Style
left style = css { "&:left": nested style }

link ∷ Style → Style
link style = css { "&:link": nested style }

onlyChild ∷ Style → Style
onlyChild style = css { "&:only-child": nested style }

onlyOfType ∷ Style → Style
onlyOfType style = css { "&:only-of-type": nested style }

optional ∷ Style → Style
optional style = css { "&:optional": nested style }

outOfRange ∷ Style → Style
outOfRange style = css { "&:out-of-range": nested style }

readOnly ∷ Style → Style
readOnly style = css { "&:read-only": nested style }

readWrite ∷ Style → Style
readWrite style = css { "&:read-write": nested style }

required ∷ Style → Style
required style = css { "&:required": nested style }

right ∷ Style → Style
right style = css { "&:right": nested style }

root ∷ Style → Style
root style = css { "&:root": nested style }

scope ∷ Style → Style
scope style = css { "&:scope": nested style }

target ∷ Style → Style
target style = css { "&:target": nested style }

valid ∷ Style → Style
valid style = css { "&:valid": nested style }

visited ∷ Style → Style
visited style = css { "&:visited": nested style }

nthOfType :: Int -> Style -> Style
nthOfType n style = css_
  (Object.singleton ("&:nth-of-type(" <> show n <> ")") (nested style))

-- nthChild n= ":nth-child()
-- not what = ":not()
-- ":nth-last-child()
-- ":nth-last-of-type()
-- ":lang()
-- ":dir()