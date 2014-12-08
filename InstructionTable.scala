package menumeration

/*
 * This class will be used to map substrings of instructions to
 * words that are likely to come after those substrings.
 */
class InstructionTable(instructionList: List[String]) {
	// This function takes outputs the list that was given in the constructor
	def it_get_list(): List[String] = instructionList
	// This function takes in an instruction as a string and 
	// returns the classes list with the new instruction added in
 	def it_add_instruct(instruction: String): List[String] = instruction::instructionList
 	// This function takes in a seedlength and an instruction as an array of strings
 	// and it outputs the instruction table for that particular instruction.
 	def it_get_table_unit(seedLength: Int, instruction: Array[String]): Map[String, List[String]] = 
 	  if(instruction.length > seedLength){
 	    val map1 = Map((instruction.slice(0,seedLength).mkString(" "),List(instruction(seedLength))))
 	    val map2 = it_get_table_unit(seedLength, instruction.slice(1,instruction.length))
 	    map1 ++ map2.map{ case (k,v) => k -> (map1.getOrElse(k,List()) ++ v) }
 	  }
 	  else{
 	    Map()
 	  }
	// This function takes in a seedLength and a list of instructions, and 
	// returns the instruction table for that list of instructions
 	def it_get_table_internal(seedLength: Int, l: List[String]): Map[String, List[String]] = l match{
	  case List() => Map()
	  
	  case h::t => 
	    	{	val map1 = it_get_table_unit(seedLength,h.split("\\s+")) 
 	  			val map2 = it_get_table_internal(seedLength, t)
 	  			map1 ++ map2.map{ case (k,v) => k -> (map1.getOrElse(k,List()) ++ v) }
	    	}
	}
 	// This function takes in a string and a frequency List, and
 	// edits the frequecy to include the new instance of the string
 	// and outputs the frequency list as a set.
 	def addString2FrequencySet(s: String, base_list: List[(String, Int)]): Set[(String,Int)] = base_list match{
 	  case List() => Set((s,1))
 	  case (st, count)::t => {
 	    if (st == s){
 	      ((s, count + 1)::t).toSet
 	    }
 	    else{
 	      addString2FrequencySet(s, t) ++ Set((st, count))
 	    } 
 	  }
 	}
 	// This function takes in a list of strings and returns a set of 
 	// string, integer pairs (where the int is the number of occurances 
 	// of the given string in the given list
 	def StringList2StringSet(l: List[String]): Set[(String,Int)] = l match {
 	  case List() => Set()
 	  case h::t => addString2FrequencySet(h, StringList2StringSet(t).toList)
 	}
 	// This function is the recursive helper function of mSL_to_mSS. It takes in
 	// a list of keys in addition to the required data that mSL_to_mSS takes in
 	def mapStringList2mapStringSet_internal(m: Map[String,List[String]], keys: List[String]): Map[String,Set[(String, Int)]] = keys match{
 	  case List() => Map()
 	  case h::t =>
 	    {	val map1 = (h -> StringList2StringSet(m(h)))
 	      	val map2 = mapStringList2mapStringSet_internal(m, t)
 	      	map2 + map1
 	    }
 	}
 	// This function takes in a Mapping of strings to a list of strings and 
 	// returns a mapping of strings to sets of string, frequency(Int) pairs 
 	def mapStringList2mapStringSet(m: Map[String,List[String]]): Map[String,Set[(String, Int)]] = 
 	    mapStringList2mapStringSet_internal(m, m.keys.toList)
 	// This function takes in a seedlength and returns the instruction table
 	// for the classes instruction list
	def it_get_table(seedLength: Int, recipeID: Int): Map[String,Set[(String, Int)]] = {
	  val mapStringList = it_get_table_internal(seedLength, instructionList)
	  val output = mapStringList2mapStringSet(mapStringList)
	  output
	}
}

object tester{
	def main(args: Array[String]){
		val testInst = List("Put the cookies on the sheet","Insert the cookies into the oven", "Put the cookies on a cooling rack")
		val it1 = new InstructionTable(testInst)
		println(it1.it_get_list())
		println(it1.it_add_instruct("sup"))
		println(it1.it_get_table(2, 11223344))
	}
}
