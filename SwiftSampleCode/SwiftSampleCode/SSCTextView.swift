//
//  SSCTextView.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 16/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import UIKit

extension UITextView{
    func numberOfLines() -> CGFloat{
        if let fontUnwrapped = self.font{
            return self.contentSize.height / fontUnwrapped.lineHeight
        }
        return 0
    }
}
