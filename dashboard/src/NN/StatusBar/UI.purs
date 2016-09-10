module NN.StatusBar.UI
( State
, Query(..)
, initialState
, ui
) where

import Halogen (Component, component, ComponentDSL, ComponentHTML)
import Halogen.HTML.Indexed as H
import Halogen.HTML.Properties.Indexed as P
import NN (NN)
import NN.Prelude


type State = Unit

data Query a = Query Void

initialState :: State
initialState = unit

ui :: Component State Query NN
ui = component {render, eval}
  where
  render :: State -> ComponentHTML Query
  render s =
    H.div [P.class_ (H.className "nn--status-bar")]
      [ H.span [P.class_ (H.className "-events-per-second")] [H.text "5.1 e/s"]
      , H.span [P.class_ (H.className "-info-rate")]     [H.text "73%"]
      , H.span [P.class_ (H.className "-notice-rate")]   [H.text "21%"]
      , H.span [P.class_ (H.className "-warning-rate")]  [H.text "1%"]
      , H.span [P.class_ (H.className "-error-rate")]    [H.text "5%"]
      , H.span [P.class_ (H.className "-critical-rate")] [H.text "0%"]
      , H.span [P.class_ (H.className "-alert-rate")]    [H.text "0%"]
      , H.span [P.class_ (H.className "-overall-emergency")] [H.text "EMERGENCY"]
      ]

  eval :: Query ~> ComponentDSL State Query NN
  eval (Query v) = absurd v
