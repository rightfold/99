module NN.Filter.ListUI
( State
, Query
, initialState
, ui
) where

import Data.Array as Array
import Data.Map (Map)
import Data.Map as Map
import Data.Set (Set)
import Data.Set as Set
import Halogen (Component, component, ComponentDSL, ComponentHTML)
import Halogen.HTML.Indexed as H
import NN (NN)
import NN.Filter (Filter(..), Host, hostFilter, Log, logFilter)
import NN.Prelude


type State =
  { hosts     :: Set Host
  , logs      :: Set Log
  , bookmarks :: Map String Filter
  }

data Query a = Query Void

initialState :: State
initialState =
  { hosts:     Set.empty # Set.insert "1.2.3.4" # Set.insert "example.com"
  , logs:      Set.empty # Set.insert "nginx" # Set.insert "postgres" # Set.insert "ping"
  , bookmarks: Map.empty # Map.insert "foo" (Filter "bar")
  }

ui :: Component State Query NN
ui = component {render, eval}
  where
  render :: State -> ComponentHTML Query
  render s =
    H.ul_
      [ groupLi "Hosts"     (fromSet s.hosts hostFilter)
      , groupLi "Logs"      (fromSet s.logs  logFilter)
      , groupLi "Bookmarks" (s.bookmarks # Map.toList # Array.fromFoldable)
      ]
    where
    fromSet set mkFilter = set # Array.fromFoldable # map \a -> a `Tuple` mkFilter a
    groupLi title filters = H.li_ [H.text title, H.ul_ (map filterLi filters)]
    filterLi (Tuple name _) = H.li_ [H.text name]

  eval :: Query ~> ComponentDSL State Query NN
  eval (Query v) = absurd v
