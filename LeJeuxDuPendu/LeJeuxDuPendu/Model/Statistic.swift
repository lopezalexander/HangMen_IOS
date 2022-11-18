//
//  Statistic.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 2022-05-23.
//

import Foundation

class Statistic {
    
    private var movieModeSortList = [Player]()
    private var classicModeSortList = [Player]()
    private var movieModeTop5 = [Player]()
    private var classicModeTop5 = [Player]()
    public var currentPlayer = ""
    
    static let shared = Statistic()
    
    //MARK: GET TOP 5
    func getTop5() -> [String:[Player]] {
        //Get Array of Movie and Classic Mode Names and Scores
        movieModeSortList = getMovieModeData()
        classicModeSortList = getClassicModeData()
        
        //sort the list for ranking top5
        sortByScore()
        
        //reset list of Top5 in each mode
        movieModeTop5.removeAll()
        classicModeTop5.removeAll()
        
        movieModeTop5.insert(contentsOf: movieModeSortList, at: 0) //Replace sorted list Players by the new list
        classicModeTop5.insert(contentsOf: classicModeSortList, at: 0)
        
        return ["Movie Mode": movieModeTop5, "Classic Mode": classicModeTop5]
    }
    
    private func sortByScore() {
        movieModeSortList = movieModeSortList.sorted(by: { $0.score > $1.score })
        classicModeSortList = classicModeSortList.sorted(by: { $0.score > $1.score })
    }
    
    
    //MARK: SET SCORE NEW PLAYER
    func setMovieModeScore(name:String, score:Int) {
        if findMovieModePlayer(name: name) == false {
            let player = Player(name, score)
            movieModeSortList.append(player)
            setMovieModeData(list: movieModeSortList)
        }
        else {
            updateMovieModeScore(name: name, score: score)
        }
    }

    func setClassicModeScore(name:String, score:Int) {
        if findClassicModePlayer(name: name) == false {
            let player = Player(name, score)
            classicModeSortList.append(player)
            setClassicModeData(list: classicModeSortList)
        }
        else {
            updateClassicModeScore(name: name, score: score)
        }
    }
    
    //MARK: UPDATE SCORE FOR PLAYER
    func updateMovieModeScore(name: String, score: Int) {     //this function will look for the player with same name
        let list = getMovieModeData()                         //update the score if the new score is higher
        for player in list {
            if player.name == name && player.score < score {
                player.score = score
            }
        }               //Reset the userDefaults Movie Mode scores with the new list
        setMovieModeData(list: list)
    }
    
    
    
    func updateClassicModeScore(name: String, score: Int) {     //this function will look for the player with same name
        let list = getClassicModeData()                         //update the score if the new score is higher
        for player in list {
            if player.name == name && player.score < score {
                player.score = score
            }
        }
        
        //Reset the userDefaults Classic Mode scores with the new list
        setClassicModeData(list: list)
    }
    
    
    //MARK: CHECK PLAYER SCORE
    func checkPlayerScoreForClassic(name: String, score: Int) -> Bool{
        let list = getClassicModeData()
        var scoreIsHigher = false
        
        for player in list {
            if player.name == name && player.score < score {
                scoreIsHigher = true
            }
        }
        
        return scoreIsHigher
    }
    
    func checkPlayerScoreForMovie(name: String, score: Int) -> Bool{
        let list = getMovieModeData()                          
        var scoreIsHigher = false
        
        for player in list {
            if player.name == name && player.score < score {
                scoreIsHigher = true
            }
        }
        
        return scoreIsHigher
    }
    
    //MARK: FIND PLAYER
    func findMovieModePlayer(name: String) -> Bool {
        var exist = false
        for player in getMovieModeData() {
            if player.name == name {
                exist = true
            }
        }
        return exist
    }
    
    func findClassicModePlayer(name: String) -> Bool {
        var exist = false
        for player in getClassicModeData() {
            if player.name == name {
                exist = true
            }
        }
        return exist
    }
    
    
    //MARK: TOP 5 GET LIST
    func getClassicModeData() -> [Player] {     //get Classic Mode Score List from UserDefaults
        var playerList = [Player]()
        if let classicModeData = UserDefaults.standard.data(forKey: "Classic Mode Scores") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode
                playerList = try decoder.decode([Player].self, from: classicModeData)
            } catch {
                print("Unable to Decode Players (\(error))")
            }
        }
        return playerList
    }
    
    
    func getMovieModeData() -> [Player] {       //get Movie Mode Score List from UserDefaults
        var playerList = [Player]()
        if let movieModeData = UserDefaults.standard.data(forKey: "Movie Mode Scores") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode
                playerList = try decoder.decode([Player].self, from: movieModeData)
            } catch {
                print("Unable to Decode Players (\(error))")
            }
        }
        return playerList
    }
    
    
    //MARK: TOP 5 SET LIST
    private func setMovieModeData(list : [Player]) {        //set Movie Mode Score List to UserDefaults
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode
            let movieModeData = try encoder.encode(list)

            // Write/Set Data
            UserDefaults.standard.set(movieModeData, forKey: "Movie Mode Scores")

        } catch {
            print("Unable to Encode Array of Players (\(error))")
        }
    }
    
    private func setClassicModeData(list : [Player]) {      //set Classic Mode Score List to UserDefaults
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode
            let classicModeData = try encoder.encode(list)

            // Write/Set Data
            UserDefaults.standard.set(classicModeData, forKey: "Classic Mode Scores")

        } catch {
            print("Unable to Encode Array of Players (\(error))")
        }
    }
}
