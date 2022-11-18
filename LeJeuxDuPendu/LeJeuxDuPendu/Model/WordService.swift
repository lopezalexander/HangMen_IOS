//
//  WordService.swift
//  LeJeuxDuPendu
//
//  Created by Edgardo Alexander Lopez (Étudiant) on 3/5/1401 AP.
//

import Foundation

class WordService{
    
    static var shared = WordService()
    
    private static let classicURL = "https://random-word-api.herokuapp.com/word"
    private static let movieURL = "http://www.omdbapi.com/?apikey=dfcb1a8e"
    
    private var task: URLSessionDataTask?
    
    private init(){}
    
    // MARK: GET CLASSIC WORD
    func getClassicWord( callback: @escaping (Bool, ClassicWord?) -> Void ){
        
        //Construct Request Parameters
        let randomInt = Int.random(in: 5..<10)
        let randomLength = String(randomInt);
        let URLparams = "?length=\(randomLength)"
        
        //My API URL String
        let requestURL =  WordService.classicURL + URLparams
        
        //Set URLRequest
        let request = URLRequest(url: URL(string: requestURL)!)
         
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
 
                guard let responseJSON = try? JSONDecoder().decode([String].self, from: data) else{
                    callback(false, nil)
                    return
                }
                
                let word: ClassicWord = ClassicWord(title: responseJSON[0])
                
                callback(true, word)
            }
        }
        
        //Start Task
        task?.resume()
    }
    
    
    // MARK: GET MOVIE TITLE
    
    func getMovieWord(callback: @escaping (Bool, MovieWord?) -> Void ){
        
        //Construct Request Parameters
        let randomInt = Int.random(in: 1..<55252)
        
        
        let randomTitle = String(format: "%05d", randomInt)
         
        
        
        let URLparamsID = "&i=tt00\(randomTitle)"
        
        //My API URL String
        let requestURL =  WordService.movieURL + URLparamsID
        
       
        //Set URLRequest
        let request = URLRequest(url: URL(string: requestURL)!)
        //let request = URLRequest(url: URL(string: "http://www.omdbapi.com/?apikey=dfcb1a8e&i=tt1860242")!)
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
 
                guard let responseJSON = try? JSONDecoder().decode(MovieWord.self, from: data) else{
                    callback(false, nil)
                    return
                }
                
                let word: MovieWord = MovieWord(Title: responseJSON.Title,
                                                Year: responseJSON.Year,
                                                Rated: responseJSON.Rated,
                                                Released: responseJSON.Released,
                                                Genre: responseJSON.Genre,
                                                Director: responseJSON.Director,
                                                Actors: responseJSON.Actors)
                 
                
                
                callback(true, word)
            }
            
        }
        
        //Start Task
        task?.resume()
        
    }
    
    
    
    
    
     
}
