#!/usr/bin/swift

import Foundation

let input = try String( contentsOfFile: "input", encoding:NSUTF8StringEncoding )

var sumPaper = 0
var sumRibbon = 0

func ==(lhs:Position,rhs:Position) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y;
}

struct Position : Hashable {
	var x : Int = 0
	var y : Int = 0

	var hashValue : Int {
		get {
			return "\(self.x):\(self.y)".hashValue;
		}
	}
}

var currentPos = Position(x:0,y:0)
var visitedHouses = Set<Position>()
var robotPos = Position(x:0,y:0)

visitedHouses.insert( currentPos )
var myTurn = true

func move(var p:Position, let c: Character ) -> Position { 
	if c == "^" {
		p.y -= 1
	} else if c == "v" {
		p.y += 1
	} else if c == "<" {
		p.x -= 1
	} else if c == ">" {
		p.x += 1
	}
	visitedHouses.insert( p )
	return p
}

for dir in input.characters {
	if myTurn { currentPos = move(currentPos, c: dir) }
	else { robotPos = move(robotPos, c: dir)}
	myTurn = !myTurn
}

print( visitedHouses.count )