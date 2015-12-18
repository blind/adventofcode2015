#!/usr/bin/swift

import Foundation

print("Day 2")

let input = try String( contentsOfFile: "input", encoding:NSUTF8StringEncoding )
var floor = 0

let rows = input.characters.split{ $0 == "\n" }.map(String.init)
var sumPaper = 0
var sumRibbon = 0

for row in rows {
	let nums = row.characters.split{$0 == "x"}.map{Int(String($0))!}
	let sorted = nums.sort()
	let surfArea = 3*sorted[0]*sorted[1] + 2*sorted[0]*sorted[2] + 2*sorted[1]*sorted[2]
	let ribbon = sorted[0]*2 + sorted[1]*2 + sorted[0]*sorted[1]*sorted[2]
	sumRibbon = sumRibbon + ribbon
	// print( "\(row) became \(surfArea) sqfeet")
	sumPaper = sumPaper + surfArea
}

print("Sq feet paper \(sumPaper)")
print("Feet of Ribbon \(sumRibbon)")
