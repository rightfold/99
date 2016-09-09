module NN.Workspace.UI
( State
, Query
, State'
, Query'
, Slot
, initialState
, ui
) where

import Halogen (ChildF, Component, parentComponent, ParentDSL, ParentHTML, ParentState, parentState)
import Halogen.HTML.Indexed as H
import NN (NN)
import NN.Filter.ListUI as Filter.ListUI
import NN.Prelude


type State = Unit

data Query a = Query Void

type State' = ParentState State Filter.ListUI.State Query Filter.ListUI.Query NN Slot

type Query' = Query ⊕ ChildF Slot Filter.ListUI.Query

type Slot = Unit

initialState :: State'
initialState = parentState unit

ui :: Component State' Query' NN
ui = parentComponent {render, eval, peek: Nothing}
  where
  render :: State -> ParentHTML Filter.ListUI.State Query Filter.ListUI.Query NN Slot
  render _ =
    H.div []
      [ H.slot unit \_ -> {component: Filter.ListUI.ui, initialState: Filter.ListUI.initialState}
      , H.h1 [] [H.text "hi"]
      ]

  eval :: Query ~> ParentDSL State Filter.ListUI.State Query Filter.ListUI.Query NN Slot
  eval (Query v) = absurd v
