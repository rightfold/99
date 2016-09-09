module NN.Workspace.UI
( State
, Query(..)
, State'
, Query'
, Slot
, initialState
, ui
) where

import Halogen (ChildF(..), Component, parentComponent, ParentDSL, ParentHTML, ParentState, parentState)
import Halogen.HTML.Indexed as H
import NN (NN)
import NN.Bookmark.ListUI as Bookmark.ListUI
import NN.Prelude


type State = Unit

data Query a = Query Void

type State' = ParentState State Bookmark.ListUI.State Query Bookmark.ListUI.Query NN Slot

type Query' = Query ⊕ ChildF Slot Bookmark.ListUI.Query

type Slot = Unit

initialState :: State'
initialState = parentState unit

ui :: Component State' Query' NN
ui = parentComponent {render, eval, peek: Just peek}
  where
  render :: State -> ParentHTML Bookmark.ListUI.State Query Bookmark.ListUI.Query NN Slot
  render _ =
    H.div []
      [ H.slot unit \_ -> {component: Bookmark.ListUI.ui, initialState: Bookmark.ListUI.initialState}
      , H.h1 [] [H.text "hi"]
      ]

  eval :: Query ~> ParentDSL State Bookmark.ListUI.State Query Bookmark.ListUI.Query NN Slot
  eval (Query v) = absurd v

  peek :: forall a. ChildF Slot Bookmark.ListUI.Query a -> ParentDSL State Bookmark.ListUI.State Query Bookmark.ListUI.Query NN Slot Unit
  peek (ChildF _ q) = case q of
    Bookmark.ListUI.SelectFilter filter _ -> do
      traceAnyA filter
      pure unit
