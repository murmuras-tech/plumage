--| Tailwind.css inspired helper functions for speeding up styling elements
module Plumage.Style
  ( module Plumage.Style.BlendMode
  , module Plumage.Style.BlendMode.Types
  , module Plumage.Style.Border
  , module Plumage.Style.BoxModel
  , module Plumage.Style.BoxShadow
  , module Plumage.Style.Breakpoint
  , module Plumage.Style.Color.Background
  , module Plumage.Style.Color.Tailwind
  , module Plumage.Style.Color.Text
  , module Plumage.Style.Color.Util
  , module Plumage.Style.Cursor
  , module Plumage.Style.Display
  , module Plumage.Style.Display.Flex
  , module Plumage.Style.Display.Grid
  , module Plumage.Style.Divide
  , module Plumage.Style.Global
  , module Plumage.Style.Input
  , module Plumage.Style.Inset
  , module Plumage.Style.Isolation
  , module Plumage.Style.Nesting
  , module Plumage.Style.Opacity
  , module Plumage.Style.Overflow
  , module Plumage.Style.PointerEvents
  , module Plumage.Style.Position
  , module Plumage.Style.PseudoClasses
  , module Plumage.Style.PseudoElements
  , module Plumage.Style.Size
  , module Plumage.Style.Text
  , module Plumage.Style.Transform
  , module Plumage.Style.Transition
  , module Plumage.Style.UserSelect
  , module Plumage.Style.Visibility
  ) where

import Plumage.Style.BlendMode (backgroundBlendMode, mixBlendMode)
import Plumage.Style.BlendMode.Types (BlendMode(..), blendModeToStyleProperty)
import Plumage.Style.Border (border, borderBottom, borderCol, borderCol', borderLeft, borderNone, borderRight, borderSolid, borderTop, boxSizingBorderBox, boxSizingContentBox, rounded, rounded2xl, rounded3xl, roundedDefault, roundedFull, roundedLg, roundedMd, roundedNone, roundedSm, roundedXl)
import Plumage.Style.BoxModel (m', mB, mB', mL, mL', mR, mR', mT, mT', mX, mX', mXAuto, mXY, mY, mY', p', pB, pB', pL, pL', pR, pR', pT, pT', pX, pX', pXY, pY, pY')
import Plumage.Style.BoxShadow (mkShadow, shadow, shadow', shadowDefault, shadowDefaultCol, shadowLg, shadowLgCol, shadowMd, shadowMdCol, shadowSm, shadowSmCol, shadowXl, shadowXlCol, shadowXxl, shadowXxlCol, shadows)
import Plumage.Style.Breakpoint (screen2xl, screenLg, screenMd, screenSm, screenXl)
import Plumage.Style.Color.Background (background, background', backgroundImage, backgroundImage', backgroundNoRepeat, backgroundPosition, backgroundRepeat, backgroundRepeatX, backgroundRepeatY, backgroundSize, backgroundSize', blurredBackground, blurredBackground', linearGradient, linearGradientStops, linearGradientStopsString, linearGradientString, svgBackgroundImage)
import Plumage.Style.Color.Tailwind (TailwindColor, amber, black, blue, blueGray, coolGray, cyan, emerald, fuchsia, gray, green, indigo, lightBlue, lime, orange, pink, purple, red, rose, teal, trueGray, violet, warmGray, white, yellow)
import Plumage.Style.Color.Text (textCenter, textCol, textCol', textJustify, textLeft, textRight)
import Plumage.Style.Color.Util (hue, lightness, saturation, withAlpha, withHue, withLightness, withSaturation)
import Plumage.Style.Cursor (cursorAuto, cursorDefault, cursorHelp, cursorMove, cursorNotAllowed, cursorPointer, cursorText, cursorWait)
import Plumage.Style.Display (block, displayNone, flex, inlineBlock, inlineFlex, inlineGrid)
import Plumage.Style.Display.Flex (alignSelfCenter, alignSelfEnd, alignSelfStart, flexCol, flexGrow, flexNoWrap, flexRow, flexShrink, flexWrap, flexWrapReverse, gap, itemsAround, itemsBetween, itemsCenter, itemsEnd, itemsEvenly, itemsStart, justifyAround, justifyBetween, justifyCenter, justifyEnd, justifyEvenly, justifySelfCenter, justifySelfEnd, justifySelfStart, justifyStart)
import Plumage.Style.Display.Grid (displayGrid, templateCols, templateRows)
import Plumage.Style.Divide (divideCol, divideX, divideXReverse, divideY, divideYReverse)
import Plumage.Style.Global (globalStyles, nest, variables)
import Plumage.Style.Input (outlineNone, placeholder)
import Plumage.Style.Inset (bottom, bottom', left, left', right, right', top, top')
import Plumage.Style.Isolation (isolate, isolationAuto)
import Plumage.Style.Nesting (attributeValueStyle)
import Plumage.Style.Opacity (opacity)
import Plumage.Style.Overflow (overflowHidden, overflowScroll, overflowVisible, overflowXHidden, overflowXScroll, overflowYHidden, overflowYScroll, textOverflowEllipsis)
import Plumage.Style.PointerEvents (acceptClicks, ignoreClicks, pointerEventsAuto, pointerEventsNone)
import Plumage.Style.Position (positionAbsolute, positionFixed, positionRelative, positionStatic, positionSticky)
import Plumage.Style.PseudoClasses (active, checked, default, disabled, empty, enabled, evenChild, first, firstChild, firstOfType, focus, focusWithin, fullscreen, hover, inRange, indeterminate, invalid, lastChild, lastOfType, link, nthChild, nthOfType, oddChild, onlyChild, onlyOfType, optional, outOfRange, pseudoLeft, pseudoRight, readOnly, readWrite, required, root, scope, target, valid, visited)
import Plumage.Style.PseudoElements (afterElement, beforeElement, content, firstLetter, firstLine, selection)
import Plumage.Style.Size (full, height, height', heightFull, heightScreen, maxHeight, maxHeight', maxWidth, maxWidth', minHeight, minHeight', minWidth, minWidth', screenHeight, screenWidth, width, width', widthAndHeight, widthAndHeight', widthFull, widthScreen)
import Plumage.Style.Text (fontBlack, fontBold, fontExtrabold, fontExtralight, fontFamilyOrMono, fontFamilyOrSans, fontFamilyOrSerif, fontLight, fontMedium, fontNormal, fontSemiMedium, fontSemibold, fontSize, fontSize', fontThin, lineHeight, lineHeight', text2xl, text3xl, text4xl, text5xl, text6xl, text7xl, text8xl, text9xl, textBase, textDefault, textLg, textSized, textSm, textTransformUppercase, textXl, textXs, tracking, trackingNormal, trackingTight, trackingTighter, trackingWide, trackingWider, trackingWidest, underline)
import Plumage.Style.Transform (mkRotate, mkTranslate, rotate, transform, transform', transformMany, translate)
import Plumage.Style.Transition (transition, transition', transitionRec)
import Plumage.Style.UserSelect (userSelectNone, userSelectText)
import Plumage.Style.Visibility (invisible, visible)
