package menumerations

import scala.collection.immutable.HashMap
import scala.util.Random

class FourGramGraph() {
    var table = new HashMap[Tuple3[String, String, String], Array[Tuple2[String, Int]]]

    def addSentence(str: String, recipeId: Int) = {
        val split = str.split("\\s+")
        addSplitSentence(split, recipeId)
    }

    def addSplitSentence(array: Array[String], recipeId: Int): Unit = {
        if (array.size == 3) {
            addKVPair(Tuple3(array(0).toLowerCase, array(1).toLowerCase, array(2).toLowerCase),
            Tuple2(" ", recipeId))
        } else if (array.size > 3) {
            addKVPair(Tuple3(array(0).toLowerCase, array(1).toLowerCase, array(2).toLowerCase),
            Tuple2(array(3), recipeId))
            addSplitSentence(array.tail, recipeId)
        } 
    }

    def addKVPair(k: Tuple3[String, String, String], v: Tuple2[String, Int]) = {
        if (table.contains(k)) {
            table = table + (k -> (table(k) :+ v))
        } else {
            table = table + (k -> Array(v))
        }
    }

    def traverse(k: Tuple3[String, String, String]): Seq[Tuple2[String, Int]] = {
        if (table.contains(k)) {
            val v = table(k)
            val randy = new Random
            val randInt = randy.nextInt(v.size)
            val chosenTuple = v(randInt)
            val nextStr = chosenTuple._1.toLowerCase
            if (nextStr == " ") {
                return Seq()
            } else {
                return chosenTuple +: traverse(Tuple3(k._2, k._3, nextStr))
            }
        } else {
            return Seq()
        }
    }
}
