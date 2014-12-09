package menumerations

import scala.concurrent._
import scala.concurrent.Await
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import scala.util.Random
import reactivemongo.api._
import reactivemongo.bson._
import reactivemongo.api.collections.default._


object Menumerator {

    /**
     *  Reader object for generating [Instruction] objects from BSON
     */
    implicit object InstructionReader extends BSONDocumentReader[Instruction] {
        def read(doc: BSONDocument): Instruction = Instruction(
            doc.getAs[String]("text").get)
    }

    /**
     *  Reader object for generating [Ingredient] objects from BSON
     */
    implicit object IngredientReader extends BSONDocumentReader[Ingredient] {
        def read(doc: BSONDocument): Ingredient = Ingredient(
            doc.getAs[String]("text").get,
            null)
    }

    /**
     *  Reader object for generating [Recipe] objects from BSON
     */
    implicit object RecipeReader extends BSONDocumentReader[Recipe] {
        def read(doc: BSONDocument): Recipe = Recipe(
            doc.getAs[Set[Ingredient]]("ingredients").get,
            doc.getAs[Seq[Instruction]]("instructions").get,
            doc.getAs[Int]("_id").get)
    }

    /**
     *  Loads a recipe from a Mongo database by converting
     *  the BSON document into a [Recipe] object.
     *  Returns None if the given recipeid is not the _id of any
     *  recipe in the collection.
     *
     *  Blocking.
     */
    def loadRecipe(recipeId: Int, collection: BSONCollection): Option[Recipe] = {
        val future = collection.find(BSONDocument("_id" -> BSONInteger(recipeId))).one[Recipe]
        return Await.result(future, 20.seconds)
    }

    /**
     *  Loads all recipes in the Mongo database by converting
     *  each BSON document into a [Recipe] object.
     *
     *  Blocking.
     */    
    def loadAllRecipes(collection: BSONCollection): Seq[Recipe] = {
        val future = collection.find(BSONDocument()).
            cursor[Recipe].collect[Seq]()
        return Await.result(future, 4.hours)
    }

    /**
     *  Loads a random recipe by selecting an _id between 1 and 519809,
     *  repeatedly, until a valid recipe is found matching the _id.
     *  NOTE: this is bad when the database of collected recipes
     *  is very sparse.
     *
     *  Blocking.
     */    
    def loadRandomRecipe(collection: BSONCollection): Recipe = {
        val randy = new Random
        val randInt = randy.nextInt(519809) + 1
        val loadedRecipe = loadRecipe(randInt, collection)
        if (loadedRecipe.isEmpty) {
            return loadRandomRecipe(collection)
        } else {
            return loadedRecipe.get
        }
    }

    /**
     *  Get the Set[Ingredient] for the given recipeId
     */
    def getRecipeIngredients(recipeId: Int, collection: BSONCollection): Set[Ingredient] = {
        val recipe = loadRecipe(recipeId, collection).get
        return recipe.ingredients
    }

    /**
     *  Generates a new, randomized recipe by using an existing one as a
     *  "seed", using the first few words of each of the "seed" recipe's 
     *  instructions, and traversing the input graph to create new instructions.
     *  Ingredients are associated with each word, and are used in the new
     *  recipe if the associated word is a substring of the ingredient's text.
     */
    def getRandomizedRecipe(graph: FourGramGraph, collection: BSONCollection): Recipe = {
        val seedRecipe = loadRandomRecipe(collection)
        var tupleSet: Set[Tuple2[String, Int]] = Set()
        var instructions: Seq[Instruction] = Seq()
        var ingredients: Set[Ingredient] = Set()
        for (instruction <- seedRecipe.instructions) {
            val split = instruction.text.split("\\s+")
            if (split.size >= 3) {
                val res = graph.traverse(Tuple3(split(0).toLowerCase, split(1).toLowerCase, split(2).toLowerCase))
                val generatedInstruction = split(0) + " " + split(1) + " " + split(2) + " " + res.unzip._1.mkString(" ")
                tupleSet = tupleSet ++ res + Tuple2(split(0), seedRecipe.id) + 
                    Tuple2(split(1), seedRecipe.id) + Tuple2(split(2), seedRecipe.id)
                instructions = instructions :+ Instruction(generatedInstruction)
            } else if (split.size == 2) {
                tupleSet = tupleSet + Tuple2(split(0), seedRecipe.id) + 
                    Tuple2(split(1), seedRecipe.id)
                instructions = instructions :+ instruction
            } else if (split.size == 1) {
                tupleSet = tupleSet + Tuple2(split(0), seedRecipe.id)
                instructions = instructions :+ instruction
            }
        }
        for (tuple <- tupleSet) {
            // TODO: Fix inefficiency with next command (should not have to look up same recipe >1 time)
            val possibleIngs = getRecipeIngredients(tuple._2, collection)
            for (ing <- possibleIngs) {
                if (ing.text.toLowerCase.containsSlice(tuple._1.toLowerCase)) {
                    ingredients = ingredients + ing
                }
            }
        }
        return Recipe(ingredients, instructions, 0)
    }

    def run() = {
        /**
         *  Establishes connection to "recipe" collection in "menumerations" db
         */
        val driver = new MongoDriver
        val connection = driver.connection(List("localhost"))
        val db = connection("menumerations")
        val recipeCollection = db("recipes")
        
        /**
         *  Initialize graph and load all recipes
         */
        val graph = new FourGramGraph
        val allRecipes = loadAllRecipes(recipeCollection)

        /**
         *  Add all instructions across all recipes into the graph
         */
        // TODO: Replace iterations with map function
        for (recipe <- allRecipes) {
            for (instruction <- recipe.instructions) {
                graph.addSentence(instruction.text, recipe.id)
            }
        }

        val randomRecipe = getRandomizedRecipe(graph, recipeCollection)
        println(randomRecipe)
    }

    def main(args: Array[String]) {
        run
    }
}
