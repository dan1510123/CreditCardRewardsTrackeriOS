//
//  ListRowView.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI

struct ListRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var reward: Reward
    let title: String
    let details: String
    let value: Float
    @State var redeemed: Bool
    var adminMode: Bool
    
    var cardFetchRequest: FetchRequest<CardType>
    var cardFetchResult: FetchedResults<CardType> { cardFetchRequest.wrappedValue }
    
    init(reward: Reward, title: String, details: String, value: Float, redeemed: Bool, adminMode: Bool = false) {
        self.reward = reward
        self.title = title
        self.details = details
        self.value = value
        self.redeemed = redeemed
        self.adminMode = adminMode
        
        cardFetchRequest = FetchRequest<CardType>(
            entity: CardType.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "cardName == \"\(reward.cardType!)\""))
    }
    
    var body: some View {
        ZStack {
            HStack {
                getCardIcon()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(title)
                            .font(.headline)
                        Spacer()
                        Text("\(String(format: "$%.2f", value))")
                            .font(.subheadline)
                    }
                    HStack {
                        Text(details)
                            .font(.subheadline)
                            .lineLimit(2)
                        Spacer()
                        if reward.recurrencePeriod == "once" {
                            Text("Expires " + formatDateToString(date: reward.expirationDate!, format: "MM/dd"))
                                .font(.subheadline)
                        }
                    }
                }
                
                if !adminMode {
                    Button(action: {
                        withAnimation {
                            onCheckPressed()
                        }
                    }) {
                        Image(systemName: redeemed ? "checkmark.circle.fill" : "checkmark.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(redeemed ? nil : .gray)
                            .animation(.easeInOut, value: redeemed)
                    }
                    .padding(.leading, 10)
                }
            }
            .padding()
            .background(getBackgroundColor())
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
            
            if adminMode {
                NavigationLink("", destination: UpdateRewardPage(viewContext: viewContext, reward: reward))
                    .opacity(0)
            }
        }
        .listRowInsets(EdgeInsets())
    }
    
    private func getCardIcon() -> Image {
        if (reward.cardType == "Amex Gold") {
            return Image("amexGoldCardIcon")
        }
        else if (reward.cardType == "Amex Platinum") {
            return Image("amexPlatinumCardIcon")
        }
        else if (reward.cardType == "Amex Delta Gold") {
            return Image("amexDeltaGoldCardIcon")
        }
        else if (reward.cardType == "Amex Delta Reserve") {
            return Image("amexDeltaReserveCardIcon")
        }
        else if (reward.cardType == "Amex Hilton Aspire") {
            return Image("amexHiltonAspireCardIcon")
        }
        else{
            return Image("creditCardIcon")
        }
    }
    
    private func getBackgroundColor() -> Color {
        var currentColor: Color
        
        if let firstCard = cardFetchResult.first, let cardColorData = firstCard.cardColor {
            currentColor = dataToColor(cardColorData)
        } else {
            currentColor = Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        }
        
        if (adminMode) {
            currentColor = currentColor.opacity(0.5)
        }
        else if (redeemed) {
            currentColor = Color(#colorLiteral(red: 0, green: 1, blue: 0.4970139265, alpha: 1))
        }
        
        return currentColor
    }
    
    func formatDateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func dataToColor(_ data: Data) -> Color {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
            return Color(uiColor)
        }
        return .gray
    }

    private func onCheckPressed() {
        redeemed.toggle()
        reward.redeemed = redeemed
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
    
    private func loadImage(from path: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        return UIImage(contentsOfFile: documentsDirectory.appendingPathComponent(path).path)
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ListRowView(reward: Reward(), title: "Gold Reward", details: "Description of the reward", value: 50.0, redeemed: true)
            ListRowView(reward: Reward(), title: "Platinum Reward", details: "Another reward detail", value: 100.0, redeemed: false)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}
