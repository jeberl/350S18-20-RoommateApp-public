//
//  HouseBalanceController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 4/4/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class HouseBalanceController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var balanceTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentHouseUIDtoNickname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseMemberBalanceCell", for: indexPath) as! BalanceCell
        cell.awakeFromNib()
        cell.textLabel?.text = currentHouseUIDtoNickname[currentHouseOrderedUIDs[indexPath.row]]
        cell.backgroundColor = UIColor.green
        cell.amountLabel.text = "Loading balance"
        
        let updateTableCallback : (Double) -> Void = { (amount) in
            print("got amount \(amount)")
            cell.amountLabel.text = self.stringFromAmount(amount)
            if amount < 0 {
                cell.backgroundColor = UIColor.red
            } else if amount > 0{
                cell.backgroundColor = UIColor.green
            } else {
                cell.backgroundColor = UIColor.yellow
            }
            print(self.backgorundColorFromAmount(amount))
            print(cell.backgroundColor)
        }
        
        DatabaseAccess.getInstance().getBalanceBetweenUsers(HouseID: currentHouseID!,
                                                            owesUID: currentHouseOrderedUIDs[indexPath.row],
                                                            owedUID: Auth.auth().currentUser!.uid,
                                                            callback: updateTableCallback)
        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        //self.balanceTable.backgroundColor = UIColor.lightGray
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func backgorundColorFromAmount(_ amount: Double) -> UIColor {
        let range = 25.0
        let cutEnds = (max(-1 * range, min(range, amount)) + range) / 2
        let G = cutEnds / range
        let R = (range - cutEnds) / range
        print(R, G)
        return UIColor(displayP3Red: CGFloat(R), green: CGFloat(G), blue: 0, alpha: 0)
    }
    
    private func stringFromAmount(_ amount: Double) -> String{
        return String(format: "$%.02f", amount)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
