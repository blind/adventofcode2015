#!/usr/bin/swift

import Foundation

print("Day 1")

let input = try String( contentsOfFile: "input", encoding:NSUTF8StringEncoding )


let variables : Dictionary<String,UInt16>

let lines = input.characters.split{ $0 == "\n"}.map(String.init)


enum Src {
	case Wire(String)
	case Value(UInt16)
	func Gen(let src : String) -> Src {
		if let val = Int(src) {
			return Src.Value(val)
		} else {
			return Src(src)
		}
	}
}

enum Operation {
	case AND( Src, Src )
	case NOT( Src )
	case OR( Src, Src )
	case RSHIFT( Src, UInt16 )
	case LSHIFT( Src, UInt16 )
	case ASSIGN( UInt16 )
}


struct Gate {
	var name : String
	var op : Operation
}


let gates = Dictionary<String, Gate>()

func parseGate( let command : String ) {
	let t = command.characters.split{$0 == " "}.map(String.init)

	var gate : Gate? = nil
	var name = t[t.count-1]

	switch t[1] {
		case "OR":
			gate = Gate( name: name, op: Operation.OR( Src.gen(t[0]), Src.gen(t[2]) ) )
		case "AND":
			gate = Gate( name: name, op: Operation.AND( Src.gen(t[0]), Src.gen(t[2]) ) )
		case "LSHIFT":
			print("LSHIFT")
		case "RSHIFT":
			print("RSHIFT")
		default:
			break
	}


	if gate != nil
	{
		// Check assign or NOT
		print("lala")
	}

}

for line in lines {
	parseGate(line)
}

