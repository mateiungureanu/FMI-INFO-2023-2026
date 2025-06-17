import Data.Char

-- a parser is a wrapper for a function that takes a string, a list of all the possibilities (as the grammar may be ambiguous) of: (i) the interpretation of the parsed portion and (ii) the remainder of the string
newtype Parser a = Parser { parse :: String -> [(a,String)] }

-- Parser :: String -> [(a, String)] -> Parser a
-- parse :: Parser a -> String -> [(a, String)]

-- parses exactly one character
item :: Parser Char
item = Parser (\cs -> case cs of
                "" -> []
                (c:cs) -> [(c,cs)])

-- parse item "si un string"
-- [('s',"i un string")]

instance Monad Parser where
    return a = Parser (\cs -> [(a,cs)])
    p >>= f = Parser (\cs -> concat (map (\(a, cs') -> (parse (f a) cs')) (parse p cs)))

-- the two instances below are standard, they describe the way *any* instance of Monad may be considered an instance of Applicative and of Functor
instance Applicative Parser where
    pure = return
    mf <*> ma = do
        f <- mf
        va <- ma
        return (f va)    

instance Functor Parser where              
    fmap f ma = pure f <*> ma   

-- the following is the alternative "bottom-up" way of instantiation
{-
instance Functor Parser where              
    fmap g p = Parser (\cs -> map (\(a,cs') -> (g a, cs')) (parse p cs))

instance Applicative Parser where
    pure a = Parser (\cs -> [(a, cs)])
    pg <*> pa = Parser (\cs -> concat (map (\(g, cs') -> (parse (fmap g pa) cs')) (parse pg cs)))

instance Monad Parser where
    p >>= f = Parser (\cs -> concat (map (\(a, cs') -> (parse (f a) cs')) (parse p cs)))
-}

-- this parser always fails
zero :: Parser a
zero = Parser (const [])

-- parser for characters which satisfy a predicate
sat :: (Char -> Bool) -> Parser Char
sat p = do
            c <- item
            if p c then return c else zero

-- parse (sat (=='d')) "dal"
-- [('d',"al")]

char :: Char -> Parser Char
char c = sat (c ==)

string :: String -> Parser String
string "" = return ""
string (c:cs) = do
                    pc <- char c
                    prest <- string cs
                    return (pc : prest)

-- parse (string "cdef") "abac"
-- []
-- parse (string "aba") "abac"
-- [("aba","c")]

-- parser combinators:
-- sum of parsers
psum :: Parser a -> Parser a -> Parser a
psum p q = Parser (\cs -> (parse p cs) ++ (parse q cs))

-- parse (psum (string "cdef") (string "aba")) "abac"
-- [("aba","c")]
-- parse (psum (string "ab") (string "aba")) "abac"
-- [("ab","ac"),("aba","c")]

-- "disjunction" of parsers: returns the first possibility of the sum
-- Alternative
(<|>) :: Parser a -> Parser a -> Parser a
p <|> q = Parser (\cs -> case parse (psum p q) cs of
                                [] -> []
                                (x:xs) -> [x])
-- fals numai daca nici A nici B nu sunt adevarate

-- parse ((string "cdef") <|> (string "aba")) "abac"
-- [("aba","c")]

-- parsers which return lists
-- disjunction with the empty list
dpsum0 :: Parser [a] -> Parser [a]
dpsum0 p = p <|> (return [])

-- parse (return []) "test"

-- aplica parserul p de 0 sau mai multe ori
-- parserul rezultat o sa intoarca lista rezultatelor aplicarilor lui p
many0 :: Parser a -> Parser [a]
many0 p = dpsum0 (many1 p)

-- parse (many0 (char 'E')) "EEEEEd"
-- parse (many0 (char 'E')) "qEEEEEEd"

-- aplica parserul p de 1 sau mai multe ori
-- parserul rezultat o sa intoarca lista rezultatelor aplicarilor lui p
many1 :: Parser a -> Parser [a]
many1 p = do 
    a <- p
    aa <- many0 p
    return (a : aa)

spaces :: Parser String
spaces = many0 (sat isSpace)

-- parse spaces "                  test      "
-- parse spaces "  \n\t\r    " 

token :: Parser a -> Parser a
token p = do
            spaces     -- leading spaces
            x <- p
            spaces     -- trailing spaces
            -- echivalent cu _ -> spaces ; nu ne intereseaza rezultatul
            return x

