//
//  RecieptParser.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 4/15/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import SwiftOCR

public class ReceiptParser {
    
    private var swiftOCRInstance : SwiftOCR
    private static var reciptParserInstance : ReceiptParser? = nil;
    
    private init() {
        swiftOCRInstance = SwiftOCR()
    }
    
    static func getInstance() -> ReceiptParser {
        if let instance = reciptParserInstance {
            return instance
        }
        reciptParserInstance = ReceiptParser();
        return reciptParserInstance!
    }
    
    func stringToDescriptionAmount(pairs : [String]) -> [(String, Double)] {
        return pairs.map { (str) -> (String, Double) in
            let ints = str.filter({ (ch) -> Bool in
                return (ch >= "0" && ch <= "9") || (ch == ".")
            })
            let description = str.filter({ (ch) -> Bool in
                return (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z")
            })
            return (description, Double(ints) ?? 0.0)
        }
    }
    
    public func parseStringToItems(read : String) -> [(String, Double)] {
        do {
            let pat = "[a-zA-Z]*[0-9]*\\.?[0-9]*"
            let regex = try NSRegularExpression(pattern: pat)
            let results = regex.matches(in: read,
                                        range: NSRange(read.startIndex..., in: read))
            return stringToDescriptionAmount(pairs: results.map {
                String(read[Range($0.range, in: read)!])
            })
        } catch {
            return []
        }
    }
    
    func parseReceipt(_ receipt : UIImage, paidByUIDs: [String], _ callback: @escaping ([RecieptItem]) -> Void) {
        swiftOCRInstance.recognize(swiftOCRInstance.preprocessImageForOCR(receipt)) { recognizedString in
            let pairs : [(String, Double)] = self.parseStringToItems(read: recognizedString)
            var items =  pairs.map { (pair) -> RecieptItem in
                let (description, amount) = pair
                return RecieptItem(description : description,
                                   totalCost : amount,
                                   makePaymentToUIDs: paidByUIDs)
            }
            items = items.filter({ (item) -> Bool in
                return item.cost > 0
            })
            callback(items)
        }
    }
    
}

//A class representing a single item on the reciept. A list of these are returned when a reciept is parsed. For each instance, the
// the user must select who is repsonsible for paying for it, (can be one user or multiple). The user must also note the user who paid the bill
class RecieptItem {
    var cost : Double
    var description : String
    var toChargeUIDs : [String]
    var payToUIDs : [String]
    var houseID : String
    
    init(description : String, totalCost : Double, makePaymentToUIDs : [String], splitCostBetweenUIDS: [String] = []) {
        cost = totalCost
        self.description = description
        toChargeUIDs = splitCostBetweenUIDS
        payToUIDs = makePaymentToUIDs
        houseID = currentHouseID!
    }
    
    //Returns True if charges were
    func sendCharges() -> ReturnValue<Bool>{
        // User must be prompted to set who to charge and who to pay for each RecieptItem
        if toChargeUIDs.count > 0 && payToUIDs.count > 0  {
            let db = DatabaseAccess.getInstance()
            let splitAmount = cost / (Double(toChargeUIDs.count) * Double(payToUIDs.count))
            if splitAmount > 0 {
                for chargeUID : String in toChargeUIDs {
                    for payToUID in payToUIDs {
                        //Dont charge self
                        if chargeUID != payToUID {
                            let charge = Charge(takeFromUID: chargeUID,
                                                giveToUID: payToUID,
                                                houseID: houseID,
                                                amount: splitAmount,
                                                message: "Scanned reciept item: \(description)")
                            let result = db.createCharge(charge: charge)
                            if result.returned_error {
                                return result
                            }
                        }
                    }
                }
            }
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
    //ADD Getters

    
}
