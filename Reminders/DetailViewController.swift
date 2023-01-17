//
//  DetailViewController.swift
//  Reminders
//
//  Created by Robert Lin on 2023/1/17.
//

import UIKit

class DetailViewController: UIViewController {
    
    var reminder: MyReminder?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = reminder?.title
//        fetchImage()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateLabel.text = formatter.string(from: reminder!.date)
        bodyLabel.text = reminder?.body
    }
    
    func fetchImage(){
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
}
