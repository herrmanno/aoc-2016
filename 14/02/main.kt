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
    return _md5(input + arg)
}

fun _md5(arg: String): String {
    var hash = arg
    for(i in 0..2016) {
        val bytes = md.digest(hash.toByteArray())
        hash =  String.format("%032X", BigInteger(1, bytes)).toLowerCase()
    }
    return hash
}

val tripletRegex = "(.)\\1{2}".toRegex()
fun hasTriplet(str: String): Char? {
    val m = tripletRegex.find(str)
    if(m != null)
        return m.value[0]
    else
        return null
}

val quintupleRegex = "(.)\\1{4}".toRegex()
fun hasQuintuple(str: String): Char? {
    val m = quintupleRegex.find(str)
    if(m != null)
        return m.value[0]
    else
        return null
}

fun main1() {

    val MAX = 35000;

    val triplets: MutableList<Pair<Int,Char>> = mutableListOf()
    val quintuples: MutableList<Pair<Int,Char>> = mutableListOf()

    for(i in 0..MAX) {
        val h = md5(i)
        if(hasTriplet(h) != null) {
            triplets.add(Pair(i, hasTriplet(h) as Char))
              
            if(hasQuintuple(h) != null)
                quintuples.add(Pair(i, hasQuintuple(h) as Char))
        }
    }

    val t64 = triplets
        .filter { t ->
            quintuples.find { q ->
                q.first > t.first && q.first <= t.first + 1000 && q.second == t.second
            } != null
        }
        .take(64)
        .forEachIndexed {idx, hash -> println("$idx:\t\t$hash")}

}

fun main(args: Array<String>) {
    main1()
}