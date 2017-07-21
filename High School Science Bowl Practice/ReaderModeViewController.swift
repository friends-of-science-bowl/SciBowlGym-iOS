//
//  ReaderModeViewController.swift
//  High School Science Bowl Practice
//
//  Created by Jake Polatty on 7/18/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import UIKit

class ReaderModeViewController: UIViewController {
    var questionSet: [Question]?
    var index: Int = 0
    var seconds: Int = 10
    var timer = Timer()
    var isTimerRunning = false
    
    lazy var mainMenuButton: UIBarButtonItem? = {
        let button = UIBarButtonItem(title: "Main Menu", style: .plain, target: self, action: #selector(StudyModeViewController.returnMainMenu))
        return button
    }()
    
    lazy var nextQuestionButton: UIBarButtonItem = {
        let count = self.questionSet?.count ?? 0
        let button: UIBarButtonItem
        if self.index == count - 1 {
            button = UIBarButtonItem(title: "Finish Set", style: .done, target: self, action: #selector(ReaderModeViewController.finishSet))
        } else {
            button = UIBarButtonItem(title: "Next Question", style: .plain, target: self, action: #selector(ReaderModeViewController.loadNextQuestion))
        }
        return button
    }()
    
    lazy var roundSetNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightLight)
        label.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let roundNum = self.questionSet?[self.index].roundNumber, let setNum = self.questionSet?[self.index].setNumber {
            label.text = "Question Set \(setNum) Round \(roundNum)"
        }
        return label
    }()
    
    lazy var questionNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightLight)
        label.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let questionNum = self.questionSet?[self.index].questionNumber, let questionType = self.questionSet?[self.index].questionType {
            label.text = "Question \(questionNum) \(questionType)"
        }
        return label
    }()
    
    lazy var catTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightLight)
        label.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let category = self.questionSet?[self.index].category, let answerType = self.questionSet?[self.index].answerType {
            label.text = "\(String(describing: category)) \(String(describing: answerType))"
        }
        return label
    }()
    
    lazy var questionTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightMedium)
        label.textColor = UIColor.white
        if let questionText = self.questionSet?[self.index].questionText {
            label.text = questionText
        }
        return label
    }()
    
    lazy var answerOptionsLabel: UILabel? = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightSemibold)
        label.textColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        if let answerChoices = self.questionSet?[self.index].answerChoices {
            if answerChoices.count > 0 {
                label.text = "\(answerChoices[0])\n\(answerChoices[1])\n\(answerChoices[2])\n\(answerChoices[3])"
                return label
            } else {
                return nil
            }
        } else {
            return nil
        }
    }()
    
    lazy var questionAnswerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightHeavy)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.95)
        if let answerText = self.questionSet?[self.index].answer {
            label.text = "Answer: \(answerText)"
        }
        return label
    }()
    
    lazy var startTimerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Timer", for: .normal)
        button.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 1.0, blue: 63.0/255.0, alpha: 0.5)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ReaderModeViewController.startTimerPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightThin)
        label.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        label.isHidden = true
        label.text = "\(self.seconds) Seconds Left"
        return label
    }()
    
    init(questionSet: [Question], index: Int) {
        self.questionSet = questionSet
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = nextQuestionButton
        self.navigationItem.leftBarButtonItem = mainMenuButton
        self.navigationItem.title = "Reader Mode"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(roundSetNumLabel)
        NSLayoutConstraint.activate([
            roundSetNumLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 30),
            roundSetNumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(questionNumLabel)
        NSLayoutConstraint.activate([
            questionNumLabel.topAnchor.constraint(equalTo: roundSetNumLabel.bottomAnchor, constant: 10),
            questionNumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(catTypeLabel)
        NSLayoutConstraint.activate([
            catTypeLabel.topAnchor.constraint(equalTo: questionNumLabel.bottomAnchor, constant: 10),
            catTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(questionTextLabel)
        NSLayoutConstraint.activate([
            questionTextLabel.topAnchor.constraint(equalTo: catTypeLabel.bottomAnchor, constant: 10),
            questionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(questionAnswerLabel)
        NSLayoutConstraint.activate([
            questionAnswerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            questionAnswerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionAnswerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(startTimerButton)
        NSLayoutConstraint.activate([
            startTimerButton.widthAnchor.constraint(equalToConstant: 120),
            startTimerButton.heightAnchor.constraint(equalToConstant: 44),
            startTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startTimerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        
        if let answerOptionsLabel = answerOptionsLabel {
            view.addSubview(answerOptionsLabel)
            NSLayoutConstraint.activate([
                answerOptionsLabel.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 20),
                answerOptionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                answerOptionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        }
    }
    
    func loadNextQuestion() {
        if let questionSet = questionSet {
            let nextQuestionController = ReaderModeViewController(questionSet: questionSet, index: index+1)
            navigationController?.pushViewController(nextQuestionController, animated: true)
        }
    }
    
    func returnMainMenu() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func finishSet() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func startTimerPressed() {
        runTimer()
        startTimerButton.isHidden = true
        timerLabel.isHidden = false
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ReaderModeViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            timerLabel.text = "Time's Up"
        } else {
            seconds -= 1
            timerLabel.text = "\(seconds) Seconds Left"
        }
    }
}
