//
//  Spinner.swift
//  Instamojo
//
//  Created by Sukanya Raj on 07/03/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class Spinner: UIVisualEffectView {

    var text: String? {
        didSet {
            label.text = text
        }
    }

    let background: UIView = UIView()
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    let vibrancyView: UIVisualEffectView

    public init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }

    public func setText(text: String) {
        self.text = text
    }

    required public init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        contentView.addSubview(background)
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()

        if let superview = self.superview {

            let width = superview.frame.size.width / 1.7
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            background.frame = self.bounds
            background.backgroundColor = UIColor.lightGray
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)

            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 1,
                                 y: 0,
                                 width: width - activityIndicatorSize - 10,
                                 height: height)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }

    public func show() {
        self.isHidden = false
        label.text = text
    }

    public func hide() {
        self.isHidden = true
    }
}
