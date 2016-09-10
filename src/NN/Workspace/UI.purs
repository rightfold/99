module NN.Workspace.UI
( PState
, PQuery(..)
, CState
, CQuery
, State
, Query
, Slot
, initialState
, ui
) where

import Halogen (action, ChildF(..), Component, parentComponent, ParentDSL, ParentHTML, ParentState, parentState, query')
import Halogen.Component.ChildPath (cpL, cpR)
import Halogen.HTML.Indexed as H
import Halogen.HTML.Properties.Indexed as P
import NN (NN)
import NN.Bookmark.ListUI as Bookmark.ListUI
import NN.Prelude
import NN.Search.UI as Search.UI


type PState = Unit
data PQuery a = Query Void

type CState = Bookmark.ListUI.State + Search.UI.State
type CQuery = Bookmark.ListUI.Query ⊕ Search.UI.Query

type State = ParentState PState CState PQuery CQuery NN Slot
type Query = PQuery ⊕ ChildF Slot CQuery

type Slot = Unit + Unit -- MyUnit "BookmarkList" + MyUnit "Search"

initialState :: State
initialState = parentState unit

ui :: Component State Query NN
ui = parentComponent {render, eval, peek: Just peek}
  where
  render :: PState -> ParentHTML CState PQuery CQuery NN Slot
  render _ =
    H.div [P.class_ (H.className "nn--workspace")]
      [ H.slot' cpL unit \_ -> {component: Bookmark.ListUI.ui, initialState: Bookmark.ListUI.initialState}
      , H.slot' cpR unit \_ -> {component: Search.UI.ui,       initialState: Search.UI.initialState}
      ]

  eval :: PQuery ~> ParentDSL PState CState PQuery CQuery NN Slot
  eval (Query v) = absurd v

  peek :: forall a. ChildF Slot CQuery a -> ParentDSL PState CState PQuery CQuery NN Slot Unit
  peek (ChildF _ q) = case unCoproduct q of
    Left (Bookmark.ListUI.SelectFilter filter _) -> do
      query' cpR unit $ action $ Search.UI.SetFilter filter
      query' cpR unit $ action $ Search.UI.Search
      pure unit
    _ -> pure unit
