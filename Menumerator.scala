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
     */
    def loadRecipe(recipeId: Int, collection: BSONCollection): Option[Recipe] = {
        val future = collection.find(BSONDocument("_id" -> BSONInteger(recipeId))).one[Recipe]
        return Await.result(future, 20.seconds)
    }

    /**
     *  Loads all recipes in the Mongo database by converting
     *  each BSON document into a [Recipe] object.
     */    
    def loadAllRecipes(collection: BSONCollection): Seq[Recipe] = {
        val future = collection.find(BSONDocument()).
            cursor[Recipe].collect[Seq]()
        return Await.result(future, 4.hours)
    }

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

    def run() = {
        val driver = new MongoDriver
        val connection = driver.connection(List("localhost"))
        val db = connection("menumerations")
        val recipeCollection = db("recipes")
        val graph = new FourGramGraph
        val res = loadAllRecipes(recipeCollection)
        //TODO: Replace iterations with map function
        for (recipe <- res) {
            for (instruction <- recipe.instructions) {
                graph.addSentence(instruction.text, recipe.id)
            }
        }
        val seedRecipe = loadRandomRecipe(recipeCollection)
        val seedInstructions = seedRecipe.instructions
        //TODO: Replace iterations with map function
        for (instruction <- seedInstructions) {
            val split = instruction.text.split("\\s+")
            val seed = Tuple3(split(0).toLowerCase, split(1).toLowerCase, split(2).toLowerCase)
            print(seed)
            println(graph.traverse(Tuple3(split(0).toLowerCase, split(1).toLowerCase, split(2).toLowerCase)))
        }
    }

    def main(args: Array[String]) {
        run
    }
}
