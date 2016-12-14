import java.security.MessageDigest;
import java.math.BigInteger;

data class PendingKey(val index: Int, val char: Char)

val input = "zpqevtbw"
val N = 64


val md = MessageDigest.getInstance("md5")
fun md5(arg: Int): String {
    val bytes = md.digest((input + arg).toByteArray())
    return String.format("%032X", BigInteger(1, bytes))
}

fun hasTriplet(str: String): Char? {
   return hasTuple(str, 3)
}

fun hasQuintuple(str: String): Char? {
   return hasTuple(str, 5)
}

fun hasTuple(str: String, n: Int): Char? {
    var i = 0
    while(i < str.length - n) {
        var c = str.get(i)
        var found = true
        var j = 1
        while(j < n) {
            if(str.get(i + j) != c) {
                found = false
                break
            }

            j++
        }
        if(found) {
            return c
        }

        i++
    }

    return null
}

fun main(args: Array<String>) {

    var pendingKeys: MutableList<PendingKey> = mutableListOf()
    var keys = 0

    var i = 0
    while(keys < 64) {
        val hex = md5(i)
        val tripletChar = hasTriplet(hex)
        if(tripletChar != null)
            pendingKeys.add(PendingKey(i, tripletChar))

        val quintupleChar = hasQuintuple(hex)
        if(quintupleChar != null) {
            val fulfilledSize = pendingKeys.filter({ it.char == quintupleChar }).size
            keys += fulfilledSize

            pendingKeys = pendingKeys.filter { it.char != quintupleChar} as MutableList<PendingKey>
        }

        
        pendingKeys = pendingKeys.filter { it.index + 1000 < i} as MutableList<PendingKey>

        i++;
    }

    println(i)
}