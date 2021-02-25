//
//  NSMutableAttributedString.swift
//  Glasswork
//
//  Created by David Bagwell on 2021-02-25.
//  Copyright © 2021 David Bagwell. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    convenience init(attributedStrings: [NSAttributedString]) {
        self.init()
        attributedStrings.forEach({ self.append($0) })
    }
    
    public func addAttributes(_ attributes: [NSAttributedString.Key: Any], forFirstOccuranceOf substring: String) {
        let foundRange = self.mutableString.range(of: substring)
        if foundRange.location != NSNotFound {
            self.addAttributes(attributes, range: foundRange)
        }
    }
    
    public func addAttributes(_ attributes: [NSAttributedString.Key: Any], forLastOccuranceOf substring: String) {
        let foundRange = self.mutableString.range(of: substring, options: [.backwards])
        if foundRange.location != NSNotFound {
            self.addAttributes(attributes, range: foundRange)
        }
    }

    public func addAttributes(_ attributes: [NSAttributedString.Key: Any], forAllOccurrencesOf substring: String) {
        let string = self.mutableString as String
        let foundRanges = string.ranges(of: substring)
        foundRanges.forEach { self.addAttributes(attributes, range: NSRange($0, in: string)) }
    }
    
}

