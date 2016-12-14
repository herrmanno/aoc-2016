import scala.collection.mutable.PriorityQueue;
import scala.collection.mutable.ArrayBuffer;
import scala.collection.mutable.TreeSet;

/*          RTG     Chip
Strontium    1       -1
Plutonium    2       -2
Thulium      3       -3
Ruthenium    4       -4
Curium       5       -5
*/

object State {
    def isValidCombination(c: Array[Int]): Boolean = {
        if(c.find(_ > 0) != null)
            c.sum == 0
        else
            true
    }
}

case class State(val level: Int, val floors: Array[Array[Int]]) extends Ordered[State] {
    if(floors.find(_ == null).nonEmpty)
        throw new IllegalArgumentException("Every floors must be an Array[Int]!")


    def getNextStates(): Array[State] = {
        var nextStates = new ArrayBuffer[State]()

        for(el <- floors(level).combinations(1)) {
            for(insertLev <- 0 to 3 if insertLev != level) {
                val newFloors = new Array[Array[Int]](4)
                
                for(lev <- 0 to 3) {
                    if(lev == insertLev)
                        newFloors(lev) = floors(lev) :+ el(0).asInstanceOf[Int]
                    else if(lev == this.level)
                        newFloors(lev) = floors(lev).filter(_ == el(0))
                    else
                        newFloors(lev) = floors(lev).toArray
                }

                val nextState = new State(insertLev, newFloors)
                nextStates += nextState
            }
        }

        for(els <- floors(level).combinations(2) if State.isValidCombination(els)) {

            for(insertLev <- 0 to 3 if insertLev != level) {
                val newFloors = new Array[Array[Int]](4)

                for(lev <- 0 to 3) {
                    if(lev == insertLev)
                        newFloors(lev) = floors(lev) ++ els
                    else if(lev == this.level)
                        newFloors(lev) = floors(lev) diff els
                    else
                        newFloors(lev) = floors(lev).toArray
                }

                val nextState = new State(insertLev, newFloors)
                nextStates += nextState
            }
        }

        nextStates.toArray
    }

    def isValid(): Boolean = {
        floors.forall(floor => {
            if(floor.find(_ > 0).nonEmpty) { //floor has rtgs
                floor.filter(_ < 0).forall(el => floor.find(el2 => el2 == -el).nonEmpty)
            } else {
                true
            }
        })
    }

    override def compare(other: State): Int = {
        var comp = 0;
        for(lev <- 3 to 0) {
            comp += (floors(lev).length - other.floors(lev).length) * lev
        }
        comp
    }

    override def equals(other: Any): Boolean = floors.equals(other.asInstanceOf[State].floors)

    override def hashCode(): Int = floors.hashCode

    override def toString(): String = s"STATE $level******************\n${floors(0).mkString(",")}\n${floors(1).mkString(",")}\n${floors(2).mkString(",")}\n${floors(3).mkString(",")}"

}

object Main {

    def main(args: Array[String]): Unit = {
        val finalState: State = new State(3, List(
            List(1, -1, 2, -2, 3, -3, 4, -4, 5, -5).toArray[Int],
            Array[Int](0),
            Array[Int](0),
            Array[Int](0)
        ).toArray[Array[Int]])
        val rootState: State = new State(0, List(
            List(1, -1, 2, -2).toArray[Int],
            List(3, 4, -4, 5, -5).toArray[Int],
            List(-3).toArray[Int],
            Array[Int](0)
        ).toArray[Array[Int]])
        
        val queue = new PriorityQueue[State]()
        val visited = new TreeSet[Long]()

        var steps = 0;
        queue += rootState;
        while(!queue.isEmpty) {
            val state = queue.dequeue
            
            if(state == finalState) {
                println(steps)
                return;
            }

            if(!visited.contains (state.hashCode)) {
                visited += state.hashCode

                for(state <- state.getNextStates if state.isValid) {
                    queue += state
                }
            }

        }

    }
}