//
//  TabBarViewController.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 2022-05-24.
//

import UIKit

class TabBarViewController: UITabBarController{
    
    var index: IndexChosen!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Selectionne le tab choisi par le User dans le MainMenu
        if let id = index.IndexChosen {
            self.selectedIndex = id
        }
    }
    
    //Cette fonction me permet de DISABLE les gestes pour DISMISS une transition
    //Entre le MainMenu et le TabBarViewController
    //Sinon, si on pese sur le la moitie du haut de l'ecran lors de la transition, ca va dismiss la transition et ca bug
    //Ceci est particulierement visible avec Partial Curl Transition. Les autres ne semble pas avoir besoin de ceci
    private func removePartialCurlTap() {
        if let gestures = self.view.gestureRecognizers {
        for gesture in gestures {
          self.view.removeGestureRecognizer(gesture)
        }
      }
    }
    
    //En conjonction avec removePartialCurlTap(), lorsque le TabBar est afficher, il faut disable le DISMISS gesture de la transition MainMenu
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      removePartialCurlTap()
    }
    
    
}//Fin class TabBarViewController
