#!/usr/bin/swift

import Foundation

print("Day 1")

let input = try String( contentsOfFile: "input", encoding:NSUTF8StringEncoding )
var floor = 0
var pos = 0
for char in input.characters {
	pos = pos + 1
	if char == "(" {
		floor+=1
	}
	else if char == ")" {
		floor-=1
	}

	if floor == -1 {
		break
	}
}
print( pos )
print(floor)
