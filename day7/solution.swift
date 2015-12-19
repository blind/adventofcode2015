#!/usr/bin/swift

import Foundation

enum Src {
	case Wire(String)
	case Value(UInt16)
	static func Gen(let src : String) -> Src {
		if let val = UInt16(src) {
			return Src.Value(val)
		} else {
			return Src.Wire(src)
		}
	}
}

enum Operation {
	case AND( Src, Src )
	case NOT( Src )
	case OR( Src, Src )
	case RSHIFT( Src, UInt16 )
	case LSHIFT( Src, UInt16 )
	case ASSIGN( Src )
}


class Gate {
	var name : String
	var op : Operation
	var output : UInt16?

	init( _ name: String, _ op : Operation ) {
		self.name = name
		self.op = op
	}
}

func parseGate( let command : String ) {
	let t : [String] = command.characters.split{$0 == " "}.map(String.init)

	let name = t[t.count-1]

	switch t[1] {
	case "OR":
		gates[name] = Gate( name, Operation.OR( Src.Gen(t[0]), Src.Gen(t[2]) ) )
	case "AND":
		gates[name] = Gate( name, Operation.AND( Src.Gen(t[0]), Src.Gen(t[2]) ) )
	case "LSHIFT":
		gates[name] = Gate( name, Operation.LSHIFT( Src.Gen(t[0]), UInt16(t[2])!))
	case "RSHIFT":
		gates[name] = Gate( name, Operation.RSHIFT( Src.Gen(t[0]), UInt16(t[2])!))
	case "->":
		gates[name] = Gate( name, Operation.ASSIGN( Src.Gen(t[0])))
	default:
		if t[0] == "NOT" {
			gates[name] = Gate( name, Operation.NOT( Src.Gen(t[1])))
		}
		else {
			print("Failed to parse \(command)")
		}
		break
	}
}

func getValue(wire: String) -> UInt16? {

	if let gate = gates[wire] {
		if let value = gate.output {
			return value
		} else {

			let parse = { (let src : Src) -> UInt16? in 
				switch src {
					case .Wire( let w ):
						return getValue( w )
					case .Value( let res ):
						return res
				}
			}

			switch gate.op {
			case .AND( let a, let b ):

				let srcA = parse(a)
				let srcB = parse(b)

				if (srcA != nil) && (srcB != nil) {
					gate.output = srcA!&srcB!
				}

			case .NOT( let a ):
				if let tmp = parse(a) {
					gate.output = ~tmp
				}

			case .OR( let a, let b ):
				let srcA = parse(a)
				let srcB = parse(b)

				if (srcA != nil) && (srcB != nil) {
					gate.output = srcA! | srcB!
				}

			case .RSHIFT( let a, let b ):
				if let srcA = parse(a) {
					gate.output = srcA >> b
				}


			case .LSHIFT( let a, let b ):
				if let srcA = parse(a) {
					gate.output = srcA << b
				}

			case .ASSIGN( let a ):
				gate.output = parse(a)
			}
		}
		return gate.output

	} else {
		print("no such wire \(wire)")
	}
	return nil
}

var gates = Dictionary<String, Gate>()
let input = try String( contentsOfFile: "input", encoding:NSUTF8StringEncoding )
let lines = input.characters.split{ $0 == "\n"}.map(String.init)

print("Day 7")

print( "Number of lines parsed \(lines.count)")

for line in lines {
	parseGate(line)
}


if let result = getValue("a") {
	print("Result on wire a is \(result)")
} else {
	print("There was no result")
}

print( "For part 2 anwer change input on b to result in part A.")
