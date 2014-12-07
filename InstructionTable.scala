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
 	def it_get_table_unit(seedLength: Int, instruction: Array[String]): Map[String, Set[String]] = 
 	  if(instruction.length > seedLength){
 	    val map1 = Map((instruction.slice(0,seedLength).mkString(" "),Set(instruction(seedLength))))
 	    val map2 = it_get_table_unit(seedLength, instruction.slice(1,instruction.length))
 	    map1 ++ map2.map{ case (k,v) => k -> (map1.getOrElse(k,Set()) ++ v) }
 	  }
 	  else{
 	    Map()
 	  }
	// This function takes in a seedLength and a list of instructions, and 
	// returns the instruction table for that list of instructions
 	def it_get_table_internal(seedLength: Int, l: List[String]): Map[String, Set[String]] = l match{
	  case List() => Map()
	  
	  case h::t => 
	    	{	val map1 = it_get_table_unit(seedLength,h.split("\\s+")) 
 	  			val map2 = it_get_table_internal(seedLength, t)
 	  			map1 ++ map2.map{ case (k,v) => k -> (map1.getOrElse(k,Set()) ++ v) }
	    	}
	}
 	// This function takes in a seedlength and returns the instruction table
 	// for the classes instruction list
	def it_get_table(seedLength: Int): Map[String,Set[String]] = it_get_table_internal(seedLength, instructionList)
}

object tester{
	def main(args: Array[String]){
		val testInst = List("Put the cookies on the sheet","Insert the cookies into the oven")
		val it1 = new InstructionTable(testInst)
		println(it1.it_get_list())
		println(it1.it_add_instruct("sup"))
		println(it1.it_get_table(2))
		println(it1.it_get_table(2))
	}
}
