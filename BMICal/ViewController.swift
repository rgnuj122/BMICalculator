//
//  ViewController.swift
//  BMICal
//
//  Created by 許廷綺 on 2018/6/10.
//  Copyright © 2018 許廷綺. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var height_input: UITextField!
    @IBOutlet weak var weight_input: UITextField!
    @IBOutlet weak var age_input: UITextField!
    @IBOutlet weak var gender_segment: UISegmentedControl!
    @IBAction func calClick(_ sender: Any) {
        guard let heightText = height_input.text, let height = Float(heightText) else {
            resultShow.text = "please input correct height"
            return
        }
        guard let weightText = weight_input.text, let weight = Float(weightText) else {
            resultShow.text = "please input correct weight"
            return
        }
        guard let ageText = age_input.text, let age = Int(ageText) else {
            resultShow.text = "please input correct age"
            return
        }
        let gender = gender_segment.selectedSegmentIndex
        let bmi = getBMI(height: height/100, weight: weight)
        resultShow.text = checkBMIResult(age: age, gender: gender, bmi: bmi)
        
    }
    
    @IBOutlet weak var resultShow: UILabel!
    
    func setupKB(){
        let toolbar = UIToolbar()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKB))
        toolbar.items = [doneBtn]
        toolbar.sizeToFit()
        height_input.inputAccessoryView = toolbar
        weight_input.inputAccessoryView = toolbar
        age_input.inputAccessoryView = toolbar
        
    }
    @objc func hideKB() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let bmi = getBMI(height: 1.6, weight: 70.0)
//        let str_bmi = checkBMIResult(age: 22, gender: 1, bmi: getBMI(height: 1.6, weight: 70.0))
        
//        let bmi = getBMI(height: Float(height_input.text)!/100, weight: Float(weight_input.text)!)
//        let str_bmi = checkBMIResult(age: Int(age_input)!, gender: gender_segment, bmi: bmi)
//        print("bmi: \(bmi)...\(str_bmi)")
        setupKB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getBMI(height: Float, weight: Float) -> Float {
//        let bmi = weight / height / height
        let bmi = weight / pow(height, 2.0)
        
        return round(bmi*10)/10
    }
    //gender 0:female 1:male
    func checkBMIResult(age: Int, gender: Int, bmi: Float) -> String {
        guard age < 18 else{
            //adult
            switch bmi {
            case ..<18.5:
                return "BMI:\(bmi) 「體重過輕」，需要多運動，均衡飲食，以增加體能，維持健康！"
            case ..<24:
                return "BMI:\(bmi) 恭喜！「健康體重」，要繼續保持！"
            case ..<27:
            return "BMI:\(bmi) 「體重過重」了，要小心囉，趕快力行「健康體重管理」！"
            case 27...:
                return "BMI:\(bmi) 啊～「肥胖」，需要立刻力行「健康體重管理」囉！"
            default:
                return "BMI error"
            }
        }
        //teenager
        let range = ChildBMI.getRange(age: age, gender: gender)
        switch bmi {
        case ..<range[0]:
            return "BMI:\(bmi) [過輕]「體重過輕」，需要多運動，均衡飲食，以增加體能，維持健康！"
        case ..<range[1]:
            return "BMI:\(bmi) 「正常」恭喜！「健康體重」，要繼續保持！"
        case ..<range[2]:
            return "BMI:\(bmi) 「過重」「體重過重」了，要小心囉，趕快力行「健康體重管理」！"
        case range[2]...:
            return "BMI:\(bmi) 「肥胖」啊～「肥胖」，需要立刻力行「健康體重管理」囉！"
        default:
            return "BMI error"
        }
    }
}

