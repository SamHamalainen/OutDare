//
//  ChallengeDAO.swift
//  outdare
//
//  Created by iosdev on 6.4.2022.
//

import Foundation
import Firebase
import CoreLocation

class ChallengeDAO: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var challenges: [Challenge] = []
    @Published var challenge: Challenge? = nil
    @Published var quiz: Quiz? = nil
    @Published var lyrics: Lyrics? = nil
    
    func convertToChallenge(data: [String:Any]) -> Challenge {
        let id = data["id"] as? Int ?? 0
        let challengeId = data["challengeId"] as? Int ?? 0
        let name = data["name"] as? String ?? "no name"
        let difficulty = data["difficulty"] as? String ?? "easy"
        let category = data["category"] as? String ?? "quiz"
        let description = data["description"] as? String ?? "no description"
        let latitude = data["latitude"] as? Double ?? 0
        let longitude = data["longitude"] as? Double ?? 0
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return Challenge(id: id, challengeId: challengeId, name: name, difficulty: difficulty, category: category, description: description, coordinates: coordinates)
    }
    
    func convertToLyrics (data: [String:Any]) -> Lyrics {
        let id = data["id"] as? Int ?? 0
        let timeLimit = data["timeLimit"] as? Int ?? 0
        let artists = data["artists"] as? [String] ?? []
        let titles = data["titles"] as? [String] ?? []
        let lyrics = data["lyrics"] as? [String] ?? []
        let difficulty = data["difficulty"] as? String ?? ""
        let missingWords = data["missingWords"] as? [String] ?? []
        
        var lyricsData: [LyricsData] = []
        for i in titles.indices {
            var data = LyricsData(timeLimit: timeLimit, artist: artists[i], title: titles[i], lyrics: lyrics[i], missingWords: missingWords[i])
            data.toMultiLine()
            lyricsData.append(data)
        }
        return Lyrics(id: id, difficulty: difficulty, data: lyricsData)
    }
    
    func convertToQuiz(data: [String:Any]) -> Quiz {
        let id = data["id"] as? Int ?? 0
        let timePerQ = data["timePerQ"] as? Double ?? 0
        let questions = data["questions"] as? [String] ?? []
        let correctAns = data["correctAns"] as? [String] ?? []
        let answersFetched = data["answers"] as? [String:[String]] ?? [:]
        let answers = answersFetched.sorted {$0.key < $1.key}.map {$1}
        var quizData: [QuizData] = []
        for i in questions.indices {
            let data = QuizData(question: questions[i], answers: answers[i], correctAns: correctAns[i])
            quizData.append(data)
        }
        return Quiz(id: id, timePerQuestion: timePerQ, data: quizData)
    }
    
    func getChallenges() {
        db.collection("challenges").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let challenge = self.convertToChallenge(data: data)
                    challenges.append(challenge)
                }
            }
        }
    }
    
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
                    case "quiz":
                        self.getQuiz(id: id)
                    case "lyrics":
                        self.getLyrics(id: id)
                    default:
                        return
                    }
                }
            }
        }
    }
    
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
    
    func addAttempt(attempt: Attempt) {
        var ref: DocumentReference? = nil
        let attemptRef = db.collection("attempts")
        attemptRef.addDocument(data: attempt.toDB()) { err in
            if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
        }
    }
}
