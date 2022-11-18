//
//  ClassicViewController.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 2022-05-23.
//

import UIKit

class ClassicViewController: UIViewController {
    //Create a instance of ClassicGame
    var classicGameEngine = GameEngine()
    
    //Segue to onGoingGame
    @IBAction func goToGame(_ sender: Any) {
        //Si on veut envoyer quelque chose a OnGoingGame cest ici
        classicGameEngine.modeChosen = .classic
        performSegue(withIdentifier: "segueClassicToOnGoingGame", sender: classicGameEngine)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueClassicToOnGoingGame" {
            let onGoingGame =  segue.destination as? OnGoingGameViewController
            let senderType = sender as? GameEngine
            onGoingGame?.GameEngine = senderType
        }
    }
    
}
