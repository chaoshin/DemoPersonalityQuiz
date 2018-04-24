//
//  QuestionViewController.swift
//  DemoPersonalityQuiz
//
//  Created by Chao Shin on 2018/4/24.
//  Copyright © 2018 Chao Shin. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var questionIndex = 0
    var questions: [Question] = [
        Question(text: "Which food do you like the most?",
                 type: .single,
                 answers:[Answer(text: "steak", type: .dog), Answer(text: "Fish", type: .cat), Answer(text: "Carrots", type: .rabbit), Answer(text: "Corn", type: .turtle)]),
        Question(text: "Which activities do you enjoy?",
                 type: .multipe,
                 answers: [Answer(text: "Swimming", type: .turtle), Answer(text: "Sleeping", type: .cat), Answer(text: "Cuddling", type: .rabbit), Answer(text: "Eating", type: .dog)]),
        Question(text: "How much do you enjoy car rides?",
                 type: .ranged,
                 answers: [Answer(text: "I dislike them", type: .cat), Answer(text: "I get a litte nervous", type: .rabbit), Answer(text: "I barely notice them", type: .turtle), Answer(text: "I love them", type: .dog)])
    ]
    
    var answersChosen: [Answer] = []
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var singleButton1: UIButton!
    @IBOutlet weak var singleButton2: UIButton!
    @IBOutlet weak var singleButton3: UIButton!
    @IBOutlet weak var singleButton4: UIButton!
    
    @IBOutlet weak var multipeStackView: UIStackView!
    @IBOutlet weak var multiLabel1: UILabel!
    @IBOutlet weak var multiLabel2: UILabel!
    @IBOutlet weak var multiLabel3: UILabel!
    @IBOutlet weak var multiLabel4: UILabel!
    
    @IBOutlet weak var multiSwitch1: UISwitch!
    @IBOutlet weak var multiSwitch2: UISwitch!
    @IBOutlet weak var multiSwitch3: UISwitch!
    @IBOutlet weak var multiSwitch4: UISwitch!
    
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    @IBOutlet weak var rangedSlider: UISlider!
    
    
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    func updateSingleStackView(using answer: [Answer]){
        singleStackView.isHidden = false
        singleButton1.setTitle(answer[0].text, for: .normal)
        singleButton2.setTitle(answer[1].text, for: .normal)
        singleButton3.setTitle(answer[2].text, for: .normal)
        singleButton4.setTitle(answer[3].text, for: .normal)
    }
    
    func updateMultipeStackView(using answer: [Answer]) {
        multipeStackView.isHidden = false
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        multiLabel1.text = answer[0].text
        multiLabel2.text = answer[1].text
        multiLabel3.text = answer[2].text
        multiLabel4.text = answer[3].text
    }
    
    func updateRangedStackView(using answer: [Answer]) {
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answer.first?.text
        rangedLabel2.text = answer.last?.text
    }
    
    func updateUI(){    // 更新問題畫面
        singleStackView.isHidden = true
        multipeStackView.isHidden = true
        rangedStackView.isHidden = true
 
        let currentQuestion = questions[questionIndex]
        let currentAnswers = currentQuestion.answers
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        navigationItem.title = "Question #\(questionIndex + 1)" // 更新NavigationBar的問題的Title
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type{
        case .single:
            updateSingleStackView(using: currentAnswers)
        case .multipe:
            updateMultipeStackView(using: currentAnswers)
        case .ranged:
            updateRangedStackView(using: currentAnswers)
        }
    }
    
    func nextQuestion(){
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
    
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
    
    @IBAction func multipleAnswersButtonPress() {
        let currentAnswers = questions[questionIndex].answers
        
        if multiSwitch1.isOn {
            answersChosen.append(currentAnswers[0])
        }
        if multiSwitch2.isOn {
            answersChosen.append(currentAnswers[1])
        }
        if multiSwitch3.isOn {
            answersChosen.append(currentAnswers[2])
        }
        if multiSwitch4.isOn {
            answersChosen.append(currentAnswers[3])
        }
         nextQuestion()
    }
    
    
    
    @IBAction func singleAnswerButtonPress(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        
        switch sender {
        case singleButton1:
            answersChosen.append(currentAnswers[0])
        case singleButton2:
            answersChosen.append(currentAnswers[1])
        case singleButton3:
            answersChosen.append(currentAnswers[2])
        case singleButton4:
            answersChosen.append(currentAnswers[3])
        default:
            break
        }
        nextQuestion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            let resultViewController = segue.destination as! ResultsViewController
            resultViewController.responses = answersChosen
        }
     }

    
}
