module NN.Filter.ListUI
( State
, Query
, initialState
, ui
) where

import Halogen (Component, component, ComponentDSL, ComponentHTML)
import Halogen.HTML.Indexed as H
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
  render _ = H.h1 [] [H.text "list"]

  eval :: Query ~> ComponentDSL State Query NN
  eval (Query v) = absurd v
