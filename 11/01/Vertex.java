import java.util.Set;

class Vertex implements Comparable<Vertex> {
    final Set<StatedItem> items;

    Vertex(Set<StatedItem> items) {
        this.items = items;
    }

    public int compareTo(Vertex other) {
        return 0;
    }

    public boolean equals(Object o) {
        Vertex other = (Vertex) o;
        return items.equals(other.items);
    }

    public int hashCode() {
        return items.hashCode();
    }
}