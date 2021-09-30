module Main where

import Lib

main = do
    maze <- parseMaze <$> getContents
    print $ shortestRoundTrip False maze
    print $ shortestRoundTrip True maze
