//
//  AboutUserOneViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/11/2020.
//

import UIKit
import Firebase

class AboutUserOneViewController: UIViewController {
    
    
    @IBOutlet weak var agePicker: UIDatePicker!
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var courseYearSeg: UISegmentedControl!
    
    @IBOutlet weak var ContinueButton: UIButton!
    // User details
    var DOB = ""
    var Course = ""
    var CourseYR = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coursePicker.dataSource = self
        coursePicker.delegate = self
        
        ContinueButton.layer.cornerRadius = 5
    }
    
    func CourseYear() -> String{
        var year = ""
        
        switch courseYearSeg.selectedSegmentIndex {
        case 0:
            year = "1st year"
        case 1:
            year = "2nd Year"
        case 2:
            year = "3rd Year"
        case 3:
            year = "4th Year"
        case 4:
            year = "Other"
            
        default:
            print("Nothing picked")
        }
        
        return year
    }
    
    
    
    @IBAction func continuePressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "DD/MM/YYYY"
        formatter.timeStyle = .none
        
        
        DOB = formatter.string(from: agePicker.date)
        let cy = CourseYear()
        CourseYR = String(cy)
        
        // Stores the users age in userDefaults
        let now = Date()
        let birthday: Date = agePicker.date
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        Constants.defaults.setValue(age, forKey: "Age")
        
        
        // Confirm details, if correct,Save to Database and transfer user to next page
        let alert = UIAlertController(title: "Confirm your details", message: "Your Date of Birth is: \(DOB). \n Your Course is: \(Course). \n Your currently in your \(CourseYR)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Correct", style: .default)
        { action -> Void in
            
            Constants.db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "DOB": self.DOB,
                "Course": self.Course,
                "Course Year": self.CourseYR,
                
            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            self.performSegue(withIdentifier: "AboutYouTwo", sender: self)
        })
        alert.addAction(UIAlertAction(title: "Incorrect", style: .destructive, handler: nil))
        self.present(alert, animated: true)
        
        
    }
    
    
}

extension AboutUserOneViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.courses.count
    }
    
    
    
}

extension AboutUserOneViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.courses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Course = Constants.courses[row]
        
    }
}
