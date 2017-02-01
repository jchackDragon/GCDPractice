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
    
    
    // This method downloads a huge image, blocking the main queue and
    // the UI.
    // This si for instructional purposes only, never do this.
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
    
    
    // This method avoids blocking by creating a new queue that runs
    // in the background, without blocking the UI.
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
    
    // This code downloads the huge image in a global queue and uses a completion
    // closure.
    @IBAction func asynchronousDownloadWithScapinClosure(_ sender: UIBarButtonItem){
        
        withBigImage { (image) in
            self.photoImage.image = image
            self.activityIndicator.stopAnimating()
        }
    }
    
    // This method downloads and image in the background once it's
    // finished, it runs the closure it receives as a parameter.
    // This closure is called a completion handler
    // Go download the image, and once you're done, do _this_ (the completion handler)
    func withBigImage(complaitionHandler handler: @escaping (_ image: UIImage) -> Void){
        
        self.activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async{
            
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

