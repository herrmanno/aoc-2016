<?php
    
    const MAXIMUM = 50;
    const INPUT = 1352;

    function printMaze($dim, $visited = array()) {
        for($i = 0; $i < $dim; ++$i) {
            for($j = 0; $j < $dim; ++$j) {
                if(count($visited) > $i && count($visited[$i]) > $j && $visited[$i][$j])
                    echo "O";
                else
                    echo (isWall($i, $j) ? "#" : "." );
            }
            echo "\n";
        }
    }

    function isWall($x, $y) {
        $temp = ($x*$x + 3*$x + 2*$x*$y + $y + $y*$y) + INPUT;
        $bin = decbin($temp);
        $one_count = substr_count($bin, "1");

        return ($one_count % 2) == 1;
    }

    function find($x_src, $y_src) {
        $visited = array_fill(0, 100, array_fill(0, 100, false));
        $dist = array_fill(0, 100, array_fill(0, 100, 999));
        
        $visited[$x_src][$y_src] = false;
        $dist[$x_src][$y_src] = 0;


        $queue = new SplQueue();
        $queue->push(array($x_src, $y_src, 0));

        while($queue->count() > 0) {
            $next = $queue->pop();

            if($visited[$next[0]][$next[1]]) {
                continue;
            }
            else {
                $visited[$next[0]][$next[1]] = true;
            }

            $dist[$next[0]][$next[1]] = $next[2];
            
            // if($next[2] == MAXIMUM) {
            //     continue;
            // }

            $rArr = array(-1, 0, 0, 1);
            $cArr = array(0, -1, 1, 0);
            for ($i = 0; $i < 4; $i++){
                $row = $next[0] + $rArr[$i];
                $col = $next[1] + $cArr[$i];
                
                if ($row >= 0 && $col >= 0 && !isWall($row, $col) && !$visited[$row][$col]) {
                    $cell = array($row, $col, $next[2] + 1);
                    $queue->push($cell);
                }
            }


            system("clear");
            printMaze(MAXIMUM, $visited);
            sleep(0.01);
        }

        $count = 0;
        // foreach($visited as $key=>$row) {
        //     foreach($row as $key2=>$wasVisited) {
        //         if($wasVisited) {
        //             $count++;
        //         }
        //     }
        // }

        foreach($dist as $key=>$row) {
            foreach($row as $key2=>$distance) {
                if($distance <= MAXIMUM) {
                    $count++;
                }
            }
        }

        return $count;
        
    }

    $result = find(1, 1, 31, 39);
    echo ("\n" . $result . "\n");

?>