//
//  ChallengeDAO.swift
//  outdare
//
//  Created by iosdev on 6.4.2022.
//  Description: ChallengeDAO handles fetches from database concerning the challenges.

import Foundation
import Firebase
import CoreLocation
import MapKit

class ChallengeDAO: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var challenges: [Challenge] = []
    @Published var challenge: Challenge? = nil
    @Published var quiz: Quiz? = nil
    @Published var lyrics: Lyrics? = nil
    @Published var twister: Twister? = nil
    @Published var annotations: [MKPointAnnotation] = []
    @Published var challengeAdded = false
    
    // Convert challenge into a MKPointAnnotation and add it to array of annotations so the MapView can show them on the map
    func challengeToAnnotation(challenges: [Challenge]) {
        challenges.forEach { challenge in
            let annotation = MKPointAnnotation()
            annotation.coordinate = challenge.coordinates
            annotation.title = "\(challenge.name)"
            annotation.subtitle = challenge.icon
            annotations.append(annotation)
        }
    }
    
    // Updating the color of the annotation based on the distance from the users location
    // Color when distance is maximum 150 meters
    // Gray when distance is more than 150 meters
    func updateAnnotationsBasedOnDistance(userLoc: CLLocationCoordinate2D, annotationsArray: [MKPointAnnotation]) -> [MKPointAnnotation] {
        let newAnnotations: [MKPointAnnotation] = annotationsArray.map { annotation in
            let isInRadius = userLoc.distance(to: annotation.coordinate) <= 150
            let wasGray = annotation.subtitle!.contains("-gray")
            var subtitle = ""
            
            // if originally gray bring back color when inRadius again
            if wasGray {
                if isInRadius {
                    subtitle = annotation.subtitle!.components(separatedBy: "-gray")[0]
                } else {
                    subtitle = annotation.subtitle!
                }
            } else {
                // otherwise turn them back to gray
                if isInRadius {
                    subtitle = annotation.subtitle!
                } else {
                    subtitle = annotation.subtitle! + "-gray"
                }
            }
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = annotation.coordinate
            newAnnotation.title = annotation.title
            newAnnotation.subtitle = subtitle
            return newAnnotation
        }
        return newAnnotations
    }
    
    // Convert data from the database into a Challenge struct
    func convertToChallenge(data: [String:Any]) -> Challenge {
        let id = data["id"] as? Int ?? 0
        let challengeId = data["challengeId"] as? Int ?? 0
        let name = data["name"] as? String ?? "no name"
        let difficulty = data["difficulty"] as? String ?? ""
        let difficultyEnum = ChallengeDifficulty(rawValue: difficulty) ?? .easy
        let category = data["category"] as? String ?? ""
        let categoryEnum = ChallengeCategory(rawValue: category) ?? .string
        let description = data["description"] as? String ?? "no description"
        let latitude = data["latitude"] as? Double ?? 0
        let longitude = data["longitude"] as? Double ?? 0
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return Challenge(id: id, challengeId: challengeId, name: name, difficulty: difficultyEnum, category: categoryEnum, description: description, coordinates: coordinates)
    }
    
    // Convert data from the database into Lyrics struct for the "Finish the lyrics" - challenge
    func convertToLyrics (data: [String:Any]) -> Lyrics {
        let id = data["id"] as? Int ?? 0
        let timeLimit = data["timeLimit"] as? Int ?? 0
        let artists = data["artists"] as? [String] ?? []
        let titles = data["titles"] as? [String] ?? []
        let lyrics = data["lyrics"] as? [String] ?? []
        let difficulty = data["difficulty"] as? String ?? ""
        let difficultyEnum = ChallengeDifficulty(rawValue: difficulty) ?? .easy
        let missingWords = data["missingWords"] as? [String] ?? []
        
        var lyricsData: [LyricsData] = []
        for i in titles.indices {
            var data = LyricsData(timeLimit: timeLimit, artist: artists[i], title: titles[i], lyrics: lyrics[i], missingWords: missingWords[i])
            data.toMultiLine()
            lyricsData.append(data)
        }
        return Lyrics(id: id, difficulty: difficultyEnum, data: lyricsData)
    }
    
    // Convert data from the database into Quiz struct for the "Quiz" - challenge
    func convertToQuiz(data: [String:Any]) -> Quiz {
        let id = data["id"] as? Int ?? 0
        let timePerQ = data["timePerQ"] as? Double ?? 0
        let questions = data["questions"] as? [String] ?? []
        let correctAns = data["correctAns"] as? [String] ?? []
        let difficulty = data["difficulty"] as? String ?? ""
        let difficultyEnum = ChallengeDifficulty(rawValue: difficulty) ?? .easy
        let answersFetched = data["answers"] as? [String:[String]] ?? [:]
        let answers = answersFetched.sorted {$0.key < $1.key}.map {$1}
        var quizData: [QuizData] = []
        for i in questions.indices {
            let data = QuizData(question: questions[i], answers: answers[i], correctAns: correctAns[i])
            quizData.append(data)
        }
        return Quiz(id: id, timePerQuestion: timePerQ, data: quizData, difficulty: difficultyEnum)
    }
    
    // Convert data from the database into Twister struct for the "Tongue Twister" - challenge
    func convertToTwister(data: [String:Any]) -> Twister {
        let id = data["id"] as? Int ?? 0
        let texts = data["texts"] as? [String] ?? []
        let timeLimits = data["timeLimits"] as? [Int] ?? []
        let difficulty = data["difficulty"] as? String ?? ""
        let difficultyEnum = ChallengeDifficulty(rawValue: difficulty) ?? .easy
        var twisterData: [TwisterData] = []
        for i in texts.indices {
            let data = TwisterData(timeLimit: timeLimits[i], text: texts[i])
            twisterData.append(data)
        }
        return Twister(id: id, difficulty: difficultyEnum, data: twisterData)
    }
    
    // Get all the challenges from the database and convert them into annotations.
    // SnapshotListener is listening when new challenges are created.
    // It will automatically get all challenges and update annotations.
    func getChallenges() {
        db.collection("challenges").addSnapshotListener() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var newChallenges: [Challenge] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let challenge = self.convertToChallenge(data: data)
                    newChallenges.append(challenge)
                }
                self.challenges = newChallenges
                challengeToAnnotation(challenges: newChallenges)
            }
        }
    }
    
    // Get a certain challenge from the database
    func getChallenge(id: Int) {
        let challengeRef = db.collection("challenges")
        let query = challengeRef.whereField("id", isEqualTo: id)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                let challenge = self.convertToChallenge(data: document.data())
                self.challenge = challenge
                if let id = self.challenge?.challengeId, let category = self.challenge?.category {
                    switch category {
                    case .quiz:
                        self.getQuiz(id: id)
                    case .lyrics:
                        self.getLyrics(id: id)
                    case .twister:
                        self.getTwister(id: id)
                    default:
                        return
                    }
                }
            }
        }
    }
    
    // Get quiz details from the database with an id and convert it to a Quiz struct
    func getQuiz(id: Int) {
        let quizRef = db.collection("quizzes")
        let query = quizRef.whereField("id", isEqualTo: id)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                let quiz = self.convertToQuiz(data: document.data())
                self.quiz = quiz
            }
        }
    }
    // Get lyrics details from the database with an id and convert it to a Lyrics struct
    func getLyrics(id: Int) {
        let quizRef = db.collection("lyrics")
        let query = quizRef.whereField("id", isEqualTo: id)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                let lyrics = self.convertToLyrics(data: document.data())
                self.lyrics = lyrics
            }
        }
    }
    
    // Get tongue twister details from the database with an id and convert it to a Twister struct
    func getTwister(id: Int) {
        let quizRef = db.collection("twisters")
        let query = quizRef.whereField("id", isEqualTo: id)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                let twister = self.convertToTwister(data: document.data())
                self.twister = twister
            }
        }
    }
    
    // After completing challenges, purchasing coins, walking or revealing challenges
    // an attempt will be added to the database.
    func addAttempt(attempt: Attempt) {
        let attemptRef = db.collection("attempts")
        var data = attempt.toDB()
        data["data"] = Timestamp()
        attemptRef.addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added!")
            }
        }
    }
    
    // When using the Quiz Generator to generate a quiz, this function will add it to the database
    func addChallenge(challenge: Challenge) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            fatalError("Cannot get UID")
        }
        let challengeRef = db.collection("challenges")
        let query = challengeRef.order(by: "id", descending: true).limit(to: 1)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                guard let id = document.data()["id"] as? Int else {
                    return
                }
                let newId = id + 1
                print("newId", newId)
                challengeRef.addDocument(data: [
                    "category": challenge.category.rawValue,
                    "challengeId": challenge.challengeId,
                    "description": challenge.description,
                    "difficulty": challenge.difficulty.rawValue,
                    "id": newId,
                    "latitude": Double(challenge.coordinates.latitude),
                    "longitude": Double(challenge.coordinates.longitude),
                    "name": challenge.name,
                    "creator": String(uid),
                    "created": Timestamp(),
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Challenge added: \(newId) \(challenge.name)")
                        self.challengeAdded = true
                    }
                }
            }
        }
    }
    
    // This function takes in an array of trivia questions and maps them into questions and answers
    // Then adds the data to the database using addChallenge function
    func addQuiz(triviaQuestions: [TriviaQuestion], title: String, description: String = "", coords: CLLocationCoordinate2D) {
        let quizRef = db.collection("quizzes")
        let query = quizRef.order(by: "id", descending: true).limit(to: 1)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                guard let id = document.data()["id"] as? Int else {
                    return
                }
                let newId = id + 1
                print("newId", newId)
                let questions = triviaQuestions.map { $0.question }
                let correctAns = triviaQuestions.map { $0.correct_answer }
                let answers = triviaQuestions.map { $0.getAllAnswers() }
                let answersDict = Dictionary(uniqueKeysWithValues: answers.indices.map { (String($0), answers[$0]) })
                let difficulty = triviaQuestions[0].difficulty
                let difficultyEnum = ChallengeDifficulty(rawValue: difficulty) ?? .easy
                
                quizRef.addDocument(data: [
                    "id": newId,
                    "answers": answersDict,
                    "correctAns": correctAns,
                    "difficulty": difficulty,
                    "timePerQ": 13,
                    "questions": questions
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Quiz added: \(newId)")
                        self.addChallenge(challenge: Challenge(id: -1, challengeId: newId, name: title, difficulty: difficultyEnum, category: .quiz, description: description, coordinates: coords))
                    }
                }
            }
        }
    }
    
}
