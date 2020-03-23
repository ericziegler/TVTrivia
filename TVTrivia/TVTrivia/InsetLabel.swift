//
//  InsetLabel.swift
//  TVTrivia
//
//  Created by Eric Ziegler on 3/23/20.
//  Copyright © 2020 Zigabytes. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: rect.inset(by: insets))
    }

}
