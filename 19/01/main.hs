joseph :: Int -> Int 
joseph n = 1 + 2 * ( n - 2 ^ floor (l n) )
        where
                l = (logBase 2) . fromIntegral

main = do
        print $ joseph 3012210


-- https://de.wikipedia.org/wiki/Josephus-Problem