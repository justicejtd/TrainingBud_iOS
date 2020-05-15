/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

// -------------
// Code Comments
// -------------

// This is a comment. It is not executed.

// This is also a comment.
// Over multiple lines.

/* This is also a comment.
 Over many..
 many...
 many lines. */

// ------------
// Printing Out
// ------------

print("Hello, Swift Apprentice reader!")

// ---------------------
// Arithmetic Operations
// ---------------------

2 + 6

10 - 2

2 * 4

24 / 3

2+6
2 + 6 // OK
//2 +6  // ERROR
//2+ 6  // ERROR

// Decimal Numbers

22 / 7

22.0 / 7.0

// The Remainder Operation

28 % 10

(28.0).truncatingRemainder(dividingBy: 10.0)

// Shift Operations

1 << 3

32 >> 2

// Order of Operations

((8000 / (5 * 10)) - 32) >> (29 % 5)

350 / 5 + 2

350 / (5 + 2)

// --------------
// Math Functions
// --------------

sin(45 * Double.pi / 180)

cos(135 * Double.pi / 180)

(2.0).squareRoot() // Same as sqrt(2)

max(5, 10)

min(-5, -10)

max(sqrt(2), Double.pi / 2)

// -----------
// Naming Data
// -----------

// Constants

let number: Int = 10
//number = 0 /* Cannot assign to value: 'number' is a 'let' constant */

let pi: Double = 3.14159

// Variables

var variableNumber: Int = 42
variableNumber = 0
variableNumber = 1_000_000

// Using Meaningful Names

var 🐶💩: Int = -1

// -----------------------
// Increment and Decrement
// -----------------------

var counter: Int = 0
counter += 1 // Same as counter = counter + 1
counter -= 1 // Same as counter = counter - 1

/* var */ counter = 10
counter *= 3 // Same as counter = counter * 3
counter /= 2 // Same as counter = counter / 2
