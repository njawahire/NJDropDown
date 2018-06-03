//
//  ViewController.swift
//  NJDropDown
//
//  Created by njawahire on 06/03/2018.
//  Copyright (c) 2018 njawahire. All rights reserved.
//

import UIKit
import NJDropDown

class ViewController: UIViewController,NJDropDownDelegate {
    
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    var dropdown:NJDropDown! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownLabel.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dropDownSelected(sender:)))
        
        dropDownLabel.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dropDownSelected(sender:AnyObject){
        if(dropdown == nil){
            var arr = NSArray();
            let f = 80
            arr = NSArray(objects:"Hello 0", "Hello 1", "Hello 2", "Hello 3", "Hello 4", "Hello 5", "Hello 6", "Hello 7", "Hello 8", "Hello 9")
            var arrImage = NSArray()
            arrImage = NSArray(objects:UIImage(named: "apple.png")!,UIImage(named: "apple2.png")!, UIImage(named: "apple.png")!,UIImage(named: "apple2.png")!, UIImage(named: "apple.png")!,UIImage(named: "apple2.png")!, UIImage(named: "apple.png")!,UIImage(named: "apple2.png")!, UIImage(named: "apple.png")!,UIImage(named: "apple2.png")!)
            var button: UIView! = nil
            if(sender.isKind(of: UITapGestureRecognizer.self)){
                let recognizer = sender as! UITapGestureRecognizer
                button = recognizer.view
            } else{
                button = sender as! UIView
                
            }
            
            dropdown = NJDropDown.init(frame: dropDownButton.frame).showDropDown(b: button, height: CGFloat(f), arr: arr, imgArr: arrImage, direction: "down", viewController: self)
            dropdown.delegate = self
            self.view.addSubview(dropdown)
        } else{
            dropdown.hideDropDown(b: sender as! UIView)
            dropdown = nil
        }
    }
    
    func njDropDownDelegateMethod(sender: NJDropDown) {
        
    }
    
    func njDropDownDelegateMethod(sender: UIView, title: String) {
        if(sender == dropDownLabel){
            dropDownLabel.text = title
        }
    }
    
    func njDropDownHidden() {
        dropdown = nil
    }
    
}



