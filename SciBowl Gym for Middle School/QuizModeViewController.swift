//
//  QuizModeViewController.swift
//  SciBowl Gym for Middle School
//
//  Created by Jake Polatty on 7/11/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import Foundation
import RichTextView
import UIKit

extension Question {
    func getAnswerLetter() -> String {
        return String(self.answer.first!)
    }
}

class QuizModeViewController: UIViewController, UIScrollViewDelegate {
    var category: Category?
    var statsTracker: QuizModeStats?
    @objc var seconds: Int = 0
    @objc var tossupTime: Int = 0
    @objc var bonusTime: Int = 0
    @objc var timer = Timer()
    var question: Question?
    @objc var contentOffset: CGFloat = 0
    @objc var scrollView: UIScrollView = UIScrollView()
    
    @objc lazy var finishSetButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Back Chevron"), for: .normal)
        button.setTitle(" Finish Set", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
        button.sizeToFit()
        button.addTarget(self, action: #selector(QuizModeViewController.finishSet), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    @objc lazy var nextQuestionButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Forward Chevron"), for: .normal)
        button.setTitle("Next ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
        button.sizeToFit()
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.addTarget(self, action: #selector(QuizModeViewController.loadNextQuestion), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    @objc lazy var roundSetNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let setNumber = self.question?.setNumber, let roundNumber = self.question?.roundNumber {
            label.text = "Question Set \(setNumber) Round \(roundNumber)"
        }
        return label
    }()
    
    @objc lazy var questionNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let questionNumber = self.question?.questionNumber, let questionType = self.question?.questionType {
            label.text = "Question \(questionNumber) \(questionType)"
        }
        return label
    }()
    
    @objc lazy var catTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let category = self.question?.category, let answerType = self.question?.answerType {
            label.text = "\(category) \(answerType)"
        }
        return label
    }()
    
    @objc lazy var questionTextLabel: UIView = {
        let label = RichTextView(
            font: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium),
            textColor: UIColor.white,
            frame: CGRect.zero
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.update(input: self.question?.questionText)
        return label
    }()
    
