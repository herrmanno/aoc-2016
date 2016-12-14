import scala.collection.immutable;
import scala.collection.mutable.ListBuffer;
import scala.collection.mutable.HashSet;

object Isotope extends Enumeration {
    val  Strontium, Plutonium, Thulium, Ruthenium, Curium = Value
}

abstract class RadioItem(val isotope: Isotope.Value)

object RadioItem {
    def isValidCombination(items_p: List[RadioItem]): Boolean = {
        val items = items_p.filter(_ != null)
        if(!items.find(_.isInstanceOf[RTG]).isEmpty) {
            // has RTG --> every chip needs its corresponding RTG
            
            items.filter(_.isInstanceOf[Chip]).forall(i1 => {
                //every chip needs to have its corresponding RTG
                items.exists(i2 => i2.getClass != i1.getClass && i2.isotope == i1.isotope)
            })
        }
        else {
            // has only chips --> everything is fine
            true
        }
        
    }

    def isValidCombination(items: (RadioItem, RadioItem)): Boolean = {
        val (i1, i2) = items
        null == i1 || null == i2 || i1.getClass == i2.getClass || i1.isotope == i2.isotope
    }
}

case class RTG(val iso: Isotope.Value) extends RadioItem(iso)

case class Chip(val iso: Isotope.Value) extends RadioItem(iso)


case class Elevator(floor: Int, content: (RadioItem, RadioItem)) {
    def isValid: Boolean = RadioItem.isValidCombination(content)
}

case class Floor(content: List[RadioItem]) {
    def isValid: Boolean = RadioItem.isValidCombination(content)

    /**
    * Gibt alle möglichen Kombinationen aus den Items der Etage zurück.
    */
    def combinations: List[(RadioItem, RadioItem)] = {
        var list: List[(RadioItem, RadioItem)] = content.map(i => (i, null))
        for (i <- content) {
            for (j <- content) {
                if(i != j)
                    list = (i,j) :: list
            }
        }

        return list
    }

    def add(items: (RadioItem, RadioItem)) = {
        new Floor((items._1 :: items._2 :: content).filter(_ != null))
    }

    def sub(items: (RadioItem, RadioItem)) = {
        new Floor((content diff List(items._1)) diff List(items._2))
    }

    def isEmpty() = content.isEmpty
}

case class State(parent: State, elevator: Elevator, floors: List[Floor]) {
    def currentFloor() = floors(elevator.floor -1)
    
    def lowerFloor() = elevator.floor match {
        case 1 => null
        case _ => floors(elevator.floor -2)
    }
    
    def upperFloor() = elevator.floor match {
        case 4 => null
        case _ => floors(elevator.floor)
    }

    def getNextStates(): List[State] = {
        var list = List[State]()
        val level = elevator.floor
        val lowerLevel = level - 1;
        val upperLevel = level + 1;
        val combs: List[(RadioItem, RadioItem)] = currentFloor.combinations.filter(RadioItem.isValidCombination(_))

        for(comb <- combs) {
            if(level != 1) { // move down
                val nextState = new State(
                    this,
                    new Elevator(level-1, comb),
                    List.tabulate(4)(i => {
                        i match {
                            case `lowerLevel` => floors(i).add(comb)
                            case `level` => floors(i).sub(comb)
                            case _ => floors(i) 
                        }
                    })
                )
                list = nextState :: list
            }
            if(level != 4) { // move up
                val nextState =  new State(
                    this,
                    new Elevator(level+1, comb),
                    List.tabulate(4)(i => {
                        i match {
                            case `upperLevel` => floors(i).add(comb)
                            case `level` => floors(i).sub(comb)
                            case _ => floors(i) 
                        }
                    })
                )
                list = nextState :: list
            }
        }

        list.filter(_.isValid).sortWith(_.heuristrik > _.heuristrik)
    }

    private def heuristrik(): Int = {
        var h = 0
        for(i <- 0 to 3)
            h += floors(i).content.length * i

        h
    }

    private def isValid: Boolean = {
        elevator.isValid && floors.forall(_.isValid)
    }

    // def eq(other: State): Boolean = {
    //     for(i <- 0 to 3)
    //         if(floors(i).content != other.floors(i).content)
    //             return false

    //     return true
    // }

    override def hashCode() = floors.hashCode

    // override def equals(other: Any): Boolean = {
    //     for(i <- 0 to 3)
    //         if(floors(i).content != other.asInstanceOf[State].floors(i).content)
    //             return false
    //     return true
    // }
}

object State {
    def isFinal(state: State) = {
        state.floors(0).isEmpty && state.floors(1).isEmpty && state.floors(2).isEmpty
    }
}

object Main {
    val MAX_DEPTH = 75
    
    val states = HashSet[Int]() 

    def main(args: Array[String]): Unit = {
        var level = 0

        val rootState = new State(
            null,
            new Elevator(1, (null, null)),
            List(
                new Floor( List( new RTG(Isotope.Strontium), new Chip(Isotope.Strontium), new RTG(Isotope.Plutonium), new Chip(Isotope.Plutonium) ) ),
                new Floor( List( new RTG(Isotope.Thulium), new RTG(Isotope.Ruthenium), new Chip(Isotope.Ruthenium), new RTG(Isotope.Curium), new Chip(Isotope.Curium) ) ),
                new Floor( List( new Chip(Isotope.Thulium) ) ),
                new Floor( List() )
            )
        )
        
        inspect(0, rootState)        
        println("Could not find final state with max depth " + Main.MAX_DEPTH)
    }

    def inspect(depth: Int, state: State): Unit = {
        // println("inspecting node with depth " + depth)

        val nextStates = state.getNextStates
    
        // println("inspecting " + nextStates.length + " substates")
        for(nextState <- nextStates) {

            var continue = false

            if(State.isFinal(nextState)) {
                println("Solved in " + depth + " step")
                System.exit(0)
            }
            
            if(Main.states.contains(nextState.hashCode)) {
                continue = true
            }
            else {
                Main.states += nextState.hashCode
            }

            if(depth >= Main.MAX_DEPTH) {
                continue = true
            }
            
            if(!continue) {
                inspect(depth + 1, nextState)
            }

        }

    }
}
