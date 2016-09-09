module NN.Search.UI
( State
, Query(..)
, initialState
, ui
) where

import Halogen (Component, component, ComponentDSL, ComponentHTML, modify)
import Halogen.HTML.Indexed as H
import Halogen.HTML.Properties.Indexed as P
import NN (NN)
import NN.Filter (Filter(..), unFilter)
import NN.Prelude

type State =
  { filter :: Filter
  }

data Query a
  = SetFilter Filter a

initialState :: State
initialState = {filter: Filter ""}

ui :: Component State Query NN
ui = component {render, eval}
  where
  render :: State -> ComponentHTML Query
  render s = H.textarea [P.value (unFilter s.filter)]

  eval :: Query ~> ComponentDSL State Query NN
  eval (SetFilter filter next) = do
    modify (_ { filter = filter })
    pure next
