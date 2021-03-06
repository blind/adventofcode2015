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
	var op : Operation
	var output : UInt16?

	init( _ op : Operation ) {
		self.op = op
	}

	func reset() {
		output = nil
	}
}

func parseGate( let command : String ) {
	let t : [String] = command.characters.split{$0 == " "}.map(String.init)

	let name = t[t.count-1]

	switch t[1] {
	case "OR":
		gates[name] = Gate( Operation.OR( Src.Gen(t[0]), Src.Gen(t[2]) ) )
	case "AND":
		gates[name] = Gate( Operation.AND( Src.Gen(t[0]), Src.Gen(t[2]) ) )
	case "LSHIFT":
		gates[name] = Gate( Operation.LSHIFT( Src.Gen(t[0]), UInt16(t[2])!))
	case "RSHIFT":
		gates[name] = Gate( Operation.RSHIFT( Src.Gen(t[0]), UInt16(t[2])!))
	case "->":
		gates[name] = Gate( Operation.ASSIGN( Src.Gen(t[0])))
	default:
		if t[0] == "NOT" {
			gates[name] = Gate( Operation.NOT( Src.Gen(t[1])))
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

			let evaluate = { (let src : Src) -> UInt16? in 
				switch src {
					case .Wire( let w ):
						return getValue( w )
					case .Value( let res ):
						return res
				}
			}

			switch gate.op {
			case .AND( let a, let b ):

				let srcA = evaluate(a)
				let srcB = evaluate(b)

				if (srcA != nil) && (srcB != nil) {
					gate.output = srcA!&srcB!
				}

			case .NOT( let a ):
				if let tmp = evaluate(a) {
					gate.output = ~tmp
				}

			case .OR( let a, let b ):
				let srcA = evaluate(a)
				let srcB = evaluate(b)

				if (srcA != nil) && (srcB != nil) {
					gate.output = srcA! | srcB!
				}

			case .RSHIFT( let a, let b ):
				if let srcA = evaluate(a) {
					gate.output = srcA >> b
				}

			case .LSHIFT( let a, let b ):
				if let srcA = evaluate(a) {
					gate.output = srcA << b
				}

			case .ASSIGN( let a ):
				gate.output = evaluate(a)
			}
		}
		return gate.output

	} else {
		print("no such wire \(wire)")
	}
	return nil
}

var gates = [String:Gate]() // Optional dictionary syntax Dictionary<String, Gate>()
let input = try String( contentsOfFile: "input", encoding:NSUTF8StringEncoding )
let lines = input.characters.split{ $0 == "\n"}.map(String.init)

for line in lines {
	parseGate(line)
}

if let result = getValue("a") {
	print("Result on wire a is \(result)")

	// Reset gates and update b.
	for gate in gates.values { gate.reset() }
	gates["b"] = Gate( Operation.ASSIGN( Src.Value(result) ) )

	let part2 = getValue("a")!
	print("Wire a in part 2 is \(part2)")


} else {
	print("There was no result")
}

