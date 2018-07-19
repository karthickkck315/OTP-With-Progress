//
//  OTPPage.swift
//  FixerLoop
//
//  Created by Karthick on 7/17/18.
//  Copyright © 2018 vijay. All rights reserved.
//

import UIKit
import SVPinView

class OTPPage: UIViewController {

  @IBOutlet weak var taskProgress:UIProgressView!
  var progressValue = 0.0
  

  
  var mobileNoStr = String()
  var msg = String()
  var timer : Timer!
  var second = 30
  
  @IBOutlet weak var otpMessageLabel: UILabel!
  @IBOutlet weak var resendLabel: UILabel!
  @IBOutlet var pinView:SVPinView!
  @IBOutlet weak var resendButton: UIButton!
  @IBOutlet weak var sendButton: UIButton!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

        configurePinView()
    
    self.title = "OTP"
    self.taskProgress.progress = 0
    self.taskProgress.progressTintColor = UIColor.blue
    self.taskProgress.trackTintColor = UIColor.lightGray
    otpMessageLabel.font = UIFont.systemFont(ofSize: 18)
    otpMessageLabel.numberOfLines = 0
    otpMessageLabel.lineBreakMode = .byWordWrapping
    otpMessageLabel.textColor = .black
    otpMessageLabel.text = "Your OTP Send your register Mobile Number"
    
    resendLabel.font = UIFont.systemFont(ofSize: 18)
    resendLabel.numberOfLines = 0
    resendLabel.lineBreakMode = .byWordWrapping
    resendLabel.textColor = .black
    resendLabel.text = "Resend your OTP after 30 Seconds"
   
    
    resendButton.isHidden = true
    resendButton.setTitleColor(.blue, for: .normal)
    resendButton.addTarget(self, action: #selector(reSendAction), for: .touchUpInside)
    resendButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    
    let attributedString = NSAttributedString(
      string: "Resend",
      attributes:[
        kCTFontAttributeName as NSAttributedStringKey :UIFont.systemFont(ofSize: 18),
        kCTForegroundColorAttributeName as NSAttributedStringKey : UIColor.blue,
        kCTUnderlineStyleAttributeName as NSAttributedStringKey:1.0
      ])
    resendButton.setAttributedTitle(attributedString, for: .normal)
    
    timer = Timer()
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.calculateSeconds), userInfo: nil, repeats: true)
    }
  
  @objc func updateProgress() {
    progressValue = progressValue + 0.035
    self.taskProgress.progress = Float(progressValue)
  }
  
  @objc func calculateSeconds() {
    second -= 1
    let str = String(second)
    resendLabel.text = "Resend your OTP after \(str) Seconds"
    self.perform(#selector(updateProgress), with: nil, afterDelay: 0)
    if second == 0 {
      taskProgress.isHidden = true
      resendLabel.isHidden = true
      resendButton.isHidden = false
      timer.invalidate()
    }
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  @objc func reSendAction() {
   print("Resend")
    second = 30
    progressValue = 0.0
    self.taskProgress.progress = Float(progressValue)
    taskProgress.isHidden = false
    resendLabel.isHidden = false
    resendButton.isHidden = true
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.calculateSeconds), userInfo: nil, repeats: true)
  }
  func configurePinView() {
    pinView.backgroundColor = .clear
    pinView.pinLength = 6
    pinView.secureCharacter = "\u{25CF}"
    pinView.interSpace = 10
    pinView.textColor = UIColor.black
    //pinView.borderLineColor = UIColor.white
    //pinView.borderLineThickness = 1
    pinView.shouldSecureText = true
    pinView.style = .underline
    //pinView.fieldBackgroundColor = UIColor.white.withAlphaComponent(0.3)
    pinView.fieldCornerRadius = 15
    pinView.placeholder = "******"
    
    pinView.font = UIFont.systemFont(ofSize: 15)
    pinView.keyboardType = .phonePad
    pinView.pinIinputAccessoryView = { () -> UIView in
      let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
      doneToolbar.barStyle = UIBarStyle.default
      let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
      let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissKeyboard))
      
      var items = [UIBarButtonItem]()
      items.append(flexSpace)
      items.append(done)
      
      doneToolbar.items = items
      doneToolbar.sizeToFit()
      return doneToolbar
    }()
    
    pinView.didFinishCallback = didFinishEnteringPin(pin:)
  }
  
  func didFinishEnteringPin(pin:String) {
    self.view.endEditing(true)
    showAlert(title: "Success", message: "The Pin entered is \(pin)")
  }
  @objc func dismissKeyboard() {
    self.view.endEditing(false)
  }
  //MARK: Helper Functions
  func showAlert(title:String, message:String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
