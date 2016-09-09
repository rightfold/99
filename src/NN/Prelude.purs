module NN.Prelude
( module Control.Monad.Aff
, module Control.Monad.Eff
, module Control.Monad.Free
, module Data.Functor.Coproduct
, module Data.Maybe
, module Debug.Trace
, module Prelude
, type (⊕)
) where

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Control.Monad.Free (Free, foldFree, liftF)
import Data.Functor.Coproduct (Coproduct, coproduct, unCoproduct)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Debug.Trace (trace, traceA, traceAny, traceAnyA, traceAnyM, traceShow, traceShowA, traceShowM)
import Prelude

infixl 6 type Coproduct as ⊕
