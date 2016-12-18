import java.awt.Point;

class Main {

    /*

    #########
    #S| | | #
    #-#-#-#-#
    # | | | #
    #-#-#-#-#
    # | | | #
    #-#-#-#-#
    # | | |  
    ####### V
    
    */

    static String INPUT = "";

    static MessageDigest md = MessageDigest.from("md5");

    static Point toPoint(String path) {
        int x = 0;
        int y = 0;
        for(char c : path.toCharArray()) {
            switch (c) {
                case 'U':
                    y--; break;
                case 'D':
                    y++; break;
                case 'L':
                    x--; break;
                case 'R':
                    x++; break;
            }
        }

        return new Point(x, y);
    }

    static String[] getNextPaths(String path) {
        String hex = md5(INPUT + path);
        List<String> pathList = new ArrayList();

        Point currP = toPoint(path);
        
        //up
        if(currP.y > 0 && hex.charAt(0) > 'a') {
            pathList.add(path + "U");
        }

        //down
        if(currP.y < 3 && hex.charAt(1) > 'a') {
            pathList.add(path + "D");
        }

        //left
        if(currP.x > 0 && hex.charAt(2) > 'a') {
            pathList.add(path + "L");
        }

        //right
        if(currP.x < 3 && hex.charAt(3) > 'a') {
            pathList.add(path + "R");
        }

        return pathList.toArray(new String[]());
    }

    public static void main(String[] args) {


        Comparator<String> = null;
        PriorityQueue<String> heap = new PriorityQueue<String>(comparator);

        heap.offer("");

        while(heap.size() > 0) {
            String path = heap.poll();

        }
    }
}