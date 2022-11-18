//
//  GameEngine.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 3/4/1401 AP.
//

import Foundation

class GameEngine{
    enum gameMode: String {
        case classic, movie
    }
    
    enum alphabetChecker: String, CaseIterable {
        case a = "a",b = "b",c = "c",d = "d",e = "e",f = "f",g = "g",h = "h",i = "i",j = "j",k = "k",
             l = "l",m = "m",n = "n",o = "o",p = "p",q = "q",r = "r",s = "s",t = "t",u = "u",v = "v",
             w = "w",x = "x",y = "y",z = "z"
     }
    
    var modeChosen: gameMode
    var errorCount: Int
    var wordArray: [String]
    var wordChecker: [OrderedWord]
    
    var classicWord: ClassicWord{
        didSet{
            if classicWord.title != "" {
                setWordArray(word: classicWord.title)
                createWordCheckList(word: classicWord.title)
            }
        }
    }
    
    var movieWord: MovieWord{
        didSet{
            if movieWord.Title != "" {
                setWordArray(word: movieWord.Title)
                createWordCheckList(word: movieWord.Title)
            }
        }
    }
    
    
    init(){
        modeChosen = .classic
        errorCount = 0
        classicWord = ClassicWord(title: "")
        movieWord = MovieWord(Title: "", Year: "", Rated: "", Released: "", Genre: "", Director: "", Actors: "")
        wordArray = [String]()
        wordChecker = [OrderedWord]()
    }
    
    
    //MARK: TRY LETTER
    
    func tryLetter(letterInput: String) -> Bool {
        var validLetter = false
        
        if modeChosen == .classic {
            if classicWord.title.lowercased().contains(letterInput){
                validLetter = true
            }
        }
        else if modeChosen == .movie {
            if movieWord.Title.lowercased().contains(letterInput){
                validLetter = true
            }
        }
        
        if validLetter{
            //Update wordChecker
            var counter = 0
            for letter in wordChecker{
                if letter.letter == letterInput {
                    wordChecker[counter].status = true
                }
                counter += 1
            }
        }
        else{
            //Increase errorCount
            increaseErrorCount()
        }
        
        return validLetter
    }
    
    // MARK: VIEW CONTROLLER UTILITIES
    func getWordCount(mode: gameMode) -> Int{
        var letterCount: Int = 0
        
        if mode == .classic {
            letterCount = classicWord.title.count
        }
        else if mode == .movie {
            var spaceCounter = 0
            
            for item in wordChecker{
                if item.letter == " " {
                    spaceCounter += 1
                }
            }
            
            letterCount =  movieWord.Title.count
            letterCount -= spaceCounter
        }
        
        return letterCount
    }
    
    func isGameWon() -> Bool{
        var gameIsWon = true
        
        for letter in wordChecker{
            if letter.status == false {
                gameIsWon = false
            }
        }
        
        return gameIsWon
    }
    
    func isGameOVer() -> Bool{
        var gameIsOver = false
        
        if errorCount == 6 {
            gameIsOver = true
        }
        
        return gameIsOver
    }
    
    func getLiveString() -> String {
        var showLives = ""
        
        for i in 1...6{
            if i <= errorCount{
                showLives += "X "
            }
            else{
                showLives += "O "
            }
                
        }
        
        return showLives
        
    }
    
    func getHintx2() -> String{
        return "Released in \(movieWord.Released)"
    }
    
    func getHintx4() -> String{
        return "Rated: \(movieWord.Rated)    Genre: \(movieWord.Genre)"
    }
    
    func getHintx5() -> String{
        return "Director: \(movieWord.Director) \nActor: \(movieWord.Actors)"
    }
    
    
    func resetGameValue(){
        errorCount = 0
        classicWord = ClassicWord(title: "")
        movieWord = MovieWord(Title: "", Year: "",Rated: "", Released: "", Genre: "", Director: "", Actors: "")
        wordArray = [String]()
        wordChecker = [OrderedWord]()
    }
    
    //MARK: HIDDEN WORD
    
    func getUpdatedHiddenWord() -> String{
        var updatedHiddenWord = ""
        
        for letter in wordChecker{
            if letter.status == true {
                updatedHiddenWord += "\(letter.letter.uppercased()) "
            }
            else{
                updatedHiddenWord += "_ "
            }
        }
        
        return updatedHiddenWord
    }
    
    
    
    //MARK: ARRAYS // (PRIVATE)
    
    private func setWordArray(word: String){
        if word != ""{
            let splittedWord = Array(word)
            for index in 0...(word.count - 1){
                wordArray.append(String(splittedWord[index]).lowercased())
            }
        }
    }
    
    private func createWordCheckList(word: String){
        if word != ""{
            var validChar = false
            
            for letter in wordArray {
                
                for alphabet in alphabetChecker.allCases{
                    if letter == alphabet.rawValue{
                        validChar = true
                        break
                    }
                }
                
                if validChar{
                    wordChecker.append(OrderedWord(letter: letter, status: false))
                }
                else{
                    wordChecker.append(OrderedWord(letter: letter, status: true))
                }
                
                validChar = false
            }
        }
        
        print(movieWord.Title)
        print(wordChecker)
        
        print("------------")
        print(wordArray)
        
    }
    
    private func increaseErrorCount(){
        errorCount += 1
    }
    
    
    
    
}
