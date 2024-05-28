// Copyright (c) David Bagwell - https://github.com/dbagwell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/// This is a `UIView` that does not intercept user interaction
/// (allowing superviews to recieve the interactions that would normally be intercepted by this view)
/// while still allowing subviews to have user interaction enabled
open class UninteractableView: UIView {
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            // For a subview to be interactable it must
            // - not be hidden
            // - have opacity
            // - allow user interaction
            // Points inside that subview are then considered to be "inside" this view
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }

        // Anything else is not considered "inside" this view so that the interaction gets handled by the view's superview instead
        return false
    }
}

/// This is a stack view that does not intercept user interaction
/// (allowing superviews to recieve the interactions that would normally be intercepted by the stackview)
/// while still allowing subviews to have user interaction enabled
public final class UninteractableStackView: UIStackView {
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            // For a subview to be interactable it must
            // - not be hidden
            // - have opacity
            // - allow user interaction
            // Points inside that subview are then considered to be "inside" this stack view
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }

        // Anything else is not considered "inside" this stack view so that the interaction gets handled by the stack view's superview instead
        return false
    }
}
