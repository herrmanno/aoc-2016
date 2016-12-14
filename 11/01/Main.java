import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;

class Main {

    Set<Vertex> nodes;
    Set<Edge> edges;

    public static void main(String[] args) {
        new Main().foo();
    }

    void foo() {
        buildNodes();
        System.out.println(nodes.size());
        // Build all Edges by for(vertex : vertexes) -> make Edges for all neighbour states

        // Do Dijkstra
    }

    void buildNodes() {
        nodes = new HashSet<Vertex>();
        RadioItem[] items = {Rtg.Strontium, Rtg.Plutonium, Rtg.Thulium, Rtg.Ruthenium, Rtg.Curium, Chip.Strontium, Chip.Plutonium, Chip.Thulium, Chip.Ruthenium, Chip.Curium};
        for(List<Integer> combination : Main.combinations()) {
            // System.out.println(combination);
            Set<StatedItem> statedItems = new HashSet();
            for(int i = 0; i < combination.size(); i++) {
                statedItems.add(new StatedItem(items[i], combination.get(i)));
            }
            Vertex vertex = new Vertex(statedItems);
            nodes.add(vertex);
        }
    }

    void buildEdges() {

    }

    private static List<List<Integer>> combinations() {
        List[] setArr = new ArrayList[8];
        for(int i = 0; i < setArr.length; i++) {
            setArr[i] = new ArrayList(Arrays.asList(0,1,2,3));
        }

        return Main.cartesianProduct(setArr);
    }

    private static List<List<Integer>> cartesianProduct(List<Integer>... sets) {
        return Main.cartesianProduct(0, sets);
    }

    private static List<List<Integer>> cartesianProduct(int index, List<Integer>... sets) {
        List<List<Integer>> ret = new ArrayList();
        if (index == sets.length) {
            ret.add(new ArrayList<Integer>());
        } else {
            for (Integer obj : sets[index]) {
                for (List<Integer> set : Main.cartesianProduct(index+1, sets)) {
                    set.add(obj);
                    ret.add(set);
                }
            }
        }
        return ret;
    }

}