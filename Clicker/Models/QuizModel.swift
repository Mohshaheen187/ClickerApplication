

import Foundation
struct QuizModel  {
    var question : String?
    var answer : [String]
    var finalAnswer : String?
}

//final quiz is an array of quizmodel

func SaveScore(quiz : String , score : Int){
    UserDefaults.standard.set(score, forKey: quiz)
}
func SaveLastScore(quiz : String , score : Int){
    UserDefaults.standard.set(score, forKey: quiz)
}
func LoadScore(quiz : String) -> Int{
    return UserDefaults.standard.integer(forKey: quiz)
}
