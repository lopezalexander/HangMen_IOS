//
//  Player.swift
//  LeJeuxDuPendu
//
//  Created by Adnan El Guennouni on 2022-05-27.
//

import Foundation

class Player: Codable {
    var name: String
    var score: Int
    
    init(_ name: String,_ score: Int) {
        self.name = name
        self.score = score
    }
}
