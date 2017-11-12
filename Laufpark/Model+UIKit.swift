//
//  Model+UIKit.swift
//  Laufpark
//
//  Created by Chris Eidhof on 08.09.17.
//  Copyright © 2017 objc.io. All rights reserved.
//

#if os(OSX)
    import Cocoa
    typealias LColor = NSColor
#else
    import UIKit
    typealias LColor = UIColor
#endif

extension LColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}

extension Color {
    var textColor: LColor {
        switch self {
        case .yellow, .gray, .beige:
            return .black
        default:
            return .white
        }
    }
    var uiColor: LColor {
        switch self {
        case .red:
            return UIColor(r: 255, g: 0, b: 0)
        case .turquoise:
            return UIColor(r: 0, g: 159, b: 159)
        case .brightGreen:
            return UIColor(r: 104, g: 195, b: 12)
        case .violet:
            return UIColor(r: 174, g: 165, b: 213)
        case .purple:
            return UIColor(r: 135, g: 27, b: 138)
        case .green:
            return UIColor(r: 0, g: 132, b: 70)
        case .beige:
            return UIColor(r: 227, g: 177, b: 151)
        case .blue:
            return UIColor(r: 0, g: 92, b: 181)
        case .brown:
            return UIColor(r: 126, g: 50, b: 55)
        case .yellow:
            return UIColor(r: 255, g: 244, b: 0)
        case .gray:
            return UIColor(r: 174, g: 165, b: 213)
        case .lightBlue:
            return UIColor(r: 0, g: 166, b: 198)
        case .lightBrown:
            return UIColor(r: 190, g: 135, b: 90)
        case .orange:
            return UIColor(r: 255, g: 122, b: 36)
        case .pink:
            return UIColor(r: 255, g: 0, b: 94)
        case .lightPink:
            return UIColor(r: 255, g: 122, b: 183)
        }
    }
}


