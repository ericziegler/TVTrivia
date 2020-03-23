//
//  MainController.swift
//  TVTrivia
//
//  Created by Eric Ziegler on 3/22/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    // MARK: - Properties

    @IBOutlet var triviaView: UIView!
    @IBOutlet var timerView: UIView!
    @IBOutlet var questionView: UIView!
    @IBOutlet var answersView: UIView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answer1View: UIView!
    @IBOutlet var answer2View: UIView!
    @IBOutlet var answer3View: UIView!
    @IBOutlet var answer4View: UIView!
    @IBOutlet var answer1Label: UILabel!
    @IBOutlet var answer2Label: UILabel!
    @IBOutlet var answer3Label: UILabel!
    @IBOutlet var answer4Label: UILabel!

    var countdownTimer: Timer?
    let countdownStartTime = 25
    var timeRemaining: Int!
    let questionList = QuestionList()
    var hiddenAnswerIndices = [Int]()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        styleAnswerViews()
        questionList.loadQuestionsWith { [unowned self] (json, error) in
            DispatchQueue.main.async {
                self.updateQuestion()
            }
        }
    }

    private func styleAnswerViews() {
        styleAnswerView(answer1View)
        styleAnswerView(answer2View)
        styleAnswerView(answer3View)
        styleAnswerView(answer4View)
    }

    private func styleAnswerView(_ answerView: UIView) {
        answerView.layer.cornerRadius = 30
        answerView.layer.borderWidth = 10
        answerView.layer.borderColor = UIColor(hex: 0x009ca6).cgColor
    }

    // MARK: - Countdown Timer

    func startCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    func endCountdown() {
        countdownTimer?.invalidate()
    }

    @objc func updateCountdown() {
        timeRemaining -= 1
        if timeRemaining > -1 {
            timerLabel.text = String(timeRemaining)
            updateAvailableAnswers()
        } else {
            endCountdown()
            questionList.curQuestionIndex += 1
            perform(#selector(updateQuestion), with: nil, afterDelay: 4)
        }
    }

    // MARK: - Display

    @objc private func updateQuestion() {
        if let question = questionList.currentQuestion {
            resetAnswerLabels()
            timeRemaining = countdownStartTime
            timerLabel.text = String(timeRemaining)
            startCountdown()
            questionLabel.text = question.text
            for i in 0 ..< question.answers.count {
                let answerLabel = labelForAnswerIndex(i)
                answerLabel.text = question.answers[i].text
            }
            if questionList.curQuestionIndex > questionList.questions.count - 5 {
                questionList.loadQuestionsWith { (json, error) in
                    question.hasDisplayed = true
                }
            }
        }
    }

    private func updateAvailableAnswers() {
        if timeRemaining == 16  || timeRemaining == 7 || timeRemaining == 0 {
            if let question = questionList.currentQuestion {
                var index = question.randomIncorrectAnswerIndex()
                while hiddenAnswerIndices.contains(index) {
                    index = question.randomIncorrectAnswerIndex()
                }
                hiddenAnswerIndices.append(index)
                UIView.animate(withDuration: 0.2) {
                    let answerView = self.viewForAnswerIndex(index)
                    answerView.alpha = 0
                }
            }
        }
    }

    private func resetAnswerLabels() {
        hiddenAnswerIndices.removeAll()
        for i in 0 ..< 4 {
            let answerView = viewForAnswerIndex(i)
            answerView.alpha = 1
        }
    }

    private func labelForAnswerIndex(_ index: Int) -> UILabel {
        if index == 0 {
            return answer1Label
        }
        else if index == 1 {
            return answer2Label
        }
        else if index == 2 {
            return answer3Label
        } else {
            return answer4Label
        }
    }

    private func viewForAnswerIndex(_ index: Int) -> UIView {
        if index == 0 {
            return answer1View
        }
        else if index == 1 {
            return answer2View
        }
        else if index == 2 {
            return answer3View
        } else {
            return answer4View
        }
    }

}

