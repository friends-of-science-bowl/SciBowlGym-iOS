//
//  StudySettingsViewController.swift
//  SciBowl Gym for Middle School
//
//  Created by Jake Polatty on 7/18/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import UIKit

class StudySettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @objc let pickerData = [
        ["All Rounds", "Round 1", "Round 2", "Round 3", "Round 4", "Round 5", "Round 6", "Round 7", "Round 8", "Round 9", "Round 10", "Round 11", "Round 12", "Round 13", "Round 14", "Round 15", "Round 16", "Round 17"]
    ]
    @objc static let lightGrey = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
    @objc static let darkGrey = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
    var category: Category?
    @objc var scrollView: UIScrollView = UIScrollView()
    
    @objc lazy var mainMenuButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Back Chevron"), for: .normal)
        button.setTitle(" Menu", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
        button.sizeToFit()
        button.addTarget(self, action: #selector(StudySettingsViewController.returnMainMenu), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    @objc lazy var topicHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose a Topic:"
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        return label
    }()
    
    @objc lazy var biologyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Life Science", for: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.lightGrey, forState: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.darkGrey, forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(StudySettingsViewController.toggleBiology), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var generalScienceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("General Science", for: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.lightGrey, forState: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.darkGrey, forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(StudySettingsViewController.togglegeneralScience), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var earthAndSpaceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Earth and Space", for: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.lightGrey, forState: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.darkGrey, forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(StudySettingsViewController.toggleEarthAndSpace), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var energyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Energy", for: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.lightGrey, forState: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.darkGrey, forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(StudySettingsViewController.toggleEnergy), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var mathButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Mathematics", for: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.lightGrey, forState: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.darkGrey, forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(StudySettingsViewController.toggleMath), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var physicsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Physical Science", for: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.lightGrey, forState: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.darkGrey, forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(StudySettingsViewController.togglePhysics), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var randomHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Or Generate Random Questions:"
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        return label
    }()
    
    @objc lazy var randomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Random", for: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.lightGrey, forState: .normal)
        button.setBackgroundColor(color: StudySettingsViewController.darkGrey, forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.isSelected = true
        button.addTarget(self, action: #selector(StudySettingsViewController.toggleRandom), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var roundHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "And Select a Round:"
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        return label
    }()
    
    @objc lazy var roundPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        picker.layer.cornerRadius = 10
        return picker
    }()
    
    @objc lazy var startSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Set", for: .normal)
        button.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 63.0/255.0, alpha: 0.5)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(StudySettingsViewController.startStudyMode), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = mainMenuButton
        self.navigationItem.title = "Study Mode"
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(red: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        roundPicker.delegate = self
        roundPicker.dataSource = self
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
        
        scrollView.addSubview(topicHeader)
        NSLayoutConstraint.activate([
            topicHeader.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            topicHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(biologyButton)
        NSLayoutConstraint.activate([
            biologyButton.widthAnchor.constraint(equalToConstant: 130),
            biologyButton.heightAnchor.constraint(equalToConstant: 44),
            biologyButton.topAnchor.constraint(equalTo: topicHeader.bottomAnchor, constant: 7),
            biologyButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15)
        ])
        
        scrollView.addSubview(generalScienceButton)
        NSLayoutConstraint.activate([
            generalScienceButton.widthAnchor.constraint(equalToConstant: 130),
            generalScienceButton.heightAnchor.constraint(equalToConstant: 44),
            generalScienceButton.topAnchor.constraint(equalTo: topicHeader.bottomAnchor, constant: 7),
            generalScienceButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 15)
        ])
        
        scrollView.addSubview(earthAndSpaceButton)
        NSLayoutConstraint.activate([
            earthAndSpaceButton.widthAnchor.constraint(equalToConstant: 130),
            earthAndSpaceButton.heightAnchor.constraint(equalToConstant: 44),
            earthAndSpaceButton.topAnchor.constraint(equalTo: biologyButton.bottomAnchor, constant: 10),
            earthAndSpaceButton.leadingAnchor.constraint(equalTo: biologyButton.leadingAnchor)
        ])
        
        scrollView.addSubview(energyButton)
        NSLayoutConstraint.activate([
            energyButton.widthAnchor.constraint(equalToConstant: 130),
            energyButton.heightAnchor.constraint(equalToConstant: 44),
            energyButton.topAnchor.constraint(equalTo: generalScienceButton.bottomAnchor, constant: 10),
            energyButton.trailingAnchor.constraint(equalTo: generalScienceButton.trailingAnchor)
        ])
        
        scrollView.addSubview(mathButton)
        NSLayoutConstraint.activate([
            mathButton.widthAnchor.constraint(equalToConstant: 130),
            mathButton.heightAnchor.constraint(equalToConstant: 44),
            mathButton.topAnchor.constraint(equalTo: earthAndSpaceButton.bottomAnchor, constant: 10),
            mathButton.leadingAnchor.constraint(equalTo: earthAndSpaceButton.leadingAnchor)
        ])
        
        scrollView.addSubview(physicsButton)
        NSLayoutConstraint.activate([
            physicsButton.widthAnchor.constraint(equalToConstant: 130),
            physicsButton.heightAnchor.constraint(equalToConstant: 44),
            physicsButton.topAnchor.constraint(equalTo: energyButton.bottomAnchor, constant: 10),
            physicsButton.trailingAnchor.constraint(equalTo: energyButton.trailingAnchor),
        ])
        
        scrollView.addSubview(randomHeader)
        NSLayoutConstraint.activate([
            randomHeader.topAnchor.constraint(equalTo: mathButton.bottomAnchor, constant: 10),
            randomHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(randomButton)
        NSLayoutConstraint.activate([
            randomButton.widthAnchor.constraint(equalToConstant: 130),
            randomButton.heightAnchor.constraint(equalToConstant: 44),
            randomButton.topAnchor.constraint(equalTo: randomHeader.bottomAnchor, constant: 7),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(roundHeader)
        NSLayoutConstraint.activate([
            roundHeader.topAnchor.constraint(equalTo: randomButton.bottomAnchor, constant: 10),
            roundHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(roundPicker)
        NSLayoutConstraint.activate([
            roundPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            roundPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            roundPicker.topAnchor.constraint(equalTo: roundHeader.bottomAnchor, constant: 10),
            roundPicker.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        scrollView.addSubview(startSetButton)
        NSLayoutConstraint.activate([
            startSetButton.widthAnchor.constraint(equalToConstant: 120),
            startSetButton.heightAnchor.constraint(equalToConstant: 44),
            startSetButton.topAnchor.constraint(equalTo: roundPicker.bottomAnchor, constant: 40),
            startSetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let height = startSetButton.frame.origin.y + startSetButton.frame.height + 30
        if height <= scrollView.frame.height {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: height)
        }
    }
    
    @objc func startStudyMode() {
        let category = getCategoryForToggle()
        let roundNumber = roundPicker.selectedRow(inComponent: 0)
        let studyController = StudyModeViewController(category: category, round: roundNumber)
        navigationController?.pushViewController(studyController, animated: true)
    }
    
    @objc func returnMainMenu() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Toggle Button Handlers
    
    @objc func toggleOff() {
        biologyButton.isSelected = false
        generalScienceButton.isSelected = false
        earthAndSpaceButton.isSelected = false
        energyButton.isSelected = false
        mathButton.isSelected = false
        physicsButton.isSelected = false
        randomButton.isSelected = false
    }
    
    @objc func toggleBiology() {
        toggleOff()
        biologyButton.isSelected = true
        category = Category.biology
    }
    
    @objc func togglegeneralScience() {
        toggleOff()
        generalScienceButton.isSelected = true
        category = Category.generalScience
    }
    
    @objc func toggleEarthAndSpace() {
        toggleOff()
        earthAndSpaceButton.isSelected = true
        category = Category.earthAndSpace
    }
    
    @objc func toggleEnergy() {
        toggleOff()
        energyButton.isSelected = true
        category = Category.energy
    }
    
    @objc func toggleMath() {
        toggleOff()
        mathButton.isSelected = true
        category = Category.mathematics
    }
    
    @objc func togglePhysics() {
        toggleOff()
        physicsButton.isSelected = true
        category = Category.physics
    }
    
    @objc func toggleRandom() {
        toggleOff()
        randomButton.isSelected = true
        category = nil
    }
    
    func getCategoryForToggle() -> Category? {
        if biologyButton.isSelected {
            return Category.biology
        } else if generalScienceButton.isSelected {
            return Category.generalScience
        } else if earthAndSpaceButton.isSelected {
            return Category.earthAndSpace
        } else if energyButton.isSelected {
            return Category.energy
        } else if mathButton.isSelected {
            return Category.mathematics
        } else if physicsButton.isSelected {
            return Category.physics
        } else {
            return nil
        }
    }
    
    // MARK: - Picker Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    // MARK: - Picker Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerData[component][row]
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
            pickerLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.regular)
        }
        let title = pickerData[component][row]
        pickerLabel?.text = title
        pickerLabel?.textColor = UIColor.white
        return pickerLabel!
    }
}
