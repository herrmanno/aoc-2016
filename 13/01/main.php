<?php
    
    const MAXIMUM = 45;
    const INPUT = 1352;

    function isWall($x, $y) {
        $temp = ($x*$x + 3*$x + 2*$x*$y + $y + $y*$y) + INPUT;
        $bin = decbin($temp);
        $one_count = substr_count($bin, "1");

        return ($one_count % 2) == 1;
    }

    function printMaze($dim) {
        for($i = 0; $i < $dim; ++$i) {
            for($j = 0; $j < $dim; ++$j) {
                echo (isWall($i, $j) ? "#" : "." );
            }
            echo "\n";
        }
    }



    function find($x_src, $y_src, $x_dst, $y_dst) {
        $visited = array_fill(0, 100, array_fill(0, 100, false));
        
        $visited[$x_src][$y_src] = true;

        $queue = new SplQueue();
        $queue->push(array($x_src, $y_src, 0));

        while($queue->count() > 0) {
            $next = $queue->top();
            
            if($next[0] == $x_dst && $next[1] == $y_dst) {
                return $next[2];
            }

            $queue->pop();

            $rArr = array(-1, 0, 0, 1);
            $cArr = array(0, -1, 1, 0);
            for ($i = 0; $i < 4; $i++){
                $row = $next[0] + $rArr[$i];
                $col = $next[1] + $cArr[$i];
                
                if ($row >= 0 && $col >= 0 && $row < MAXIMUM && $col < MAXIMUM && !isWall($row, $col) && !$visited[$row][$col]) {
                    $visited[$row][$col] = true;
                    $cell = array($row, $col, $next[2] + 1);
                    $queue->push($cell);
                }
            }
        }

        return -1;
        
    }

    // printMaze(100);

    $result = find(1, 1, 31, 39);
    echo ($result . "\n");

    // echo isWall(0, 0) . "\n";
    // echo isWall(0, 1) . "\n";

?>