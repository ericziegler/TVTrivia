//
//  QuestionList.swift
//  TVTrivia
//
//  Created by Eric Ziegler on 3/23/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import Foundation

// MARK: - Constants

let TriviaURL = "https://opentdb.com"
typealias RequestCompletionBlock = (_ response: JSON?, _ error: Error?) -> ()

// MARK: - Enums

enum TVTriviaError: Error {

    case jsonParsing
    case invalidRequest
    case geocoding

}

class QuestionList {

    // MARK: - Properties

    var questions = [Question]()
    var curQuestionIndex = 0
    var currentQuestion: Question? {
        var result: Question?
        if curQuestionIndex < questions.count {
            result = questions[curQuestionIndex]
        }
        return result
    }

    // MARK: - Load

    func loadQuestionsWith(completion: RequestCompletionBlock?) {
        guard let request = self.buildRequestFor(fileName: "api.php", params: ["amount" : "30", "difficulty" : "easy", "type" : "multiple"]) else {
            completion?(nil, TVTriviaError.invalidRequest)
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            let result = self.buildJSONResponse(data: data, error: error)
            self.removeDisplayedQuestions()
            self.curQuestionIndex = 0
            if let json = result.0 {
                if let questionsJSON = json.dictionaryValue["results"]?.arrayValue {
                    for curQuestionJSON in questionsJSON {
                        let question = Question()
                        question.load(json: curQuestionJSON)
                        if question.text.count > 0 {
                            self.questions.append(question)
                        }
                    }
                    completion?(result.0, result.1)
                } else {
                    completion?(nil, TVTriviaError.jsonParsing)
                }
            } else {
                completion?(result.0, result.1)
            }
        }
        task.resume()
    }

    // MARK: Convenience Functions

    private func buildRequestFor(fileName: String, params: [String : String]) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(TriviaURL)/\(fileName)") else {
            return nil
        }

        var queryItems = [URLQueryItem]()
        for (curKey, curValue) in params {
            queryItems.append(URLQueryItem(name: curKey, value: curValue))
        }
        urlComponents.queryItems = queryItems

        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }

        return nil
    }

    private func buildJSONResponse(data: Data?, error: Error?) -> (JSON?, Error?) {
        var result: (JSON?, Error?)?
        if let error = error {
            result = (nil, error)
        } else {
            if let data = data {
                guard let json = try? JSON(data: data) else {
                    return (nil, TVTriviaError.jsonParsing)
                }
                result = (json, nil)
            } else {
                result = (nil, TVTriviaError.jsonParsing)
            }
        }
        if let result = result {
            return result
        } else {
            return (nil, TVTriviaError.jsonParsing)
        }
    }

     private func removeDisplayedQuestions() {
        for (i, curQuestion) in questions.enumerated().reversed() {
            if curQuestion.hasDisplayed == true {
                questions.remove(at: i)
            }
        }
    }
    
}
