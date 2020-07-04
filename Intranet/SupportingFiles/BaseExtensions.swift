//
//  BaseExtensions.swift
//  Intranet
//
//  Created by Владислав on 28.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func disable(views: UIControl...) {
        for view in views {
            view.isEnabled = false
        }
    }
    
    func activate(views: UIControl...) {
        for view in views {
            view.isEnabled = true
        }
    }
    
    func hide(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0
        }) { (finished) in
            view.isHidden = finished
        }
    }
    
    func show(view: UIView) {
        view.alpha = 0
        view.isHidden = false
        UIView.animate(withDuration: 0.6) {
            view.alpha = 1
        }
    }
    
    func configurate(button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2.0
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.clipsToBounds = true
    }
    
    func configurate(textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textView.clipsToBounds = true
    }
    
    //MARK: To dismiss keyboard after tapping anywhere else
    
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImageView {
    
    var contentClippingRect: CGRect {
        
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }

}

extension UIImage {
    
    static func resizedCroppedImage(image: UIImage, newSize:CGSize) -> UIImage? {

        var ratio: CGFloat = 0
        var delta: CGFloat = 0
        var drawRect = CGRect()

        if newSize.width > newSize.height {

            ratio = newSize.width / image.size.width
            delta = (ratio * image.size.height) - newSize.height
            drawRect = CGRect(x: 0, y: -delta / 2, width: newSize.width, height: newSize.height + delta)

        } else {

            ratio = newSize.height / image.size.height
            delta = (ratio * image.size.width) - newSize.width
            drawRect = CGRect(x: -delta / 2, y: 0, width: newSize.width + delta, height: newSize.height)

        }

        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
        image.draw(in: drawRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
