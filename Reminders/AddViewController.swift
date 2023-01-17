//
//  AddViewController.swift
//  Reminders
//
//  Created by Robert Lin on 2023/1/16.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var imageView: UIImageView!
    
    public var completion: ((String, String, Date) -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        bodyTextField.delegate = self

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        if let titleText = titleTextField.text, !titleText.isEmpty,
           let bodyText = bodyTextField.text, !bodyText.isEmpty {
            
            let targetDate = datePicker.date
            
            completion?(titleText, bodyText, targetDate)

        }
    }
    
    @IBAction func didTapNew(_ sender: Any) {
        let urlString = "https://picsum.photos/260/260"
        
        // 讀取欲抓的資料url
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    //主執行緒執行Main thread
                    DispatchQueue.main.sync {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == titleTextField {
            bodyTextField.becomeFirstResponder()
        }
        return true
    }

}
