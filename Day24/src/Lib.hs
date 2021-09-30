module Lib where

import qualified Data.Sequence as Seq
import qualified Data.Map as M
import qualified Data.Set as S
import           Data.List (find, permutations)
import           Data.Foldable ( fold, minimumBy )
import           Data.Maybe (mapMaybe, fromMaybe)
import           Data.Ord (comparing)
import           Data.Sequence (Seq((:<|)), (><))

type Pos = (Int,Int)

data Cell = Wall | Empty | Target Int deriving (Show, Eq)

type Maze = M.Map Pos Cell

parseMaze :: String -> Maze
parseMaze = M.fromList . fmap toCell . toCoords where
    toCell (coords,'#') = (coords, Wall)
    toCell (coords,'.') = (coords, Empty)
    toCell (coords,c) = (coords, Target (read [c]))
    toCoords s = [ ((row,col), char) | (row, s') <- zip [0..] (lines s), (col,char) <- zip [0..] s']

targetPos :: Int -> Maze -> Maybe Pos
targetPos t = fmap fst . find ((== Target t) . snd) . M.assocs

allTargets :: Maze -> [Int]
allTargets = concatMap f . M.elems where
    f (Target t) = [t]
    f _ = []


shortestRoundTrip isRoundTrip maze =
    let ts = allTargets maze
        combs = filter ((==0) . head) (permutations ts)
        paths = fmap (\p -> zip p (tail p)) combs
        pathsRound = fmap (\p -> zip p (tail p <> [0])) combs
        costMap = shortestPathsMap maze
        toCost = fmap sum . mapM (`M.lookup` costMap)
        minRoute = minimumBy (comparing toCost) (if isRoundTrip then pathsRound else paths)
    in toCost minRoute

shortestPathsMap maze = shortestPathsMap' (mapMaybe (`targetPos` maze) (allTargets maze)) maze

shortestPathsMap' [] maze = mempty
shortestPathsMap' (p:ps) maze = fold [ shortestPathMap p p' maze | p' <- ps ] <> shortestPathsMap' ps maze

shortestPathMap from to maze = fromMaybe M.empty $ do
    distance <- shortestPath from to maze
    (Target a) <- M.lookup from maze
    (Target b) <- M.lookup to maze
    pure $ M.fromList [((a,b), distance), ((b,a), distance)]

shortestPath :: Pos -> Pos -> Maze -> Maybe Int
shortestPath from to maze = go (Seq.singleton (from, 0)) (S.singleton from) where
    go states _ | null states = Nothing
    go ((pos,n):<|_) _ | pos == to = Just n
    go ((pos,n):<|ss) seen = let pos' = filter (`S.notMember` seen) (nextCells pos)
                                 ss' = ss >< Seq.fromList (zip pos' (repeat (n+1)))
                                 seen' = S.union seen (S.fromList (pos:pos'))
                             in go ss' seen'
    go states _ = error $ "Bad states: " <> show states
    nextCells = filter ((/=Wall) . \cell -> M.findWithDefault Wall cell maze) . neighbourPos
    neighbourPos (a,b) = [(a+1,b), (a-1,b), (a,b+1), (a,b-1)]
