fl :: Int -> Int
fl 0 = 0
fl x = (floor . (logBase 3) . fromIntegral) x

pow3 :: Int -> Int
pow3 0 = 0
pow3 x = 3 ^ (fl x)

joseph :: Int -> Int
joseph n = diff + diff2
        where
                lower = pow3 (n - 1)
                diff = n - lower
                diff2 = if diff * 2 > n then 2 * diff - n else 0


main = do
        print $ joseph 3012210


-- https://de.wikipedia.org/wiki/Josephus-Problem