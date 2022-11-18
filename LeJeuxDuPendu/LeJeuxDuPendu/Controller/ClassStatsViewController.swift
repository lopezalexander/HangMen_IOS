//
//  StatsViewController.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 2022-05-24.
//
 
import UIKit

class ClassStatsViewController: UIViewController {

    @IBOutlet var label_classicModeTopPlayers: [UILabel]!
    
    override func viewDidLoad(){
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
      
        let rankList = Statistic.shared.getTop5()["Classic Mode"]
        for i in 0...4 {
            if i < rankList!.count {
                label_classicModeTopPlayers[i].text = rankList![i].name + "--" + String(rankList![i].score)
            }
        }
        
    }
}
