class Rtg implements RadioItem {

    static final Rtg Strontium = new Rtg(Isotope.Strontium);
    static final Rtg Plutonium = new Rtg(Isotope.Plutonium);
    static final Rtg Thulium = new Rtg(Isotope.Thulium);
    static final Rtg Ruthenium = new Rtg(Isotope.Ruthenium);
    static final Rtg Curium = new Rtg(Isotope.Curium);

    final Isotope type;


    private Rtg(Isotope type) {
        this.type = type;
    }

    public Isotope getType() {
        return type;
    }

    public boolean equals(Object o) {
        if(o.getClass() != Rtg.class)
            return false;
        Rtg other = (Rtg) o;
        return type.equals(other.type);
    }

    public int hashCode() {
        return type.hashCode();
    }

}