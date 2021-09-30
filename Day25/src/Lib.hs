module Lib where

import qualified Data.Map as M
import Data.Maybe (listToMaybe)
import Debug.Trace

data Arg = RegArg Char | NumArg Integer deriving (Eq, Ord, Show)

data Command = Inc Arg
             | Dec Arg
             | Cpy Arg Arg
             | Jnz Arg Arg
             | Out Arg
             | Dbg
             deriving (Eq, Ord, Show)

parseCommand :: String -> Command
parseCommand s = case words s of
                    ["inc", arg] -> Inc (parseArg arg)
                    ["dec", arg] -> Dec (parseArg arg)
                    ["cpy", arg1, arg2] -> Cpy (parseArg arg1) (parseArg arg2)
                    ["jnz", arg1, arg2] -> Jnz (parseArg arg1) (parseArg arg2)
                    ["out", arg] -> Out (parseArg arg)
                    ["dbg"] -> Dbg
                    _ -> error $ "Bad command: " <> s

parseArg :: String -> Arg
parseArg s = maybe (RegArg $ head s) (NumArg . fst) (listToMaybe $ reads s)

type Registers = M.Map Char Integer

mkRegister a = M.fromList (('a',a) : [(char,0) | char <- "bcd"])

runLazy :: [Command] -> Registers -> [Integer]
runLazy cs r = go 0 r where
    go ip r =
        let (ip', r', acc) = apply (cs !! ip) ip r []
        in if null acc
            then go ip' r'
            else head acc : go ip' r'

matchesSignal n = (==(take n $ cycle [0,1])) . take n


--debug :: [Command] -> Registers -> [Int] -> IO [Integer]
--debug cs r bks = go 0 r 0 [] where
    --go ip r n acc = let (ip', r', acc') = apply (cs !! ip) ip r acc
                        --rec = go ip' r' (n+1) acc'
                        --dbgInfo =
                            --"step: " <> show n <> "\t" <>
                            --"instr: " <> show ip <> "\t" <>
                            --"reg: " <> show r <> "\t" <>
                            --"acc: " <> show (reverse acc)
                    --in if ip `elem` bks
                          --then putStr dbgInfo >> getLine >> rec
                          --else rec

apply :: Command -> Int -> Registers -> [Integer] -> (Int, Registers, [Integer])
apply (Inc (RegArg a))            ip r acc = (ip + 1, M.adjust succ a r, acc)
apply (Dec (RegArg a))            ip r acc = (ip + 1, M.adjust pred a r, acc)
apply (Cpy (RegArg a) (RegArg b)) ip r acc = (ip + 1, M.insert b (r M.! a) r, acc)
apply (Cpy (NumArg a) (RegArg b)) ip r acc = (ip + 1, M.insert b a r, acc)
apply (Jnz (RegArg a) (NumArg b)) ip r acc = let offset = if 0 /= r M.! a then b else 1
                                             in (ip + fromIntegral offset, r, acc)
apply (Jnz (NumArg a) (NumArg b)) ip r acc = let offset = if 0 /= a then b else 1
                                             in (ip + fromIntegral offset, r, acc)
apply (Out (RegArg a))            ip r acc = (ip + 1, r, (r M.! a):acc)
apply Dbg                         ip r acc = traceShow (M.toList r) (ip + 1, r, acc)
apply _                           ip r acc = (ip + 1, r, acc)
