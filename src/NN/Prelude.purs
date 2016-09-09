module NN.Prelude
( module Control.Monad.Aff
, module Control.Monad.Eff
, module Control.Monad.Free
, module Data.Either
, module Data.Functor.Coproduct
, module Data.Maybe
, module Data.Tuple
, module Data.Unit.My
, module Debug.Trace
, module Prelude
, type (+)
, type (⊕)
, (∘)
) where

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Control.Monad.Free (Free, foldFree, liftF)
import Data.Either (Either(..), either)
import Data.Functor.Coproduct (Coproduct, coproduct, unCoproduct)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Tuple (curry, fst, snd, Tuple(..), uncurry)
import Data.Unit.My (MyUnit(..))
import Debug.Trace (trace, traceA, traceAny, traceAnyA, traceAnyM, traceShow, traceShowA, traceShowM)
import Prelude

infixl 6 type Either as +

infixl 6 type Coproduct as ⊕

infixr 9 compose as ∘
