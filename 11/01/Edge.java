class Edge {
    final Vertex v1, v2;

    Edge(Vertex v1, Vertex v2) {
        this.v1 = v1;
        this.v2 = v2;
    }

    public boolean equals(Object o) {
        Edge other = (Edge) o;
        return (
            v1.equals(other.v1) && v2.equals(other.v2)
            ||
            v1.equals(other.v2) && v2.equals(other.v1)
        );
    }

    public int hashCode() {
        int result = 17;
        result = 31 * result + v1.hashCode();
        result = 31 * result + v2.hashCode();

        return result;
    }
}