//
//  NJDropDown.swift
//  NJDropDown
//
//  Created by njawahire on 06/03/2018.
//  Copyright (c) 2018 njawahire. All rights reserved.
//
//

import UIKit

public protocol NJDropDownDelegate{
    func njDropDownDelegateMethod(sender:NJDropDown)
    func njDropDownDelegateMethod(sender:UIView, title:String)
    func njDropDownHidden()
}
public class NJDropDown: UIView, UITableViewDelegate, UITableViewDataSource {
    let SCREEN_BOUND = UIScreen.main.bounds
    let DEFAULT_ALIGNMENT = 5
    var table = UITableView()
    var btnSender = UIView()
    var list = NSArray()
    var imageList = NSArray()
    var dropDownViewController = UIViewController()
    var backgroundButton = UIButton()
    var dropDownItemTextAlignment: NSTextAlignment! = nil
    var itemBackgroundColor:UIColor?=nil
    var itemTextColor:UIColor? = nil
    var itemSelectionColor:UIColor? = nil
    var itemSelectionTextColor:UIColor? = nil
    var tableSeparatorColor:UIColor? = nil
    var tableBackgroundColor:UIColor? = nil
    var backgroundDimViewColor:UIColor? = nil
    var backgroundDimViewAlpha:CGFloat! = nil
    public var delegate: NJDropDownDelegate! = nil
    var animationDirection = String()
    var imgView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showDropDown(b:UIView, height:CGFloat, arr:NSArray, imgArr:NSArray, direction: String, viewController:UIViewController) ->  NJDropDown{
        btnSender = b
        self.dropDownItemTextAlignment = NSTextAlignment.center;
        animationDirection = direction;
        //        self.table = super.init()
        self.dropDownViewController = viewController;
        // Initialization code
        let btn = b.frame;
        
        self.list = NSArray.init(array: arr)
        self.imageList = NSArray.init(array:imgArr)
        if (direction == "up") {
            self.frame = CGRect(x: btn.origin.x, y: btn.origin.y, width: btn.size.width, height: 0)
            self.layer.shadowOffset = CGSize(width: -5, height: -5)
        }else if (direction == "down") {
            self.frame = CGRect(x: btn.origin.x, y: btn.origin.y + btn.size.height, width: btn.size.width, height: 0)
            self.layer.shadowOffset = CGSize(width: -5, height: 5)
        }
        
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = UITableView.init(frame: CGRect(x: 0, y: 0, width: btn.size.width, height: 0))
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.separatorStyle = .singleLine
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        if (direction == "up") {
            self.frame = CGRect(x: btn.origin.x, y: (btn.origin.y - height - 4), width: btn.size.width, height: height)
        } else if(direction == "down") {
            self.frame = CGRect(x: btn.origin.x, y: (btn.origin.y + btn.size.height + 4), width: btn.size.width, height: height)
        }
        table.frame = CGRect(x: 0, y: 0, width: btn.size.width, height: height)
        table.bounces = false;
        UIView.commitAnimations()
        
        b.superview?.addSubview(self)
        backgroundButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: SCREEN_BOUND.width, height: SCREEN_BOUND.height))
        backgroundButton.backgroundColor = UIColor.clear
        backgroundButton.addTarget(self, action: #selector(hideDropDown(b:)) , for: .touchUpInside)
        viewController.view.addSubview(backgroundButton)
        self.addSubview(table)
        return self;
    }
    
    @objc public func hideDropDown(b:UIView){
        let btn = b.frame
        var originGlobal = b.convert(btn, to: nil)
        originGlobal.origin.x = 15;
        originGlobal.origin.y = originGlobal.origin.y + 46.5;
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        if(animationDirection == "down"){
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 0)
            table.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0)
        } else{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 0)
            self.table.frame = CGRect(x: 0, y: self.table.frame.height, width: self.frame.size.width, height: 0)
        }
        UIView.commitAnimations()
        backgroundButton.removeFromSuperview()
        self.delegate.njDropDownHidden()
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        //        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)!
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: CellIdentifier)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        
        if (self.imageList.count == self.list.count) {
            cell.textLabel?.text = list.object(at: indexPath.row) as? String
            cell.imageView?.image = imageList.object(at: indexPath.row) as? UIImage
        } else if (self.imageList.count > self.list.count) {
            cell.textLabel?.text = list.object(at: indexPath.row) as? String
            if(indexPath.row < imageList.count){
                cell.imageView?.image = imageList.object(at: indexPath.row) as? UIImage
            }
        } else if (self.imageList.count < self.list.count) {
            cell.textLabel?.text = list.object(at: indexPath.row) as? String
            if (indexPath.row < imageList.count) {
                cell.imageView?.image = imageList.object(at: indexPath.row) as? UIImage
            }
        }
        
        if(itemBackgroundColor != nil){
            cell.backgroundColor = itemBackgroundColor;
        } else{
            cell.backgroundColor = UIColor.white
        }
        
        if(dropDownItemTextAlignment!.rawValue != DEFAULT_ALIGNMENT){
            cell.textLabel?.textAlignment = dropDownItemTextAlignment;
        }
        
        if(itemSelectionColor != nil){
            let v = UIView()
            v.backgroundColor = itemSelectionColor;
            cell.selectedBackgroundView = v;
        } else{
            let v = UIView()
            v.backgroundColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
            cell.selectedBackgroundView = v;
        }
        
        if(itemTextColor != nil){
            cell.textLabel?.textColor = itemTextColor;
        } else{
            cell.textLabel?.textColor = UIColor.black
        }
        
        return cell;
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideDropDown(b: btnSender)
        let c = tableView.cellForRow(at: indexPath)
        
        for subview in btnSender.subviews {
            if (subview.isKind(of: UIImageView.self)) {
                subview.removeFromSuperview()
            }
        }
        
        if(itemSelectionTextColor != nil){
            c?.textLabel?.textColor = itemSelectionTextColor
        } else{
            c?.textLabel?.textColor = UIColor.black
        }
        
        if(btnSender.isKind(of: UIButton.self)){
            imgView.image = c?.imageView?.image;
            imgView = UIImageView.init(image: c?.imageView?.image)
            imgView.frame = CGRect(x: 5, y: 5, width: 25, height: 25)
            btnSender.addSubview(imgView)
            (btnSender as! UIButton).setTitle((c?.textLabel?.text!)!, for: .normal)
            delegate.njDropDownHidden()
        } else{
            myDelegate(title: (c?.textLabel?.text!)!)
        }
        
        backgroundButton.removeFromSuperview()
    }
    
    func myDelegate(title:String){
        delegate.njDropDownDelegateMethod(sender: btnSender, title: title)
    }
    
    @IBAction func hideDimView(sender:UIButton){
        self.hideDropDown(b: btnSender)
    }
    
    func setDropDownItemTextAlignment(alignment:NSTextAlignment){
        dropDownItemTextAlignment = alignment
    }
    
    func setDropDownItemBackgroundColor(color:UIColor?){
        itemBackgroundColor = color!;
    }
    
    func setDropDownItemTextColor(color:UIColor?){
        itemTextColor = color!;
    }
    
    func setDropDownSelectionTextColor(color:UIColor?){
        itemSelectionTextColor = color!;
    }
    
    func setDropDownSelectionColor(color:UIColor?){
        itemSelectionColor = color!;
    }
    
    func setDropDownSeparatorColor(color:UIColor?) {
        if(tableSeparatorColor != nil){
            table.separatorColor = tableSeparatorColor;
        } else{
            table.separatorColor = UIColor.gray
        }
        table.reloadData();
    }
    
    func setDimViewColor(color:UIColor, alpha:CGFloat) {
        backgroundDimViewColor = color;
        backgroundDimViewAlpha = alpha;
        let newAlpha:CGFloat = (backgroundDimViewAlpha != nil) ? backgroundDimViewAlpha : 0.5
        var bgColor = backgroundDimViewColor
        bgColor = bgColor?.withAlphaComponent(newAlpha)
        backgroundButton.backgroundColor = bgColor
        backgroundButton.setNeedsLayout()
        backgroundButton.layoutIfNeeded()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}

