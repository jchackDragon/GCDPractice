//
//  ViewController.swift
//  GCDPractice
//
//  Created by Juan Carlos Lopez on 12/31/16.
//  Copyright © 2016 Juan Carlos Lopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    enum images:String {
        case santa = "https://static.pexels.com/photos/253366/pexels-photo-253366.jpeg"
        case vote = "https://static.pexels.com/photos/240561/pexels-photo-240561.jpeg"
        case fox = "https://static.pexels.com/photos/59842/fox-red-fox-red-portrait-59842.jpeg"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //This method will going to stop the Main thread
    @IBAction func synchronousDownload(_ sender: UIBarButtonItem) {
        
        self.photoImage.image = nil
        self.activityIndicator.startAnimating()
       
        if let url = URL(string:images.santa.rawValue),
           let data = try? Data(contentsOf:url),
           let image = UIImage(data:data){
        
            self.photoImage.image = image
        }
        
        self.activityIndicator.stopAnimating()
    
    }
    
    
    //Creating async queue to run proces in background
    @IBAction func asynchronousDownload(_ sender: UIBarButtonItem){
        
       self.photoImage.image = nil
       self.activityIndicator.startAnimating()
        
       let queue = DispatchQueue(label: "downloadQueue")
        
        queue.async { (Void) in
            
            if let url = URL(string:images.fox.rawValue),
                let data = try? Data(contentsOf:url){

            DispatchQueue.main.async{
                let image = UIImage(data:data)
                self.photoImage.image = image
                self.activityIndicator.stopAnimating()
            }
            }
            
        }
        
        
    }
    
    //Using asycn queue and ecaping closure to run process in background
    @IBAction func asynchronousDownloadWithScapinClosure(_ sender: UIBarButtonItem){
        
        withBigImage { (image) in
            self.photoImage.image = image
            self.activityIndicator.stopAnimating()
        }
    }
    
    func withBigImage(complaitionHandler handler: @escaping (_ image: UIImage) -> Void){
        
        self.activityIndicator.startAnimating()
        
        DispatchQueue(label:"dowloadQueue").async{
            
            if let url = URL(string:images.vote.rawValue),
                let data = try? Data(contentsOf:url){
                
                DispatchQueue.main.async{
                    let image = UIImage(data:data)!
                    handler(image)
                }
            }
        }
    }
   
    @IBAction func changeOpacity(_ sender: UISlider) {
        self.photoImage.alpha = CGFloat(sender.value)
    }


}

