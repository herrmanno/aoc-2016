case class Disc(val positions: Int, val position: Int) {
    def tick() = new Disc(positions, (position + 1) % positions)

    override def toString = {
        var s = ""
        for(i <- 0 to positions-1) {
            if(i == position)
                s += "_"
            else
                s+= "#"
        }
        s
    }
}

case class Discs(val discs: Disc*) {
    def tick() = new Discs(discs.map(_.tick) : _*)

    override def toString = {
        var s = ""
        for(disc <- discs) {
            s += disc.toString + "\n"
        }
        s
    }

    def isValid(): Boolean = {
        for(d <- discs) {
            var disc = d
            for(j <- 0 to discs.indexOf(disc)) {
                disc = disc.tick
            }
            if(disc.position != 0)
                return false
        }

        return true

    }
}


object Main {
    def main(args: Array[String]): Unit = {
        var state = Discs(
            Disc(17, 15),
            Disc(3, 2),
            Disc(19, 4),
            Disc(13, 2),
            Disc(7, 2),
            Disc(5, 0)
        )

        var i = 0
        
        while(!state.isValid()) {
            state = state.tick
            i += 1
        }
        println(state)

        println(i)

    }
}