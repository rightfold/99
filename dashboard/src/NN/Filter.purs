module NN.Filter
( Filter(..)
, unFilter

, Host
, hostFilter

, Log
, logFilter
) where

import NN.Prelude


newtype Filter = Filter String

unFilter :: Filter -> String
unFilter (Filter s) = s


type Host = String

hostFilter :: Host -> Filter
hostFilter = Filter ∘ ("host=" <> _) ∘ show


type Log = String

logFilter :: Log -> Filter
logFilter = Filter ∘ ("log=" <> _) ∘ show
