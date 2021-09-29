module Main where

main = print $ cs output

limit = 35651584

input = "10111100110001111"

output = take limit $ head $ dropWhile ((<limit) . length) $ iterate f input where
    f s = s ++ "0" ++ (rev s)
    rev = reverse . map (\c -> if c == '1' then '0' else '1')

cs s = let s' = reduce s in if even (length s') then cs s' else s' where
    reduce [] = []
    reduce (a:b:xs) = (if a == b then '1' else '0') : reduce xs
