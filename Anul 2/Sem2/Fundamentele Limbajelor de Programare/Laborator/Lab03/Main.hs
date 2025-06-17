import System.Environment (getArgs, getProgName)
import System.Exit (exitSuccess)

import Parser (hoare, parseFirst, bexpr)
import Syntax (HoareTriple, BExpr)
import WeakPre (verificationCondition)
import ToSmt (bexprToSmt)
import System.Process (createProcess, proc, std_out, StdStream(CreatePipe))
import System.IO (hGetContents)

usage :: IO ()
usage   = getProgName >>= \main -> putStr $ unlines [
  "Usage: " ++ main ++ " [-vh] file [vc | smt | check]"
  , "  -h  Display this help message"
  , "  -v  Display version information"
  , "  file  The file containing the Hoare Triple to be verified"
  , "        If no file is provided, the program reads from standard input"
  , "        The file should contain a Hoare Triple in the form {P} S {Q}"
  , "        where P, S, and Q are the pre-condition, statement, and post-condition"
  , "        respectively"
  , "        P and Q are boolean expressions, and S is a statement"
  , "        The while statement should have an invariant specified, for example"
  , "        while B do S invariant I"
  , "  vc  Print the verification condition"
  , "  smt  Print the verification condition in SMT-LIB format"
  , "  check  Check the verification condition using Z3"
  ]

version :: IO ()
version = putStrLn "Version 0.1"

retrieveHoareTriple :: String -> HoareTriple
retrieveHoareTriple str = case parseFirst hoare str of
    Left err -> error ("Error while parsing program" ++ err)
    Right triple -> triple

main :: IO ()
main = do
  cmd <- getArgs
  args <- parseArgs cmd
  case interpreter args of
    Check -> do
        let triple = retrieveHoareTriple (pgmStr args)
        let vc = verificationCondition triple
        putStrLn $ "Verification condition:\n  " ++ show vc
        let smt = bexprToSmt vc
        runZ3 smt
    _ -> print (execute (retrieveHoareTriple (pgmStr args)) (interpreter args))

runZ3 :: String -> IO ()
runZ3 smt = do
    writeFile "temp.smt" smt
    putStrLn "Running Z3..."
    (_, Just hout, _, _) <- createProcess (proc "z3" ["-model", "temp.smt"]) { std_out = CreatePipe }
    output <- hGetContents hout
    putStr output

data Result = SMT String | VC BExpr

instance Show Result where
  show (SMT s) = s
  show (VC b) = show b

execute :: HoareTriple -> InterpreterType -> Result
execute triple = \t -> case t of
    VerificationCondition -> VC $ vc
    SmtLib -> SMT $ bexprToSmt $ vc
  where
    vc = verificationCondition triple


data InterpreterType = VerificationCondition | SmtLib | Check

data Args = Args { pgmStr :: String, interpreter :: InterpreterType }

parseInterpreter :: String -> InterpreterType
parseInterpreter "vc" = VerificationCondition
parseInterpreter "smt" = SmtLib
parseInterpreter "check" = Check
parseInterpreter _ = error "Invalid interpreter type"

parseArgs :: [String] -> IO Args
parseArgs ["-h"] = usage   >> exit
parseArgs ["-v"] = version >> exit
parseArgs []     = getContents >>= \pgmStr -> return (Args pgmStr VerificationCondition)
parseArgs [fileName]                = readFile fileName >>= \pgmStr -> return (Args pgmStr VerificationCondition)
parseArgs [fileName, interpreter]   = readFile fileName >>= \pgmStr -> return (Args pgmStr (parseInterpreter interpreter))

exit :: IO a
exit    = exitSuccess
