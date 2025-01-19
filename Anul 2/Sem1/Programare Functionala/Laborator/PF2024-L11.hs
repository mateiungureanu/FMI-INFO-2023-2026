{-
class Functor f where
fmap : : ( a -> b ) -> f a -> f b
-}
newtype Identity a = Identity a

instance Functor Identity where
    fmap f (Identity x) = Identity $ f x

data Pair a = Pair a a

instance Functor Pair where
    fmap f (Pair x y) = Pair (f x) (f y)

data Constant a b = Constant b

instance Functor (Constant a) where
    --fmap :: (a -> b) -> Constant t a -> Constant t b
    fmap f (Constant x) = Constant(f x)

data Two a b = Two a b

instance Functor (Two a) where
    --fmap :: (a -> b) -> Two t a -> Two t b
    fmap f (Two x y) = Two x (f y)

data Three a b c = Three a b c

data Three' a b = Three' a b b


data Four a b c d = Four a b c d

data Four'' a b = Four'' a a a b

data Quant a b = Finance | Desk a | Bloor b


data LiftItOut f a = LiftItOut (f a)

data Parappa f g a = DaWrappa (f a) (g a)

data IgnoreOne f g a b = IgnoringSomething (f a) (g b)

data Notorious g o a t = Notorious (g o) (g a) (g t)

data GoatLord a = NoGoat | OneGoat a | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)

data TalkToMe a = Halt | Print String a | Read (String -> a)
