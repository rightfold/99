module NN.Filter
( Filter(..), unFilter

, Host(..), unHost
, hostFilter

, Log(..), unLog
, logFilter
) where

import NN.Prelude


newtype Filter = Filter String

unFilter :: Filter -> String
unFilter (Filter s) = s


newtype Host = Host String

unHost :: Host -> String
unHost (Host s) = s

hostFilter :: Host -> Filter
hostFilter = Filter ∘ ("host=" <> _) ∘ show ∘ unHost


newtype Log = Log String

unLog :: Log -> String
unLog (Log s) = s

logFilter :: Log -> Filter
logFilter = Filter ∘ ("log=" <> _) ∘ show ∘ unLog
