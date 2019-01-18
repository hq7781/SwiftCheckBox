//
//  SwiftCheckBox.swift
//  SwiftCheckBox
//
//  Created by HongQuan on 2019/01/18.
//  Copyright © 2019年 ENIXSOFT.CO.,LTD. All rights reserved.
//

import Foundation
import UIKit

let kCheckboxDefaultSideLength : CGFloat = 20.0
let kCheckboxDefaultPadding    : CGFloat = 5.0
let kTouchLabelMaxLength       : CGFloat = 200.0
let kCheckboxOffset            : CGFloat = 0.5

let kUIControlStateNameNormal = Int(UIControlState.normal.rawValue).description
let kUIControlStateNameSelected = Int(UIControlState.selected.rawValue).description
let kUIControlStateNameDisabled = Int(UIControlState.disabled.rawValue).description
let kUIControlStateNameHighlighted = Int(UIControlState.highlighted.rawValue).description

public enum SwiftCheckBoxType : Int {
    case none
    case link
    case touch
}
public enum SwiftCheckBoxAlignment: Int {
    case left
    case right
    case center
}

public protocol SwiftCheckBoxDelegate: class {
    func onClickCheck(_ checkBox: SwiftCheckBox, _ checked: Bool) -> Void
    func onClickButton(_ checkBox: SwiftCheckBox, _ clicked: Bool) -> Void
    func onClickLink(_ checkBox: SwiftCheckBox, _ clicked: Bool, url: URL) -> Void
}

public class SwiftCheckBox: UIControl {
    @IBInspectable public var checkboxCornerRadius: CGFloat = 4.0
    @IBInspectable public var checkboxColor: UIColor = .black
    @IBInspectable public var checkboxSideLength : CGFloat = kCheckboxDefaultSideLength
    
    public var alignment : SwiftCheckBoxAlignment = .left
    
    public var readed : Bool = false {
        didSet {
            self.setReaded(readed)
        }
    }
    
    public var checked : Bool = false {
        didSet {
            self.setChecked(checked)
        }
    }
    
