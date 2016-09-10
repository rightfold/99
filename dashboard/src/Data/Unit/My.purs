module Data.Unit.My
( MyUnit(..)
) where

import Prelude


data MyUnit (a :: Symbol) = MyUnit
derive instance eqMyUnit :: Eq (MyUnit a)
derive instance ordMyUnit :: Ord (MyUnit a)
