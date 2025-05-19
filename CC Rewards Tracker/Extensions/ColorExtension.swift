//
//  ColorExtension.swift
//  CC Rewards Tracker
//
//  Created by Daniel Luo on 5/18/25.
//

import SwiftUI
import UIKit

extension Color {
    
    // MARK: - Init from Hex String
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r, g, b, a: Double
        switch length {
        case 6: // RGB
            r = Double((rgb & 0xFF0000) >> 16) / 255
            g = Double((rgb & 0x00FF00) >> 8) / 255
            b = Double(rgb & 0x0000FF) / 255
            a = 1.0
        case 8: // RGBA
            r = Double((rgb & 0xFF000000) >> 24) / 255
            g = Double((rgb & 0x00FF0000) >> 16) / 255
            b = Double((rgb & 0x0000FF00) >> 8) / 255
            a = Double(rgb & 0x000000FF) / 255
        default:
            return nil
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    // MARK: - Convert to Hex String
    func toHex(includeAlpha: Bool = false) -> String? {
        let uiColor = UIColor(self)
        
        guard let components = uiColor.cgColor.components else { return nil }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components.count >= 3 ? components[2] : components[0])
        let a = Float(uiColor.cgColor.alpha)
        
        if includeAlpha {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255),
                          lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255))
        }
    }
}
