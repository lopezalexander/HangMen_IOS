//
//  OnGoingGameViewController.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 2022-05-25.
//

import UIKit

class OnGoingGameViewController: UIViewController{
    // MARK: VARIABLES
    var GameEngine: GameEngine!
    
    
    //NewGame Variables
    let default_wordLength = "Word Length:"
    let default_lives = "O O O O O O"
    let default_letterUsed = ""
    let default_hintx2 = ""
    let default_hintx4 = ""
    let default_hintx5 = ""
    let default_hiddenWord = ""
    let default_hintBody = ""
    
    
    //Interfaces Variables
    @IBOutlet weak var imagePendu: UIImageView!
    
    @IBOutlet weak var label_wordLength: UILabel!
    @IBOutlet weak var label_lives: UILabel!
    
    @IBOutlet weak var label_letterUsed: UILabel!
    
    @IBOutlet weak var button_hintx2: UIButton!
    @IBOutlet weak var button_hintx4: UIButton!
    @IBOutlet weak var button_hintx5: UIButton!
    
    @IBOutlet weak var label_hintBody: UILabel!
    
    @IBOutlet weak var label_hiddenWord: UILabel!
    
    @IBOutlet var keyboardCollection: [UIButton]!
    
    // MARK: VIEW LOADED
    override func viewDidLoad() {
        GameEngine.resetGameValue()
        print("PlayerList")
        print(UserDefaults.standard.data(forKey: "Classic Mode Scores") as Any)
        print("CurrentPlayer = \(Statistic.shared.currentPlayer)")
        
        //Disble all buttons
        for button in keyboardCollection {
            button.isEnabled = false
        }
        
        //OnGoingGameViewController -> Set the view for a New Game
        if GameEngine.modeChosen  == .classic {
            WordService.shared.getClassicWord { (success, word) in

                guard let word = word, success == true else{
                    //self.presentAlert()
                    return
                }

                //Set Word to GameEngine
                self.GameEngine.classicWord = word


                //Re-enable Buttons
                for button in self.keyboardCollection {
                    button.isEnabled = true
                }

                //Set New Game
                self.newGame(gameMode: self.GameEngine.modeChosen)
            }//End API CALL for MOVIE
        }
        else if GameEngine.modeChosen  == .movie {
            WordService.shared.getMovieWord { (success, word) in

                guard let word = word, success == true else{
                    //self.presentAlert()
                    return
                }

                //Set Word to GameEngine
                self.GameEngine.movieWord = word


                //Re-enable Buttons
                for button in self.keyboardCollection {
                    button.isEnabled = true
                }

                //Set New Game
                self.newGame(gameMode: self.GameEngine.modeChosen)
            }//End API CALL for MOVIE
        }//End ModeSelected
    }//End ViewDidLoad()
    
    
    //MARK: TRY LETTER
    @IBAction func tryLetter(_ sender: UIButton) {
        //Disable the button
        sender.isEnabled = false
        
        //Current Button LETTER
        let buttonLetter = sender.currentTitle!.lowercased()
        
        //Test if letter in the word
        let validLetter  = GameEngine.tryLetter(letterInput: buttonLetter)
        
        //Action based on Valid Letter or NOT
        if validLetter{
            //Update label_hiddenWord
            let newHiddenWord = GameEngine.getUpdatedHiddenWord()
            label_hiddenWord.text = newHiddenWord
            
            //Check if GameWon
            let gameWon = GameEngine.isGameWon()
            
            print("    ")
            print("    ")
            print("GAMEWON")
            print(GameEngine.errorCount)
            print(gameWon)
            
            //MARK: GAMEWON
            if gameWon {
                var playerFound = false
                let playerName = Statistic.shared.currentPlayer
                
                print("playerFound = \(playerFound)" )
                print("playerName = \(playerName)" )
                 
                if GameEngine.modeChosen == .classic {
                    playerFound = Statistic.shared.findClassicModePlayer(name: playerName)
                }
                else  if GameEngine.modeChosen == .movie {
                    playerFound = Statistic.shared.findMovieModePlayer(name: playerName)
                }
                
                print("PlayerFoundCheck = \(playerFound)")
                
                //MARK: PLAYER FOUND
                if playerFound {
                    //Check if higher score
                    var haveHigherScore = false
                    
                    if GameEngine.modeChosen == .classic {
                        haveHigherScore = Statistic.shared.checkPlayerScoreForClassic(name: playerName, score: (6 - self.GameEngine.errorCount))
                    }
                    else  if GameEngine.modeChosen == .movie {
                        haveHigherScore = Statistic.shared.checkPlayerScoreForMovie(name: playerName, score: (6 - self.GameEngine.errorCount))
                    }
                    
                    
                    //MARK: PLAYER HIGHSCORE
                    if haveHigherScore {
                        //Show PROMPT "YOU WON"
                        let alert = UIAlertController(title: "You WON!! HIGHSCORE!!", message: "Enter your name: ", preferredStyle: .alert)
                        
                        alert.addTextField { (textField) in
                            textField.placeholder = ""
                        }
                        
                        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
                            
                            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                            
                            //UPDATE SCORE LIST
                            if self.GameEngine.modeChosen == .classic {
                                Statistic.shared.updateClassicModeScore(name: userText, score:  (6 - self.GameEngine.errorCount))
                            }
                            else  if self.GameEngine.modeChosen == .movie {
                                Statistic.shared.updateMovieModeScore(name: userText, score: (6 - self.GameEngine.errorCount))
                            }
                            
                            //RESET GAME
                            self.dismiss(animated:true, completion: nil)
                             
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        

                    }
                    else{
                        //MARK: NO HIGHSCORE
                        //Show PROMPT "YOU WON", sadly no highscore
                        let alert = UIAlertController(title: "You WON!!", message: "But you don't have highscore", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:{(_) in
                            
                            //RESET GAME
                            self.dismiss(animated:true, completion: nil)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }//END HIGHSCORE
                }
                else{
                    //MARK: NEW PLAYER
                    //Show prompt YOU WIN  and ask for playerName
                    let alert = UIAlertController(title: "You WON!! HIGHSCORE!!", message: "Enter your name: ", preferredStyle: .alert)
                    
                    
                    alert.addTextField { (textField) in
                        textField.placeholder = ""
                    }
                    
                    alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
                        
                        guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                        
                        //UPDATE SCORE LIST
                        if self.GameEngine.modeChosen == .classic {
                            Statistic.shared.setClassicModeScore(name: userText, score: (6 - self.GameEngine.errorCount))
                            print("WENT INTO CLASSIC" + userText)
                        }
                        else  if self.GameEngine.modeChosen == .movie {
                            Statistic.shared.setMovieModeScore(name: userText, score: (6 - self.GameEngine.errorCount))
                        }
                        
                        Statistic.shared.currentPlayer = userText
                        
                        //RESET GAME
                        self.dismiss(animated:true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }//END PLAYER FOUND
            }//END GAME WON
        }
        else{
            // MARK: WRONG LETTER
            
            //Increase errorCount +1
            //-> it is handled by GameEngine privately already
            
            //Update label_LetterUsed
            if let oldValue = label_letterUsed.text {
                label_letterUsed.text = oldValue + "\(buttonLetter.uppercased())  "
                 
            }
           
            //Update imagePendu
            let errorCount = GameEngine.errorCount
            
            switch errorCount {
                case 1:
                    imagePendu.image = UIImage(named: "1Faute")
                case 2:
                    imagePendu.image = UIImage(named: "2Faute")
                    button_hintx2.isEnabled = true
                case 3:
                    imagePendu.image = UIImage(named: "3Faute")
                case 4:
                    imagePendu.image = UIImage(named: "4Faute")
                    button_hintx4.isEnabled = true
                case 5:
                    imagePendu.image = UIImage(named: "5Faute")
                    button_hintx5.isEnabled = true
                case 6:
                    imagePendu.image = UIImage(named: "6Faute")
                default:
                    imagePendu.image = UIImage(named: "0Faute")
            }
            
            //Update label_lives >> Have f(x)
            label_lives.text = GameEngine.getLiveString()
            
            //Check if GameOver
            let gameOver = GameEngine.isGameOVer()
            
            //MARK: GAMEOVER
            if gameOver {
                let alert = UIAlertController(title: "You LOST!!", message: "Better Luck Next Time! \nTry Again!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:{(_) in
                    
                    //RESET GAME
                    self.dismiss(animated:true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }//END VALID LETTER
        
    }//END TRY LETTER
    

    
    
    
    
    
    
    //MARK: NEW GAME
    //Set the View for a New Game
    private func newGame(gameMode: GameEngine.gameMode){

        //Set the First Image
        imagePendu.image = UIImage(named: "0Faute")
        print(GameEngine.classicWord.title)
        
        //Get the word or film if/else on gameMode
        let letterCount = GameEngine.getWordCount(mode: gameMode)
        
        //Set Label for WordLength
        label_wordLength.text = "Word Length: \(letterCount)"
        
        //Set Label for UsedLetter
        label_letterUsed.text = default_letterUsed
        
        
        //Set Label for Lives
        label_lives.text = default_lives
        
        //Set Label for HiddenWord
        label_hiddenWord.text = GameEngine.getUpdatedHiddenWord()
        
        //Set Label for HintBody
        label_hintBody.text = default_hintBody
        
        
        
    }
    
    
    
    func resetGame(){
        //Reset all view to default
        
    }
    
    
    
    func restartGame(){
        //Fetch another word & Start a new game
    }
    
    //MARK: BUTTON ACTION
    
    @IBAction func showHintx2(_ sender: Any) {
        print("x2 activated")
        print(GameEngine.getHintx2())
        label_hintBody.text = GameEngine.getHintx2()
    }
    
    @IBAction func showHintx4(_ sender: Any) {
        print("x2 activated")
        print(GameEngine.getHintx4())
        label_hintBody.text = GameEngine.getHintx4()
    }
    
    @IBAction func showHintx5(_ sender: Any) {
        print("x2 activated")
        print(GameEngine.getHintx5())
        label_hintBody.text = GameEngine.getHintx5()
    }
    
    @IBAction func exitGame(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }
    
    
}



