//
//  Question.swift
//  TVTrivia
//
//  Created by Eric Ziegler on 3/23/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import Foundation

class Question {

    // MARK: - Properties

    var text = ""
    var answers = [Answer]()
    var hasDisplayed = false

    // MARK: - Loading

    func load(json: JSON) {
        let dict = json.dictionaryValue
        if let value = dict["question"]?.stringValue {
            text = value.replacingEscapeCharacters()
        }
        if let incorrectAnswers = dict["incorrect_answers"]?.arrayValue {
            for curIncorrectAnswer in incorrectAnswers {
                let answer = Answer()
                answer.text = curIncorrectAnswer.stringValue.replacingEscapeCharacters()
                answers.append(answer)
            }
        }
        if let value = dict["correct_answer"]?.stringValue {
            let answer = Answer()
            answer.text = value.replacingEscapeCharacters()
            answer.isCorrect = true
            answers.append(answer)
        }
        answers.shuffle()
    }

    // MARK: - Helpers

    func randomIncorrectAnswerIndex() -> Int {
        var result = Int.random(in: 0 ..< answers.count)
        while answers[result].isCorrect == true {
            result = Int.random(in: 0 ..< answers.count)
        }
        return result
    }

}

class Answer {

    // MARK: - Properties

    var text = ""
    var isCorrect = false

}
