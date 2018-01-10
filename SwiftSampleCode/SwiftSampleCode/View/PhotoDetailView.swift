//
//  PhotoDetailView.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 14/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailView: UIView{
    
    //MARK: var
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var messageTextView: UITextView?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint?
    @IBOutlet weak var yAxisConstraint: NSLayoutConstraint?
    var isKeyboardVisible = Bool(false)
    var orignialFrame:CGRect?
    var photo: Photo?
    
    //Loading from nib
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    //MARK: custom methods
    func setUpImage(photo: Photo) {
        self.photo = photo
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.isUserInteractionEnabled = true
        self.imageView?.image = photo.largeImage
        self.messageTextView?.text = photo.text
        if (Int((self.messageTextView?.numberOfLines())!)) > 1 {
            self.heightConstraint?.constant = 17 * round((self.messageTextView?.numberOfLines())!)
        }

        self.messageTextView?.delegate = self
        self.orignialFrame = self.frame
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .done, target: self, action:  #selector(doneButtonClicked(sender:)))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        self.messageTextView?.inputAccessoryView = ViewForDoneButtonOnKeyboard
        setUpKeyboardNotification()
    }
    
   //MARK: Keyboard handling
    func keyboardWillShow(note: NSNotification) {
        guard  !self.isKeyboardVisible else {
            return
        }
        animationBlock(note)
        self.isKeyboardVisible = true;
        UIView.commitAnimations()
    }
    

    func keyboardWillHide(note: NSNotification) {
        guard   self.isKeyboardVisible else {
            return
        }
        self.frame = self.orignialFrame!
        self.isKeyboardVisible = false
    }
    
    func setUpKeyboardNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(note:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(note:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func animationBlock(_ note: NSNotification){
        let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        var frame = self.frame
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        frame.size.height -= (keyboardSize?.height)!
        self.frame = frame
    }
    
    //MARK: IBAction
    @IBAction func doneButtonClicked(sender: UIButton) {
        self.messageTextView?.resignFirstResponder()
    }

}

extension PhotoDetailView:UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.photo?.text = textView.text
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.numberOfLines() < 5 {
            print(round(textView.numberOfLines()))
            self.heightConstraint?.constant = 17 * round(textView.numberOfLines())
        }
        return true
    }
}
