-- Conjunction introduction
--      A
--      B
-- ------------
--    A /\ B

conjIntro :: a -> b -> (a, b)
conjIntro hp hq = (hp, hq)

-- Conjunction elimination (left):
--    A /\ B
-- -----------------
--      A

conjElimL :: (a, b) -> a
conjElimL h_p_and_q = fst h_p_and_q


-- Conjunction elimination (right):
--    A /\ B
-- -----------------
--      B

conjElimR :: (a, b) -> b
conjElimR h_p_and_q = snd h_p_and_q

-- Disjunction introduction (left):
--      A
-- ----------------
--    A \/ B

disjIntroL :: a -> Either a b
disjIntroL hp = Left hp

-- Disjunction introduction (right):
--      A
-- ----------------
--    B \/ A

disjIntroR :: a -> Either b a
disjIntroR hp = Right hp

-- Disjunction elimination:
--      A \/ B
--      A -> C
--      B -> C
-- ----------------------
--        C

disjElim :: Either a b -> (a -> c) -> (b -> c) -> c
disjElim (Left hp)  impl_l _ = impl_l hp
disjElim (Right hq) _ impl_r = impl_r hq
-- vezi si: functia `either` din biblioteca standard (Hoogle)

-- Implication introduction:
--   If assuming          A
--                       ---
--   It follows that      B
--
--    -------------
--    Then: A -> B
--
-- Introducerea implicatiei e o operatie de baza in
-- lambda-calcul (si implicit si Haskell).
-- O demonstratie pentru  (a -> b) este pur si simplu
--   o lambda-expresie   (\x -> y),
--   unde x are tipul a, si y are tipul b.
--
-- Numele operatiei asteia foarte simple este
-- "function abstraction".


-- Implication elimination (modus ponens)
--      A -> B
--        A
--  ---------------
--        B
--
-- Operatie implicita: "function application", aplicare de functie.
-- Daca ar fi sa o rescriem:
implElim :: (a -> b) -> a -> b
implElim h_p_imp_q p = h_p_imp_q p


-- Adevarul logic (⊤) coresponde tipului Unit (tipul cu un singur element): ()
-- Falsul logic (⊥) ar trebui sa corespunda unui tip fara niciun element
-- (nu exista demonstratii pentru fals).
-- Putem defini un tip fara niciun constructor:
data Void
--
-- (Tehnic vorbind, atat Unit cat si Void vor contine amandoua si elementul undefined,
-- dar ne prefacem ca undefined nu exista deocamdata.)

-- Prin definitie, negatia logica ¬a este echivalenta cu (a -> ⊥).
-- Deci tipul care va corespunde propozitiei ¬a este (a -> Void).

-- Sa demonstram:
--   p -> (q -> p)
th1 :: a -> (b -> a)
th1 = \hp hq -> hp

-- (p -> (q -> r)) -> ((p -> q) -> (p -> r))
th2 :: (a -> (b -> c)) -> ((a -> b) -> (a -> c))
th2 = \hyp1 hyp2 hp -> (hyp1 hp) (hyp2 hp)

-- ⊥ -> a
thAbsurd :: Void -> a
thAbsurd falsum = undefined

-- (¬b -> ¬a) -> (a -> b)
th3 :: ((b -> Void) -> (a -> Void)) -> (a -> b)
th3 = undefined -- reusim sa scriem functia asta?
