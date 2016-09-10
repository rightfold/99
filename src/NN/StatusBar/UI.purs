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
      [H.text "5.1 e/s"]

  eval :: Query ~> ComponentDSL State Query NN
  eval (Query v) = absurd v
