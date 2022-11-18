//
//  MovieViewController.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 2022-05-24.
//


import UIKit

class MovieViewController: UIViewController {
    
    var movieGameEngine = GameEngine()
    
    @IBAction func goToGame(_ sender: Any) {
        //Si on veut envoyer quelque chose a OnGoingGame cest ici
        movieGameEngine.modeChosen = .movie
        performSegue(withIdentifier: "segueMovieToOnGoingGame", sender: movieGameEngine)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMovieToOnGoingGame" {
            let onGoingGame =  segue.destination as? OnGoingGameViewController
            
            let senderType = sender as? GameEngine
            
            
            onGoingGame?.GameEngine = senderType
            
        }
    }
    
}