    public var hintText : String? = nil {
        didSet {
            self.textLabel.text = hintText
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var linkText : String? = nil {
        didSet {
            self.touchLabel.text = self.linkText
            self.setNeedsDisplay()
        }
    }
    fileprivate var linkUrl : URL!
    fileprivate var linkColor : UIColor = .blue
    
    fileprivate var type : SwiftCheckBoxType = .none
    
    fileprivate var textLabel : UILabel!
    fileprivate var touchLabel: UILabel!
    
    public weak var delegate: SwiftCheckBoxDelegate?
    
    fileprivate var colorDictionary          : Dictionary<String, UIColor> = Dictionary()
    fileprivate var backgroundColorDictionary: Dictionary<String, UIColor> = Dictionary()
    
    // MARK: - Init Methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "enabled")
        self.removeObserver(self, forKeyPath: "selected")
        self.removeObserver(self, forKeyPath: "highlighted")
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        
        self.textLabel  = UILabel()
        self.textLabel.backgroundColor = .clear
        self.addSubview(self.textLabel)
        self.touchLabel = UILabel()
        self.touchLabel.backgroundColor = .clear
        self.addSubview(self.touchLabel)
        
        self.addObserver(self, forKeyPath: "enabled", options: [.old, .new], context: nil)
        self.addObserver(self, forKeyPath: "selected", options: [.old, .new], context: nil)
        self.addObserver(self, forKeyPath: "highlighted", options: [.old, .new], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard (keyPath == "enabled" || keyPath == "selected" || keyPath == "highlighted") else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        self.changeColor(forState: self.state)
        self.changeBackgroundColor(forState: self.state)
    }
    
    fileprivate func changeColor(forState state: UIControlState){
        var color: UIColor?
        switch (state) {
        case .normal:
            color = self.colorDictionary[kUIControlStateNameNormal]
        case .selected:
            color = self.colorDictionary[kUIControlStateNameSelected]
        case .disabled:
            color = self.colorDictionary[kUIControlStateNameDisabled]
        case .highlighted:
            color = self.colorDictionary[kUIControlStateNameHighlighted]
        default:
            break
        }
        
        if color == nil {
            color = .black
        }
        if let color = color {
            self.checkboxColor = color
        }
        //        self.textLabel.textColor = color
    }
    
    fileprivate func changeBackgroundColor(forState state: UIControlState){
        var color: UIColor?
        switch (state) {
        case .normal:
            color = self.backgroundColorDictionary[kUIControlStateNameNormal]
        case .selected:
            color = self.backgroundColorDictionary[kUIControlStateNameSelected]
        case .disabled:
            color = self.backgroundColorDictionary[kUIControlStateNameDisabled]
        case .highlighted:
            color = self.backgroundColorDictionary[kUIControlStateNameDisabled]
        default:
            break
        }
        
        if color == nil {
            color = .clear
        }
        self.backgroundColor = color
    }
    
    public func setChecked(_ checked: Bool) {
        self.setNeedsDisplay()
        self.sendActions(for: .valueChanged)
    }
    
    public func setReaded(_ readed: Bool) {
        self.setNeedsDisplay()
        self.sendActions(for: .touchUpInside)
    }
    
    public func setCheckboxColor(color: UIColor) {
        self.checkboxColor = color
        self.setNeedsDisplay()
    }
    
    public func setColor(_ color: UIColor, forControlState state: UIControlState) {
        switch (state) {
        case .normal:
            self.colorDictionary[kUIControlStateNameNormal] = color
        case .selected:
            self.colorDictionary[kUIControlStateNameSelected] = color
        case .disabled:
            self.colorDictionary[kUIControlStateNameDisabled] = color
        case .highlighted:
            self.colorDictionary[kUIControlStateNameHighlighted] = color
        default:
            break
        }
        self.changeColor(forState: state)
    }
    
    public func setBackgroundColor(_ color: UIColor , forControlState state: UIControlState) {
        switch (state) {
        case .normal:
            self.backgroundColorDictionary[kUIControlStateNameNormal] = color
        case .selected:
            self.backgroundColorDictionary[kUIControlStateNameSelected] = color
        case .disabled:
            self.backgroundColorDictionary[kUIControlStateNameDisabled] = color
        case .highlighted:
            self.backgroundColorDictionary[kUIControlStateNameHighlighted] = color
        default:
            break
        }
        self.changeBackgroundColor(forState: state)
    }
    
    public func addTouch(text: String, target: Any?, action: Selector? = nil, color: UIColor) -> Bool{
        self.linkText = text
        self.linkColor  = color
        self.type = .touch
        
        self.readed = true
        if let action = action {
            self.touchLabel.isUserInteractionEnabled = true
            print("touch Tapped")
            let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
            self.touchLabel.addGestureRecognizer(tapGestureRecognizer)
        }
        delegate?.onClickButton(self, readed)
        return true
    }
    
    public func addLink(text: String, urlString: String, color: UIColor) -> Bool{
        guard let url = URL(string: urlString) else {
            return false
        }
        self.linkText = text
        self.linkUrl  = url
        self.linkColor  = color
        self.type = .link
        
        self.touchLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.touchLabel.addGestureRecognizer(tapGestureRecognizer)
        return true
    }
    
    @objc func tapGesture(gestureRecognizer: UITapGestureRecognizer) {
        if UIApplication.shared.canOpenURL(self.linkUrl) {
            print("link url Tapped")
            UIApplication.shared.open(self.linkUrl)
            self.readed = true
            delegate?.onClickLink(self, readed, url: linkUrl)
        } else {
            print("url is Can not Open ")
        }
    }
    
    // override methods
    override public func draw(_ rect:CGRect) {
        let frame = CGRect(x: 0,
                           y: (rect.size.height - self.checkboxSideLength) / 2.0,
                           width: self.checkboxSideLength,
                           height: self.checkboxSideLength).integral
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.0 //1.0 //4.0
        self.layer.addSublayer(shapeLayer)
        
        switch (alignment) {
        case .center: break
        case .right:
            
            if self.checked {
                let bezierPath = UIBezierPath()
                bezierPath.move(to: CGPoint(x: (self.frame.width - frame.width - kCheckboxDefaultPadding) + (frame.minX + 0.75000 * frame.width), y: frame.minY + 0.21875 * frame.height))
                bezierPath.addLine(to: CGPoint(x: (self.frame.width - frame.width - kCheckboxDefaultPadding) + (frame.minX + 0.40000 * frame.width), y: frame.minY  + 0.52500 * frame.height))
                bezierPath.addLine(to: CGPoint(x: (self.frame.width - frame.width - kCheckboxDefaultPadding) + (frame.minX + 0.28125 * frame.width), y: frame.minY  + 0.37500 * frame.height))
                bezierPath.addLine(to: CGPoint(x: (self.frame.width - frame.width - kCheckboxDefaultPadding) + (frame.minX + 0.17500 * frame.width), y: frame.minY  + 0.47500 * frame.height))
                bezierPath.addLine(to: CGPoint(x: (self.frame.width - frame.width - kCheckboxDefaultPadding) + (frame.minX + 0.40000 * frame.width), y: frame.minY  + 0.75000 * frame.height))
                bezierPath.addLine(to: CGPoint(x: (self.frame.width - frame.width - kCheckboxDefaultPadding) + (frame.minX + 0.81250 * frame.width), y: frame.minY  + 0.28125 * frame.height))
                bezierPath.addLine(to: CGPoint(x: (self.frame.width - frame.width - kCheckboxDefaultPadding) + (frame.minX + 0.75000 * frame.width), y: frame.minY  + 0.21875 * frame.height))
                
                bezierPath.close()
                self.checkboxColor.setFill()
                bezierPath.fill()
                shapeLayer.path = bezierPath.cgPath
            }
            
            let rect = CGRect(x: (self.frame.width - frame.width - kCheckboxDefaultPadding) + (frame.minX + floor(frame.width * 0.05000 + kCheckboxOffset)),
                              y: frame.minY + floor(frame.height * 0.05000 + kCheckboxOffset),
                              width: floor(frame.width * 0.95000 + kCheckboxOffset) - floor(frame.width * 0.05000 + kCheckboxOffset),
                              height: floor(frame.height * 0.95000 + kCheckboxOffset) - floor(frame.height * 0.05000 + kCheckboxOffset))
            
            let roundedRectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: checkboxCornerRadius)
            roundedRectanglePath.lineWidth = 2 * self.checkboxSideLength / kCheckboxDefaultSideLength
            
            self.checkboxColor.setStroke()
            roundedRectanglePath.stroke()
            shapeLayer.path = roundedRectanglePath.cgPath
            
        case .left:
            
            if self.checked {
                let bezierPath = UIBezierPath()
                bezierPath.move(to: CGPoint(x: frame.minX + 0.75000 * frame.width, y: frame.minY + 0.21875 * frame.height))
                bezierPath.addLine(to: CGPoint(x: frame.minX + 0.40000 * frame.width, y: frame.minY  + 0.52500 * frame.height))
                bezierPath.addLine(to: CGPoint(x: frame.minX + 0.28125 * frame.width, y: frame.minY  + 0.37500 * frame.height))
                bezierPath.addLine(to: CGPoint(x: frame.minX + 0.17500 * frame.width, y: frame.minY  + 0.47500 * frame.height))
                bezierPath.addLine(to: CGPoint(x: frame.minX + 0.40000 * frame.width, y: frame.minY  + 0.75000 * frame.height))
                bezierPath.addLine(to: CGPoint(x: frame.minX + 0.81250 * frame.width, y: frame.minY  + 0.28125 * frame.height))
                bezierPath.addLine(to: CGPoint(x: frame.minX + 0.75000 * frame.width, y: frame.minY  + 0.21875 * frame.height))
                
                bezierPath.close()
                self.checkboxColor.setFill()
                bezierPath.fill()
                shapeLayer.path = bezierPath.cgPath
            }
            
            let rect = CGRect(x: frame.minX + floor(frame.width * 0.05000 + kCheckboxOffset),
                              y: frame.minY + floor(frame.height * 0.05000 + kCheckboxOffset),
                              width: floor(frame.width * 0.95000 + kCheckboxOffset) - floor(frame.width * 0.05000 + kCheckboxOffset),
                              height: floor(frame.height * 0.95000 + kCheckboxOffset) - floor(frame.height * 0.05000 + kCheckboxOffset))
            
            let roundedRectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: checkboxCornerRadius)
            roundedRectanglePath.lineWidth = 2 * self.checkboxSideLength / kCheckboxDefaultSideLength
            
            self.checkboxColor.setStroke()
            roundedRectanglePath.stroke()
            shapeLayer.path = roundedRectanglePath.cgPath
        }
        
        super.draw(rect)
    }
    
