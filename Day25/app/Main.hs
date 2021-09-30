module Main where

import Lib
import Data.List (find)

main :: IO ()
main = do
    cmds <- fmap parseCommand . lines <$> getContents
    let options = [ (n, runLazy cmds (mkRegister n)) | n <- [0..] ]
    print $ fst <$> find (matchesSignal 20 . snd) options

