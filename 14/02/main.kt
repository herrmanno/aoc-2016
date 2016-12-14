import java.security.MessageDigest;
import java.math.BigInteger;
import kotlin.comparisons.compareBy;

data class PendingKey(val index: Int, val char: Char, val hash: String)
data class ConfirmedKey(val i: Int, val iC: Int, val hash: String, val hashC: String)

val input = "zpqevtbw"
// val input = "abc"
val N = 64


val md = MessageDigest.getInstance("md5")

fun md5(arg: Int): String {
    var i = 0
    var h = input + arg
    
    while(i < 2017) {
        h = _md5(h)
        i++
    }

    return h
} 

fun _md5(arg: String): String {
    val bytes = md.digest(arg.toByteArray())
    return String.format("%032X", BigInteger(1, bytes)).toLowerCase()
}

fun hasTriplet(str: String): Char? {
   return hasTuple(str, 3).firstOrNull()
}

fun hasQuintuple(str: String): Char? {
   return hasTuple(str, 5).firstOrNull()
}

fun hasTuple(str: String, n: Int): List<Char> {
    var i = 0
    var cs: MutableList<Char> = mutableListOf()
    while(i < str.length - n) {
        var c = str.get(i)
        var found = true
        var j = 0
        while(j < n) {
            if(str.get(i + j) != c) {
                found = false
                break
            }

            j++
        }
        if(found) {
            cs.add(c)
        }

        i++
    }

    return cs
}

fun main1() {

    val MAX = 40000;

    val triplets: MutableList<Pair<Int,Char>> = mutableListOf()
    val quintuples: MutableList<Pair<Int,Char>> = mutableListOf()

    for(i in 0..MAX) {
        val h = md5(i)
        if(hasTriplet(h) != null)
            triplets.add(Pair(i, hasTriplet(h) as Char))
    }

    for(i in 0..MAX+1000) {
        val h = md5(i)
        if(hasQuintuple(h) != null)
            quintuples.add(Pair(i, hasQuintuple(h) as Char))
    }

    val t64 = triplets
        .filter { t ->
            quintuples.find { q ->
                q.first > t.first && q.first <= t.first + 1000 && q.second == t.second
            } != null
        }
        .sortedWith(compareBy({it.first}))
        .take(64)
        .forEachIndexed { idx, it ->
            println("$idx:\t$it")
        }

    // println(t64)
}

fun main(args: Array<String>) {
    main1()
}