//
//  MainMenuViewController.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 2022-05-23.
//


import UIKit

class MainMenuViewController: UIViewController {
    
    
    //Object pour envoyer en segue, il va permettre de selectionner le bon tab du TabBar selon la selection du User
    var index = IndexChosen()
    
    //Bouton Action pour Selectionner notre premier choix
    @IBAction func goToClassicTab(_ sender: Any) {
        index.IndexChosen = 0
        performSegue(withIdentifier: "segueMainToTab", sender: index)
        
    }
    
    @IBAction func goToMovieTab(_ sender: Any) {
        index.IndexChosen = 1
        performSegue(withIdentifier: "segueMainToTab", sender: index)
        
    }
    
    @IBAction func goToStatsTab(_ sender: Any) {
        index.IndexChosen = 2
        performSegue(withIdentifier: "segueMainToTab", sender: index)
        
    }
    
    
    //Preparation du segues au TabBarViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMainToTab" {
            let tabBar =  segue.destination as? TabBarViewController
            
            let senderType = sender as? IndexChosen
            
            tabBar?.index = senderType
        }
    }
    
    
    //Default viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   
    
}//Fin Class MainMenuViewController
