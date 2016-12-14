class StatedItem {
    final RadioItem item;
    final int floor;

    StatedItem(RadioItem item, int floor) {
        this.item = item;
        this.floor = floor;
    }

    public boolean equals(Object o) {
        StatedItem other = (StatedItem) o;
        return item.equals(other.item) && floor == other.floor;
    }

    public int hashCode() {
        int result = 17;
        result = 31 * result + item.hashCode();
        result = 31 * result + floor;

        return result;
    }
}