    @objc lazy var optionWButton: UIButton = {
        let label = RichTextView(
            font: UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light),
            textColor: UIColor.white,
            frame: CGRect.zero
        )
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.update(input: self.question?.answerChoices?[0])

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(QuizModeViewController.selectOptionW), for: .touchUpInside)

        button.addSubview(label)
        button.bringSubviewToFront(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -6),
            button.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        ])
        
        return button
    }()

    @objc lazy var optionXButton: UIButton = {
        let label = RichTextView(
            font: UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light),
            textColor: UIColor.white,
            frame: CGRect.zero
        )
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.update(input: self.question?.answerChoices?[1])
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(QuizModeViewController.selectOptionX), for: .touchUpInside)

        button.addSubview(label)
        button.bringSubviewToFront(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -6),
            button.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        ])
        
        return button
    }()
    
    @objc lazy var optionYButton: UIButton = {
        let label = RichTextView(
            font: UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light),
            textColor: UIColor.white,
            frame: CGRect.zero
        )
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.update(input: self.question?.answerChoices?[2])
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(QuizModeViewController.selectOptionY), for: .touchUpInside)

        button.addSubview(label)
        button.bringSubviewToFront(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -6),
            button.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        ])
        
        return button
    }()
    
    @objc lazy var optionZButton: UIButton = {
        let label = RichTextView(
            font: UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light),
            textColor: UIColor.white,
            frame: CGRect.zero
        )
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.update(input: self.question?.answerChoices?[3])

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(QuizModeViewController.selectOptionZ), for: .touchUpInside)

        button.addSubview(label)
        button.bringSubviewToFront(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -6),
            button.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        ])

        return button
    }()
    
    @objc lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.thin)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        label.text = "\(self.seconds) Seconds Left"
        return label
    }()
    
    init(category: Category?, stats: QuizModeStats?, tossupTime: Int, bonusTime: Int) {
        self.category = category
        if category != nil {
            self.question = QuestionJSONParser.shared.getMCQuestionForCategory(category)
        } else {
            self.question = QuestionJSONParser.shared.getMCQuestion()
        }
        self.statsTracker = stats
        self.tossupTime = tossupTime
        self.bonusTime = bonusTime
        if self.question?.questionType == .tossup {
            self.seconds = tossupTime
        } else {
            self.seconds = bonusTime
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = finishSetButton
        self.navigationItem.title = "Quiz Mode"
        scrollView.delegate = self
        runTimer()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(red: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(roundSetNumLabel)
        NSLayoutConstraint.activate([
            roundSetNumLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            roundSetNumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        scrollView.addSubview(questionNumLabel)
        NSLayoutConstraint.activate([
            questionNumLabel.topAnchor.constraint(equalTo: roundSetNumLabel.bottomAnchor, constant: 10),
            questionNumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(catTypeLabel)
        NSLayoutConstraint.activate([
            catTypeLabel.topAnchor.constraint(equalTo: questionNumLabel.bottomAnchor, constant: 10),
            catTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(questionTextLabel)
        NSLayoutConstraint.activate([
            questionTextLabel.topAnchor.constraint(equalTo: catTypeLabel.bottomAnchor, constant: 10),
            questionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        scrollView.addSubview(optionWButton)
        NSLayoutConstraint.activate([
            optionWButton.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 10),
            optionWButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            optionWButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        scrollView.addSubview(optionXButton)
        NSLayoutConstraint.activate([
            optionXButton.topAnchor.constraint(equalTo: optionWButton.bottomAnchor, constant: 7),
            optionXButton.leadingAnchor.constraint(equalTo: optionWButton.leadingAnchor),
            optionXButton.trailingAnchor.constraint(equalTo: optionWButton.trailingAnchor),
        ])
        
        scrollView.addSubview(optionYButton)
        NSLayoutConstraint.activate([
            optionYButton.topAnchor.constraint(equalTo: optionXButton.bottomAnchor, constant: 7),
            optionYButton.leadingAnchor.constraint(equalTo: optionXButton.leadingAnchor),
            optionYButton.trailingAnchor.constraint(equalTo: optionXButton.trailingAnchor),
        ])
        
        scrollView.addSubview(optionZButton)
        NSLayoutConstraint.activate([
            optionZButton.topAnchor.constraint(equalTo: optionYButton.bottomAnchor, constant: 7),
            optionZButton.leadingAnchor.constraint(equalTo: optionYButton.leadingAnchor),
            optionZButton.trailingAnchor.constraint(equalTo: optionYButton.trailingAnchor),
        ])
        
        scrollView.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: optionZButton.bottomAnchor, constant: 30)
        ])
        
        let height = timerLabel.frame.origin.y + 20.5 + 30
        if height <= scrollView.frame.height {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: height)
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentOffset = CGPoint(x: 0, y: contentOffset)
    }
    
    @objc func finishSet() {
        let statsController = QuizModeStatsViewController(stats: statsTracker, category: category)
        navigationController?.pushViewController(statsController, animated: true)
    }
    
    @objc func disableButtons() {
        optionWButton.isUserInteractionEnabled = false
        optionXButton.isEnabled = false
        optionYButton.isEnabled = false
        optionZButton.isEnabled = false
        timer.invalidate()
    }
    
    @objc func makeCorrectAnswerButtonGreen() {
        let answerletter = question?.getAnswerLetter()
        if answerletter == "W" {
            optionWButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else if answerletter == "X" {
            optionXButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else if answerletter == "Y" {
            optionYButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else if answerletter == "Z" {
            optionZButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        }
    }
    
    @objc func optionSelected() {
        disableButtons()
        makeCorrectAnswerButtonGreen()
        self.navigationItem.rightBarButtonItem = nextQuestionButton
    }
    
    @objc func selectOptionW() {
        optionSelected()
        timerLabel.isHidden = true
        if question?.getAnswerLetter() == "W" {
            statsTracker?.numberCorrect += 1
        } else {
            optionWButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
            statsTracker?.numberIncorrect += 1
        }
    }
    
    @objc func selectOptionX() {
        optionSelected()
        timerLabel.isHidden = true
        if question?.getAnswerLetter() == "X" {
            statsTracker?.numberCorrect += 1
        } else {
            optionXButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
            statsTracker?.numberIncorrect += 1
        }
    }
    
    @objc func selectOptionY() {
        optionSelected()
        timerLabel.isHidden = true
        if question?.getAnswerLetter() == "Y" {
            statsTracker?.numberCorrect += 1
        } else {
            optionYButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
            statsTracker?.numberIncorrect += 1
        }
    }
    
    @objc func selectOptionZ() {
        optionSelected()
        timerLabel.isHidden = true
        if question?.getAnswerLetter() == "Z" {
            statsTracker?.numberCorrect += 1
        } else {
            optionZButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
            statsTracker?.numberIncorrect += 1
        }
    }
    
    @objc func loadNextQuestion() {
        let nextQuestionController = QuizModeViewController(category: category, stats: statsTracker, tossupTime: tossupTime, bonusTime: bonusTime)
        navigationController?.pushViewController(nextQuestionController, animated: true)
    }
    
    @objc func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(QuizModeViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds == 1 {
            timerLabel.text = "Time's Up"
            statsTracker?.numberNotAnswered += 1
            optionSelected()
        } else {
            seconds -= 1
            timerLabel.text = "\(seconds) Seconds Left"
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffset = scrollView.contentOffset.y
    }
}
