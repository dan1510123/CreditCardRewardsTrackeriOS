//
//  ProgressTileView.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/14/21.
//

import SwiftUI
import CoreData

struct ProgressTileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest: FetchRequest<Reward>
    var rewards: FetchedResults<Reward> { fetchRequest.wrappedValue }
    
    let annualFee: Float
    
    let rewardType: String
    let year: Int
    let saved: Int = 0
    let total: Int = 0
    
    init(annualFee: Float, rewardType: String, year: Int) {
        self.annualFee = annualFee
        self.rewardType = rewardType
        self.year = year
        var predicate = NSPredicate(format: "year == \(year)")
        if(rewardType != "Total") {
            predicate = NSPredicate(format: "year == \(year) and cardType == \"\(rewardType)\"")
        }
        fetchRequest = FetchRequest<Reward>(entity: Reward.entity(),
            sortDescriptors: [],
            predicate: predicate
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ProgressBarWrapped(annualFee: self.annualFee, rewards: self.rewards, rewardType: self.rewardType, barColor: getBarColor(cardType: self.rewardType))
            Spacer()
        }
        .padding()
    }
    
    private func getProgress(rewards: [Reward]) {
        let r = self.fetchRequest.wrappedValue
        print(r)
        for x in r {
            print(x)
        }
    }
    
    private func getBarColor(cardType: String) -> Color {
        if (cardType == "Total") {
            return Color.blue
        }
        else if (cardType == "Gold") {
            return Color(#colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1))
        }
        else if (cardType == "Platinum") {
            return Color(#colorLiteral(red: 0.8980392157, green: 0.8941176471, blue: 0.968627451, alpha: 1))
        }
        else if (cardType == "Delta Gold") {
            return Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
        }
        else if (cardType == "Delta Reserve") {
            return Color(#colorLiteral(red: 0.6868614554, green: 0.403000772, blue: 1, alpha: 1))
        }
        else if (cardType == "Hilton Aspire") {
            return Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
        }
        else{
            return Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        }
    }
    
    private func setTotal() {
        
    }
}

struct ProgressTileView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProgressTileView(annualFee: 350, rewardType: "Gold", year: 2021)
            ProgressTileView(annualFee: 695, rewardType: "Platinum", year: 2021)
            ProgressTileView(annualFee: 1045, rewardType: "Total", year: 2021)
        }
    }
}
