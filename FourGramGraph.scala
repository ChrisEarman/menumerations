package menumerations

import scala.collection.immutable.HashMap
import scala.util.Random

class FourGramGraph() {
    private var table = new HashMap[Tuple3[String, String, String], Array[Tuple2[String, Int]]]

    def printGraph() = {
        table.foreach {
            case(key, value) => {
                println(key + " -> [" + value.mkString(",") + "]")
            }
        }
    }

    /**
     *  Outward facing method for adding all 4-grams in the given sentence
     *  to the FourGramGraph.
     *  Converts sentence into Array[String] by splitting on whitespace.
     *  This array is passed to the internal method, addSplitSentence.
     */
    def addSentence(str: String, recipeId: Int) = {
        val split = str.split("\\s+")
        addSplitSentence(split, recipeId)
    }

    /**
     *  Breaks up the given Array into 4-grams, which are accordingly
     *  given to the addKVPair method to store the result in the internal table.
     */
    private def addSplitSentence(array: Array[String], recipeId: Int): Unit = {
        if (array.size == 3) {
            addKVPair(Tuple3(array(0).toLowerCase, array(1).toLowerCase, array(2).toLowerCase),
            Tuple2(" ", recipeId))
        } else if (array.size > 3) {
            addKVPair(Tuple3(array(0).toLowerCase, array(1).toLowerCase, array(2).toLowerCase),
            Tuple2(array(3), recipeId))
            addSplitSentence(array.tail, recipeId)
        } 
    }

    /**
     *  If the given key exists in the table, adds this tuple, v, to the
     *  Array indexed by the key.
     *  Otherwise, creates a new Array containing v, indexed by the given key.
     */
    private def addKVPair(k: Tuple3[String, String, String], v: Tuple2[String, Int]) = {
        if (table.contains(k)) {
            table = table + (k -> (table(k) :+ v))
        } else {
            table = table + (k -> Array(v))
        }
    }

    /**
     *  Performs a random traversal of the FourGramGraph.  Outputs a
     *  sequence of (String, recipeId) pairs.  Each pair identifies a
     *  word that follows the first 3 words in the key, and the recipeId
     *  in which that 4-gram was found.
     */
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