    override public func layoutSubviews() {
        
        var textLabelOriginX = self.checkboxSideLength + kCheckboxDefaultPadding
        switch (alignment) {
        case .center: break
        case .right:
            textLabelOriginX = self.frame.width - (self.checkboxSideLength + kCheckboxDefaultPadding)
            self.textLabel.textAlignment = .right
        case .left:
            textLabelOriginX = self.checkboxSideLength + kCheckboxDefaultPadding
            self.textLabel.textAlignment = .left
        }
        let touchLabelMaxLength : CGFloat = kTouchLabelMaxLength
        
        var textLabelWidth : CGFloat = 0
        var touchLabelWidth : CGFloat = 0
        var textLabelRect = CGRect.zero
        var touchLabelRect = CGRect.zero
        
        let attributes : [NSAttributedStringKey : Any] = [.font: self.textLabel.font]
        
        if type == .touch || type == .link {
            if let touchLabelText = self.touchLabel.text {
                let attributedString = NSMutableAttributedString(string: touchLabelText,attributes:attributes)
                let range = NSString(string: touchLabelText).range(of: touchLabelText)
                if type == .touch {
                    attributedString.addAttribute(.foregroundColor, value: self.linkColor, range: range)
                    attributedString.addAttribute(.strokeColor, value: UIColor.darkGray, range: range)
                } else if type == .link {
                    attributedString.addAttribute(.foregroundColor, value: self.linkColor, range: range)
                    attributedString.addAttribute(.link, value: self.linkUrl, range: range)
                    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
                }
                self.touchLabel.attributedText = attributedString
                touchLabelRect = labelRect(self.textLabel, touchLabelText, attributes: attributes)
                touchLabelWidth = (touchLabelMaxLength > touchLabelRect.width) ? touchLabelRect.width : touchLabelMaxLength
            }
        }
        var textLabelMaxLength = (self.bounds.width - textLabelOriginX - touchLabelWidth)
        switch (alignment) {
        case .center: break
        case .right:
            if textLabelOriginX > touchLabelWidth {
                textLabelMaxLength = (textLabelOriginX - touchLabelWidth)
            } else {
                print("need computting")
            }
            
        case .left:
            textLabelMaxLength = (self.bounds.width - textLabelOriginX - touchLabelWidth)
        }
        if let textLabelText = self.textLabel.text {
            let attributedString = NSMutableAttributedString(string: textLabelText,attributes: attributes)
            self.textLabel.attributedText = attributedString
            textLabelRect = labelRect(self.textLabel, textLabelText, attributes: attributes)
            textLabelWidth = (textLabelMaxLength > textLabelRect.width) ? textLabelRect.width : textLabelMaxLength
        }
        switch (alignment) {
        case .center: break
        case .right:
            self.textLabel.frame = (textLabelWidth > 0) ? CGRect(x: textLabelOriginX - textLabelWidth - kCheckboxDefaultPadding,
                                                                 y: (self.bounds.height -  textLabelRect.height) / 2.0,
                                                                 width: textLabelWidth, height: textLabelRect.height).integral : CGRect.zero
            self.touchLabel.frame = (touchLabelWidth > 0) ? CGRect(x: textLabelOriginX - textLabelWidth - touchLabelWidth - kCheckboxDefaultPadding,
                                                                   y: (self.bounds.height -  touchLabelRect.height) / 2.0,
                                                                   width: touchLabelWidth, height: touchLabelRect.height).integral : CGRect.zero
            //            self.textLabel.backgroundColor = UIColor.yellow
        //            self.touchLabel.backgroundColor = UIColor.brown
        case .left:
            self.textLabel.frame = (textLabelWidth > 0) ? CGRect(x: textLabelOriginX,
                                                                 y: (self.bounds.height -  textLabelRect.height) / 2.0,
                                                                 width: textLabelWidth, height: textLabelRect.height).integral : CGRect.zero
            self.touchLabel.frame = (touchLabelWidth > 0) ? CGRect(x: textLabelOriginX + textLabelWidth + kCheckboxDefaultPadding,
                                                                   y: (self.bounds.height -  touchLabelRect.height) / 2.0,
                                                                   width: touchLabelWidth, height: touchLabelRect.height).integral : CGRect.zero
        }
        super.layoutIfNeeded()
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let location = touch?.location(in: self) else { return }
        if self.textLabel.frame.contains(location) {
            print("textLabel touched")
        }
        if type == .touch || type == .link {
            if self.touchLabel.frame.contains(location) {
                print("touchLabel touched")
                return
            }
        }
        
        if self.bounds.contains(location) {
            self.checked = !self.checked
            delegate?.onClickCheck(self, checked)
        }
    }
    
    // private methods
    fileprivate func labelRect(_ label: UILabel, _ s: String, attributes: [NSAttributedStringKey : Any]) -> CGRect {
        let str: NSString = NSString(string: s)
        let size : CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.height)
        let att: [NSAttributedStringKey : Any] = attributes
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect: CGRect = str.boundingRect(with: size, options: options, attributes: att, context: nil)
        return rect
    }
    
    fileprivate func labelWidth(_ label: UILabel, _ s: String, attributes: [NSAttributedStringKey : Any]) -> CGFloat {
        let rect: CGRect = labelRect(label, s, attributes: attributes)
        return rect.width
    }
    
    fileprivate func labelHeight(_ label: UILabel, _ s: String, attributes: [NSAttributedStringKey : Any]) -> CGFloat {
        let rect: CGRect = labelRect(label, s, attributes: attributes)
        return rect.height
    }
}



