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
    @IBOutlet var answer1Label: UILabel!
    @IBOutlet var answer2Label: UILabel!
    @IBOutlet var answer3Label: UILabel!
    @IBOutlet var answer4Label: UILabel!

    var countdownTimer: Timer?
    let countdownStartTime = 5
    var timeRemaining: Int!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        styleAnswerLabels()
        updateQuestion()
    }

    private func styleAnswerLabels() {
        styleLabel(label: answer1Label)
        styleLabel(label: answer2Label)
        styleLabel(label: answer3Label)
        styleLabel(label: answer4Label)
    }

    private func styleLabel(label: UILabel) {
        label.layer.cornerRadius = 30
        label.layer.borderWidth = 10
        label.layer.borderColor = UIColor(hex: 0x666d8d).cgColor
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
            perform(#selector(updateQuestion), with: nil, afterDelay: 4)
        }
    }

    // MARK: - Display

    @objc private func updateQuestion() {
        timeRemaining = countdownStartTime
        timerLabel.text = String(timeRemaining)
        startCountdown()
    }

    private func updateAvailableAnswers() {
        if timeRemaining == 16 {
            // remove first answer
        }
        else if timeRemaining == 7 {
            // remove second answer
        }
        else if timeRemaining == 0 {
            // remove third answer
        }
    }

}

