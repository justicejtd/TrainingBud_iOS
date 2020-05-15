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
/*:
 ## Type Inference
 ### Question 1
 Create a constant called `age1` and set it equal to `42`. Create a constant called `age2` and set it equal to `21`. Check using Option-click that the type for both has been inferred correctly as `Int`. */
let age1 = 42
let age2 = 21
/*:
 ### Question 2
 Create a constant called `avg1` and set it equal to the average of `age1` and `age2` using the naïve operation `(age1 + age2) / 2`. Use Option-click to check the type and check the result of `avg1`. Why is it wrong?
 */
//let avg1 = (age1 + age2) / 2
//It is wrong because you both operands are integer values, so the results will be truncated
/*:
 ### Question 3
 Correct the mistake in the above exercise by casting `age1` and `age2` to `Double` in the formula. Use Option-click to check the type and check the result of `avg1`. Why is it now correct?
 */
let avg = (Double(age1) + Double(age1)) / 2
let test = Double((age1 + age2) / 2)
let avg2 = (Double(age1) + Double(age2)) / 2
/*:
 ## Strings in Swift
 ### Question 1
 Create a string constant called `firstName` and initialize it to your first name. Also create a string constant called `lastName` and initialize it to your last name. */
let firstName = "Justice"
let lastName = "Dreischor"
/*:
 ### Question 2
 Create a string constant called `fullName` by adding the `firstName` and `lastName` constants together, separated by a space.
 */
let fullName = firstName + " " + lastName
/*:
 ### Question 3
 Using interpolation, create a string constant called `myDetails` that uses the `fullName` constant to create a string introducing yourself. For example, my string would read: `"Hello, my name is Lorenzo Boaro."`.
 */
let myDetails = "Hello, my name is Lorenze \(fullName)"
/*:
 ### Question 4
 Using interpolation and multi-line string literals, create a string constant called `myLongDetails` that uses the `fullName` constant to create a long string introducing yourself. For example, my string would read: `"Hello my name is Lorenzo Boaro\nand I'm learning how to use\nmulti-line string literals."`.
 */
let myLongDetails = """
Hello my name is Lorenzo \(fullName)
I'am learning how to use
multi-line string literals.
"""
/*:
 ## Tuples
 ### Question 1
 Declare a constant tuple that contains three `Int` values followed by a `Double`. Use this to represent a date (month, day, year) followed by an average temperature for that date. */
let tuple: (Int, Int, Int, Double) = (3, 3, 4, 3.33)
/*:
 ### Question 2
 Change the tuple to name the constituent components. Give them names related to the data that they contain: `month`, `day`, `year` and `averageTemperature`.
 */
var tuple2: (m: Int, d: Int, y: Int, avgT: Double) = (3, 3, 4, 3.33)
/*:
 ### Question 3
 In one line, read the day and average temperature values into two constants. You’ll need to employ the underscore to ignore the month and year.
 */
let (_, d, _, avgt) = tuple2
/*:
 ### Question 4
 Up until now, you’ve only seen constant tuples. But you can create variable tuples, too. Change the tuple you created in the exercises above to a variable by using `var` instead of `let`. Now change the average temperature to a new value.
 */
tuple2.avgT = 12
//: [Go to Solutions](@next)
