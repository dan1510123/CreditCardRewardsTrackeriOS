//
//  ProgressBarWrapped.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/27/21.
//

import SwiftUI

struct ProgressBarWrapped: View {
    
    var annualFee: Float
    var goalPercent: Float = 0
    
    let rewards: FetchedResults<Reward>
    let rewardType: String
    let barColor: Color
    var redeemed: Float = 0
    var total: Float = 0
    var progressPercent: Float = 0
    
    init(annualFee: Float, rewards: FetchedResults<Reward>, rewardType: String, barColor: Color) {
        self.annualFee = annualFee
        self.rewards = rewards
        self.rewardType = rewardType
        self.barColor = barColor
        self.setAnnualProgress()
    }
    
    private mutating func setAnnualProgress() {
        for reward in rewards {
            self.total += reward.value
            if(reward.redeemed) {
                self.redeemed += reward.value
            }
        }
        if self.total > 0 {
            self.progressPercent = self.redeemed / self.total
            self.goalPercent = self.annualFee / self.total
        }
        if self.goalPercent > 1 || self.total == 0 {
            self.goalPercent = 1
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(rewardType) Rewards")
                    .font(.system(size: 24.0))
                    .underline()
                    .padding(.bottom, 10)
                Spacer()
                getCardIcon(cardType: self.rewardType)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 40)
            }
            Text("\(String(format: "$%.0f", self.redeemed)) of \(String(format: "$%.0f", self.total)) earned")
                .font(.system(size: 20.0))
            ProgressBar(progressPercent: self.progressPercent, goalPercent: self.goalPercent, color: self.barColor).frame(height: 20)
        }
    }
    
    private func getCardIcon(cardType: String) -> Image {
        if (cardType == "Gold") {
            return Image("goldCardIcon")
        }
        else if (cardType == "Platinum") {
            return Image("platCardIcon")
        }
        else if (cardType == "Delta Gold") {
            return Image("deltaGoldCardIcon")
        }
        else if (cardType == "Delta Reserve") {
            return Image("deltaReserveCardIcon")
        }
        else if (cardType == "Hilton Aspire") {
            return Image("creditCardIcon")
        }
        else {
            return Image("creditCardIcon")
        }
    }
}

struct ProgressBarWrapped_Previews: PreviewProvider {
    static var previews: some View {
        Text("") //ProgressBarWrapped(rewards: nil, rewardType: "Gold", barColor: "Gold")
    }
}
