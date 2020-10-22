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

extension UIFont {
    
    public struct Family {
        
        // MARK: - Presets
        
        public static let system = Family(regularName: "-apple-system")
        
        
        // MARK: - Properties
        
        private let ultraLightName: String?
        private let thinName: String?
        private let regularName: String
        private let mediumName: String?
        private let semiboldName: String?
        private let boldName: String?
        private let heavyName: String?
        private let blackName: String?
        
        
        // MARK: - Init
        
        public init(
            ultraLightName: String? = nil,
            thinName: String? = nil,
            regularName: String,
            mediumName: String? = nil,
            semiboldName: String? = nil,
            boldName: String? = nil,
            heavyName: String? = nil,
            blackName: String? = nil
        ) {
            self.ultraLightName = ultraLightName
            self.thinName = thinName
            self.regularName = regularName
            self.mediumName = mediumName
            self.semiboldName = semiboldName
            self.boldName = boldName
            self.heavyName = heavyName
            self.blackName = blackName
        }
        
        
        // MARK: - Methods
        
        public func name(for weight: Weight) -> String {
            switch weight {
            case .ultraLight:
                return self.ultraLightName ?? self.name(for: .thin)
            case .thin:
                return self.thinName ?? self.name(for: .regular)
            case .regular:
                return self.regularName
            case .medium:
                return self.mediumName ?? self.name(for: .regular)
            case .semibold:
                return self.semiboldName ?? self.name(for: .medium)
            case .bold:
                return self.boldName ?? self.name(for: .semibold)
            case .heavy:
                return self.heavyName ?? self.name(for: .bold)
            case .black:
                return self.blackName ?? self.name(for: .heavy)
            default:
                return self.name(for: .regular)
            }
        }
        
        public func font(ofSize size: CGFloat, weight: Weight = .regular) -> UIFont {
            if
                self.regularName != Family.system.regularName,
                let font = UIFont(name: self.name(for: weight), size: size) {
                return font
            } else {
                return .systemFont(ofSize: size, weight: weight)
            }
        }
        
    }
    
}
