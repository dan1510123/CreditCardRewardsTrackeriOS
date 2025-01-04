//
//  CardTypePresets.swift
//  CC Rewards Tracker
//
//  Created by Daniel Luo on 1/4/25.
//

import Foundation
import SwiftUICore

struct CardTypePreset {
    let name: String
    let annualFee: Double
    let iconName: String
    let color: Color
}

class CardTypePresets {
    static let shared = CardTypePresets()

    private func getPresets() -> [CardTypePreset] {
        let presets = [
            CardTypePreset(
                name: "Amex Gold",
                annualFee: 250,
                iconName: "amexGoldCardIcon",
                color: Color(#colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1))
            ),
            CardTypePreset(
                name: "Amex Platinum",
                annualFee: 695,
                iconName: "amexPlatinumCardIcon",
                color: Color(#colorLiteral(red: 0.8980392157, green: 0.8941176471, blue: 0.968627451, alpha: 1))
            ),
            CardTypePreset(
                name: "Amex Delta Gold",
                annualFee: 150,
                iconName: "amexDeltaGoldCardIcon",
                color: Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
            ),
            CardTypePreset(
                name: "Amex Delta Reserve",
                annualFee: 650,
                iconName: "amexDeltaReserveCardIcon",
                color: Color(#colorLiteral(red: 0.6868614554, green: 0.403000772, blue: 1, alpha: 1))
            ),
            CardTypePreset(
                name: "Amex Hilton Aspire",
                annualFee: 550,
                iconName: "amexHiltonAspireCardIcon",
                color: Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
            )
        ]
        
        return presets
    }
}
