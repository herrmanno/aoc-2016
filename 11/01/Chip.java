class Chip implements RadioItem {

    static final Chip Strontium = new Chip(Isotope.Strontium);
    static final Chip Plutonium = new Chip(Isotope.Plutonium);
    static final Chip Thulium = new Chip(Isotope.Thulium);
    static final Chip Ruthenium = new Chip(Isotope.Ruthenium);
    static final Chip Curium = new Chip(Isotope.Curium);

    final Isotope type;

    private Chip(Isotope type) {
        this.type = type;
    }

    public Isotope getType() {
        return type;
    }

    public boolean equals(Object o) {
        if(o.getClass() != Chip.class)
            return false;
        Chip other = (Chip) o;
        return type.equals(other.type);
    }

    public int hashCode() {
        return type.hashCode();
    }
}