-- parse (token (string "+")) "    \n \t   +    "
-- [("+","")]

symbol :: String -> Parser String
symbol symb = token (string symb)

-- parse (symbol "+") "   \n \t   +    "

sepBy0 :: Parser a1 -> Parser a2 -> Parser [a1]
p `sepBy0` sep = dpsum0 (p `sepBy1` sep)

-- parse (sepBy0 (symbol "+") (symbol (","))) "+,+,+"
-- [(["+","+","+"],"")]
-- parse (sepBy0 (symbol "+") (symbol (","))) "abac"
-- [([],"abac")]

sepBy1 :: Parser a1 -> Parser a2 -> Parser [a1]
p `sepBy1` sep = do
                    a <- p
                    as <- many0 (do
                                    sep
                                    p)
                    return (a:as)

look :: Parser (Maybe Char)
look = Parser (\cs -> case cs of
      [] -> [(Nothing, [])]
      (c:cs') -> [(Just c, c:cs')]
    )

-- parseaza caractere din string pana cand urmatorul caracter neparsat este stop
takeUntil :: Char -> Parser [Char]
takeUntil stop = consumeRest "" stop
    where consumeRest acc stop = do
                                    l <- look
                                    if l == Just stop then return [] else do
                                                                            c <- item
                                                                            cs <- consumeRest (acc ++ [c]) stop
                                                                            return (c:cs)

chainl1 :: Parser t -> Parser (t -> t -> t) -> Parser t
p `chainl1` op = do
                    x <- p
                    rest x
                 where rest x = (do
                                    f <- op
                                    y <- p
                                    rest (f x y)
                                ) <|> return x

digit :: Parser Int
digit = do
            d <- sat isDigit
            return (digitToInt d)

integer :: Parser Int
integer = do
              spaces
              d <- digitToInt <$> sat isDigit
              if d == 0 
                then 
                  return 0 
                else 
                  do
                    ds <- many0 digit
                    return (asInt (d:ds))
          where asInt ds = sum [d * (10^p) | (d, p) <- zip (reverse ds) [0..] ]

number :: Parser Double
number = withDecimalPt <|> withoutDecimalPt
  where
    withoutDecimalPt = fromIntegral <$> integer
    withDecimalPt = do
                      wholePart <- withoutDecimalPt
                      char '.'
                      fractionalPart <- fmap asFracPt (many0 digit)
                      return (wholePart + fractionalPart)
    asFracPt ds = sum [fromIntegral d * (10 ** (-p)) | (d, p) <- zip ds [1..]]

addop :: Parser (Double -> Double -> Double)
addop = add <|> sub
  where add = do
                symbol "+"
                return (+)
        sub = do
                symbol "-"
                return (-)

mulop :: Parser (Double -> Double -> Double)
mulop = mul <|> div
  where mul = do
                symbol "*"
                return (*)
        div = do
                symbol "/"
                return (/)

factor :: Parser Double
factor = negativeFactor <|> parensExpr <|> number
  where
    negativeFactor = do
                        symbol "-"
                        negate <$> factor
    parensExpr = do
                    symbol "("
                    x <- expr
                    symbol ")"
                    return x
                    
term :: Parser Double
term = factor `chainl1` mulop

expr :: Parser Double
expr = term `chainl1` addop

-- vom vrea sa parsam "+" in functia + :: Int -> Int -> Int
-- parse expr "1 + 2 + 3 + 4 + 5"
--      -> parse expr "(((1 + 2) + 3) + 4) + 5"
-- [(15.0,"")]

--1. Testati parser-ul de mai sus

data Expr = ENum Double | EPlu Expr Expr | EMinu Expr Expr | EMul Expr Expr | EDiv Expr Expr | EminuU Expr
    deriving Show

--2. Modificati parser-ul astfel incat el sa returneze expresie de tipul de mai sus Expr (tip de date abstract, inductiv, pentru expresii aritmetice)

enum :: Parser Expr
enum = ENum <$> number

eaddop :: Parser (Expr -> Expr -> Expr)
eaddop = undefined

emulop :: Parser (Expr -> Expr -> Expr)
emulop = undefined

efactor :: Parser Expr
efactor = undefined

eterm :: Parser Expr
eterm = undefined

eexpr :: Parser Expr
eexpr = undefined