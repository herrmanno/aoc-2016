import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;
import java.awt.Point;
import java.security.MessageDigest;
import java.security.spec.EllipticCurve;
import java.util.PriorityQueue;

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


    final String INPUT = "yjjvjgan";
    final Point FINAL_POINT = new Point(3, 3);

    final MessageDigest md;

    Main() throws Exception {
        md = MessageDigest.getInstance("md5");
    }

    Comparator<String> comparator = (String b, String a) -> {
        Point pa = toPoint(a);
        Point pb = toPoint(b);

        int diff1 = Integer.signum((int) ((pa.getX() + pa.getY()) - (pb.getX() + pb.getY())));
        int diff2 = Integer.signum(a.length() - b.length());    
        
        return diff1 != 0 ? diff1 : diff2;
    };

    String md5(String in) {
        byte[] bytes = md.digest(in.getBytes());

        return String.format("%032X", new java.math.BigInteger(1, bytes)).toLowerCase();
    }

    Point toPoint(String path) {
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

    String[] getNextPaths(String path) {
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

        return pathList.toArray(new String[pathList.size()]);
    }

    void main() {

        PriorityQueue<String> heap = new PriorityQueue<String>(comparator);

        heap.offer("");

        String longestPath = "";

        while(heap.size() > 0) {

            String path = heap.poll();

            if(toPoint(path).equals(FINAL_POINT)) {
                longestPath = path.length() > longestPath.length() ? path : longestPath;
                continue;
            }

            for(String nextPath : getNextPaths(path)) {
                heap.offer(nextPath);
            }
        }

        System.out.println(String.format("Length of longest path is: %d", longestPath.length()));
        System.exit(0);
    }

    public static void main(String[] args) throws Exception {
        new Main().main();
    }
}