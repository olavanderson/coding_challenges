import UIKit

/**
 *
 * Codility test. This question, or some variant thereof, is one of the stock questions in the Codility test suite.
 *
 *  Given a phone calls log in the form of a string with each record separated by \n (ascii code 10) calculate the total phone bill.
 *  Each record is correctly formed as "HH:MM:SS,nnn-nnn-nnn" e.g. "00:01:07,400-234-090" refers to a phone call to phone number
 *  400-234-090 and lasted a duration of 1 minute and 7 seconds.
 *  Rules for calculating charges:
 *           (i) For a phone call less than 5 minutes long charge 3 cents per second
 *           (ii) For a phone call 5 minutes and longer charge 150 cents per started minute, so for a call of 5 minutes 2 seconds would be
 *                charged as a 6 minute call i.e. 6 * 150 = 900 cents
 *           (iii) All calls to the phone number with the longest total call duration are free. In the event that two phone numbers have the same total call duration use the one with the lowest sequential value.
 *
 * @author Olav Anderson (2022)
 *
 */

var input = """
00:00:60,400-234-087
00:00:60,400-234-088
00:00:60,400-234-088
"""

public func solution(_ S: inout String) -> Int {
    let log = S.split(separator: "\n")
    var callTotals = [String: Int]()
    var highest = 0
    var freeChargeKey = ""
    var totalCharge = 0
    
    for call in log {
        let callDetail = Array(call.split(separator: ","))
        let phoneNumber = String(callDetail[1])

        if freeChargeKey.isEmpty {
            freeChargeKey = phoneNumber
        }

        //Break the call times down into the seconds value for each call add them up.
        let callTimes: Int = Array(callDetail[0].split(separator: ":")).compactMap({Int($0)}).enumerated().map({(index, value) in
            
            switch index {
            case 0:
                return value * 3600
            case 1:
                return value * 60
            case 2:
                return value
            default:
                return 0
            }

        }).reduce(0, +)
        
        //Calculate the total charges incurred according to call rules
        var charge = 0
        if callTimes < 300 {
            charge = callTimes * 3
        } else if callTimes >= 300 {
            charge = ((callTimes / 60) + ((callTimes % 60) == 0 ? 0 : 1)) * 150
        }
        
        //Keep a tally of all charges
        totalCharge += charge
        
        //Sum up all call for a phone number
        if let prevVal = callTotals[phoneNumber] {
            charge = prevVal + charge
        }
        //Add to total charge for phone to map
        callTotals[phoneNumber] = charge
        
        //Now "charge" represents the total charge for the phone number if seen
        //more than once.
        //Determine which call is to be free
        //Lowest sequential phone number in case of equal charges
        if charge == highest, phoneNumber < freeChargeKey {
            freeChargeKey = phoneNumber
        } else if charge > highest {
            highest = charge
            freeChargeKey = phoneNumber
        }

    }
    //Remove free call charge from total
    if let free = callTotals[freeChargeKey] {
        return totalCharge - free
    } 
    
    return totalCharge
}

var test_case_number = 1
func check(expected: Int, output: Int) {
    let result = expected == output
    let rightTick = "\u{2713}"
    let wrongTick = "\u{2717}"
    if result {
        print("\(rightTick) Test #\(test_case_number)")
    } else {
        print("\(wrongTick) Test #\(test_case_number): Expected [\(expected)] Your output: [\(output)]")
    }
    test_case_number += 1
}

var s1 =
"""
00:01:07,400-234-090
00:05:01,701-080-080
00:05:00,400-234-090
"""
check(expected: 900, output: solution(&s1))

var s2 =
"""
00:01:07,400-234-090
00:05:01,701-080-080
00:05:00,400-234-090
00:05:00,400-234-091
00:01:07,400-234-091
"""
check(expected: 900 + 951, output: solution(&s2))

var s3 =
"""
00:05:00,400-234-089
00:01:07,400-234-089
00:01:07,400-234-090
00:05:01,701-080-080
00:05:00,400-234-090
00:05:00,400-234-091
00:01:07,400-234-091
"""
check(expected: 900 + 951 + 951, output: solution(&s3))

var s4 =
"""
00:00:60,400-234-088
"""
check(expected:0, output: solution(&s4))

var s5 =
"""
00:00:60,400-234-087
00:00:60,400-234-088
00:00:60,400-234-088
"""
check(expected: 180, output: solution(&s5))

var s6 =
"""
00:05:00,400-234-089
00:01:07,400-234-089
00:01:07,400-234-090
00:05:01,701-080-080
00:05:00,400-234-090
00:05:00,400-234-091
00:01:07,400-234-091
00:00:60,400-234-087
00:00:60,400-234-088
00:00:60,400-234-088
"""
check(expected: 900 + 951 + 951 + 540, output: solution(&s6))

//Correct keys for tests.
//freeChargeKey: 400-234-090
//✓ Test #1
//freeChargeKey: 400-234-090
//✓ Test #2
//freeChargeKey: 400-234-089
//✓ Test #3
//freeChargeKey: 400-234-088
//✓ Test #4
//freeChargeKey: 400-234-088
//✓ Test #5
//freeChargeKey: 400-234-089
//✓ Test #6

