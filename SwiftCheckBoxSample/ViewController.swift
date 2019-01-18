//
//  ViewController.swift
//  SwiftCheckBoxSample
//
//  Created by HongQuan on 2019/01/18.
//  Copyright © 2019年 ENIXSOFT.CO.,LTD. All rights reserved.
//

import UIKit
import SwiftCheckBox

class ViewController: UIViewController {
    var label: UILabel!
    var checkbox1: SwiftCheckBox!
    var checkbox2: SwiftCheckBox!
    var checkbox3: SwiftCheckBox!
    var checkbox4: SwiftCheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCheckBox()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCheckBox() {
        label = UILabel(frame: CGRect(x:20.0, y: 100.0, width: (self.view.frame.width - 20 * 2), height: 20.0))
        //         .widthAnchor
        label.backgroundColor = UIColor.darkGray
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.view.addSubview(self.label)
        
        checkbox1 = SwiftCheckBox(frame: CGRect(x: 20.0, y: 180.0, width:(self.view.frame.width - 40), height: 20.0))
        self.checkbox1.addTarget(self, action: #selector(self.checkboxDidChange(_:)), for: .valueChanged)
        self.checkbox1.hintText = "to agree Terms of service"
        _ = self.checkbox1.addLink(text: "open Websize", urlString: "http://www.enixsoft.com", color: .blue)
        self.checkbox1.setColor(.blue, forControlState: .normal)
        self.checkbox1.delegate = self
        self.view.addSubview(self.checkbox1)
        
        checkbox2 = SwiftCheckBox()
        self.checkbox2 = SwiftCheckBox(frame: CGRect(x:20.0, y: 220.0, width: (self.view.frame.width - 40), height: 20.0))
        self.checkbox2.addTarget(self, action: #selector(self.checkboxDidChange(_:)), for: .valueChanged)
        _ = self.checkbox2.addTouch(text: "open screen", target: self, action: #selector(self.checkboxTapGesture(_:)), color: .red)
        self.checkbox2.hintText = "to agree privacy"
        self.checkbox2.setColor(.red, forControlState: .normal)
        self.checkbox2.delegate = self
        self.checkboxDidChange(self.checkbox2)
        self.view.addSubview(self.checkbox2)
        
        checkbox3 = SwiftCheckBox()
        self.checkbox3 = SwiftCheckBox(frame: CGRect(x:20.0, y: 260.0, width:(self.view.frame.width - 20), height: 40.0))
        self.checkbox3.addTarget(self, action: #selector(self.checkboxDidChange(_:)), for: .valueChanged)
        self.checkbox3.addTarget(self, action: #selector(self.checkboxDidTouch(_:)), for: .touchUpInside)
        self.checkbox3.checkboxSideLength = 40.0
        self.checkbox3.hintText = "set box size to 40"
        self.checkbox3.setColor(.green, forControlState: .normal)
        self.checkboxDidChange(self.checkbox3)
        self.view.addSubview(self.checkbox3)
        
        checkbox4 = SwiftCheckBox()
        self.checkbox4 = SwiftCheckBox(frame: CGRect(x:20.0, y: 320.0, width:(self.view.frame.width - 40), height: 30.0))
        self.checkbox4.alignment = .right
        self.checkbox4.checkboxSideLength = 30.0
        self.checkbox4.hintText = "set to right"
        _ = self.checkbox4.addLink(text: "open Websize", urlString: "http://www.enixsoft.com", color: .blue)
        self.checkbox4.setColor(.green, forControlState: .normal)
        self.checkboxDidChange(self.checkbox4)
        self.view.addSubview(self.checkbox4)
    }
    
    @objc func checkboxDidChange(_ sender: SwiftCheckBox) {
        if sender == self.checkbox1 {
            if sender.checked {
                self.label.text = "checkbox1 Checked"
            } else {
                self.label.text = "checkbox1 Not checked"
            }
        } else if sender == self.checkbox2 {
            if sender.checked {
                self.label.text = "checkbox2 Checked"
            } else {
                self.label.text = "checkbox2 Not checked"
            }
        } else if sender == self.checkbox3 {
            if sender.checked {
                self.label.text = "checkbox3 Checked"
            } else {
                self.label.text = "checkbox3 Not checked"
            }
        }
    }
    
    @objc func checkboxTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.label.text = "checkbox2 touch Tapped"
    }
    
    @objc func checkboxDidTouch(_ sender: SwiftCheckBox) {
        print("checkboxDidTouch Touched")
        if sender == self.checkbox1 {
            if sender.checked {
                self.label.text = "checkbox1 Checked"
            } else {
                self.label.text = "checkbox1 Not Checked"
            }
        } else if sender == self.checkbox2 {
            if sender.checked {
                self.label.text = "checkbox2 Checked"
            } else {
                self.label.text = "checkbox2 Not Checked"
            }
        } else if sender == self.checkbox3 {
            if sender.checked {
                self.label.text = "checkbox3 Checked"
            } else {
                self.label.text = "checkbox3 Not Checked"
            }
        }
    }
}

// MARK - SwiftCheckBoxDelegate method
extension ViewController: SwiftCheckBoxDelegate {
    func onClickCheck(_ checkBox: SwiftCheckBox, _ checked: Bool) -> Void {
        print("SwiftCheckBoxDelegate onClickCheck")
    }
    func onClickButton(_ checkBox: SwiftCheckBox, _ clicked: Bool) -> Void {
        print("SwiftCheckBoxDelegate onClickButton")
    }
    func onClickLink(_ checkBox: SwiftCheckBox, _ clicked: Bool, url: URL) -> Void {
        print("SwiftCheckBoxDelegate onClickLink")
    }
}
