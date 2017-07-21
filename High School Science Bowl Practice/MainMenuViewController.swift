//
//  MainMenuViewController.swift
//  High School Science Bowl Practice
//
//  Created by David Polatty on 7/20/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "High School Science Bowl Practice"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 39.0, weight: UIFontWeightHeavy)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var quizModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Quiz Mode", for: .normal)
        button.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightLight)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(MainMenuViewController.startQuizMode), for: .touchUpInside)
        return button
    }()
    
    lazy var readerModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reader Mode", for: .normal)
        button.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightLight)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(MainMenuViewController.startReaderMode), for: .touchUpInside)
        return button
    }()
    
    lazy var studyModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Study Mode", for: .normal)
        button.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightLight)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(MainMenuViewController.startStudyMode), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(header)
        NSLayoutConstraint.activate([
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
        
        view.addSubview(quizModeButton)
        NSLayoutConstraint.activate([
            quizModeButton.widthAnchor.constraint(equalToConstant: 150),
            quizModeButton.heightAnchor.constraint(equalToConstant: 44),
            quizModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quizModeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(readerModeButton)
        NSLayoutConstraint.activate([
            readerModeButton.widthAnchor.constraint(equalToConstant: 150),
            readerModeButton.heightAnchor.constraint(equalToConstant: 44),
            readerModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readerModeButton.topAnchor.constraint(equalTo: quizModeButton.bottomAnchor, constant: 30)
        ])
        
        view.addSubview(studyModeButton)
        NSLayoutConstraint.activate([
            studyModeButton.widthAnchor.constraint(equalToConstant: 150),
            studyModeButton.heightAnchor.constraint(equalToConstant: 44),
            studyModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            studyModeButton.topAnchor.constraint(equalTo: readerModeButton.bottomAnchor, constant: 30)
        ])
    }
    
    func startQuizMode() {
        let quizSettingsController = QuizSettingsViewController()
        let navigationController = UINavigationController(rootViewController: quizSettingsController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func startReaderMode() {
        let readerSettingsController = ReaderSettingsViewController()
        let navigationController = UINavigationController(rootViewController: readerSettingsController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func startStudyMode() {
        let studySettingsController = StudySettingsViewController()
        let navigationController = UINavigationController(rootViewController: studySettingsController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
