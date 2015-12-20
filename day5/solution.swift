#!/usr/bin/swift

import Foundation

extension String {

  subscript (i: Int) -> Character {
    return self[self.startIndex.advancedBy(i)]
  }

  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }

  subscript (r: Range<Int>) -> String {
    return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
  }
}



let vowels : [Character] = ["a","e","i","o","u"]
let forbidden : [String] = ["ab","cd","pq","xy"]

func isNice(let input : String) -> Bool {

	var vowelCount = 0
	var haveDouble = false
	var containsForbidden = false

	for var i=0; i < input.characters.count; ++i {
		// count vowles
		let c : Character = input[i]
		if vowels.contains( c ) {
			vowelCount = vowelCount+1
		}

		// Check doubles
		if (i > 0) {
			if (input[i-1] == c){
				haveDouble = true
			}
			let idx = input.startIndex.advancedBy(i-1)
			let endIdx = idx.advancedBy(2)
			let pair = input.substringWithRange(Range<String.Index>(start: idx, end: endIdx))
			if forbidden.contains( pair ) {
				containsForbidden = true
				break
			}
		}
	}
	return (vowelCount >= 3) && haveDouble && !containsForbidden
}


let input = try String( contentsOfFile: "input", encoding:NSUTF8StringEncoding )
let lines = input.characters.split{ $0 == "\n"}.map(String.init)

var niceCount = 0
var naughtyCount = 0

for line in lines {
	if isNice(line) {
		niceCount = niceCount + 1
	}
	else {
		naughtyCount = naughtyCount + 1
	}
}

print( "\(niceCount) of \(lines.count)")
