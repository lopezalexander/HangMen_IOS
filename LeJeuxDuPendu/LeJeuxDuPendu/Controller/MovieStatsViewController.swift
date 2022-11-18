//
//  StatsViewController.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 2022-05-24.
//
 
import UIKit

class MovieStatsViewController: UIViewController {

    @IBOutlet var Label_movieModeTopPlayers: [UILabel]!
    
    override func viewDidLoad(){
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let rankList = Statistic.shared.getTop5()["Movie Mode"]
        for i in 0...4 {
            if i < rankList!.count {
                Label_movieModeTopPlayers[i].text = rankList![i].name  + "--" + String(rankList![i].score)
            }
        }
    }
}
