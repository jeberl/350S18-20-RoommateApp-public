//
//  ChoreViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class ChoreViewController: UIViewController {

    @IBOutlet weak var choreTitleLabel: UILabel!
    @IBOutlet weak var choreImageView: UIImageView!
    @IBOutlet weak var choreDescriptionLabel: UILabel!
    @IBOutlet weak var choreAssignorImageVIew: UIImageView!
    @IBOutlet weak var choreAssignorNameLabel: UILabel!
    @IBOutlet weak var choreAssigneeImageView: UIImageView!
    @IBOutlet weak var choreAssigneeNameLabel: UILabel!
    @IBOutlet weak var choreTimeDueLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
