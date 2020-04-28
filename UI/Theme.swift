//
//  Theme.swift
//  UI
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

import UIKit

public final class Theme {
    public enum Colors: String, CaseIterable {
        case backgroundPrimaryColor
        case backgroundSecundaryColor
        case redTintColor

        public var colorized: UIColor {
            return UIColor(named: rawValue) ?? .black
        }
    }

    public struct Fonts {
        
    }

    public let colors = Colors.self
    public let fonts = Fonts()

    public static let `default` = Theme()
    private init() { }
}
