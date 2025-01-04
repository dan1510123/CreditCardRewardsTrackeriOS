//
//  MRListRowView.swift
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
    
    var body: some View {
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
        .padding()
        .background(getBackgroundColor())
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
        .listRowInsets(EdgeInsets()) // Allow full-width custom styling
    }
    
    private func getCardIcon() -> Image {
        if (reward.cardType == "Gold") {
            return Image("goldCardIcon")
        }
        else if (reward.cardType == "Platinum") {
            return Image("platCardIcon")
        }
        else if (reward.cardType == "Delta Gold") {
            return Image("deltaGoldCardIcon")
        }
        else if (reward.cardType == "Delta Reserve") {
            return Image("deltaReserveCardIcon")
        }
        else if (reward.cardType == "Hilton Aspire") {
            return Image("hiltonAspireCardIcon")
        }
        else{
            return Image("creditCardIcon")
        }
    }
    
    private func getBackgroundColor() -> Color {
        if(redeemed) {
            return Color(#colorLiteral(red: 0, green: 1, blue: 0.4970139265, alpha: 1))
        }
        else if (reward.cardType == "Gold") {
            return Color(#colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1))
        }
        else if (reward.cardType == "Platinum") {
            return Color(#colorLiteral(red: 0.8980392157, green: 0.8941176471, blue: 0.968627451, alpha: 1))
        }
        else if (reward.cardType == "Delta Gold") {
            return Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
        }
        else if (reward.cardType == "Delta Reserve") {
            return Color(#colorLiteral(red: 0.6868614554, green: 0.403000772, blue: 1, alpha: 1))
        }
        else if (reward.cardType == "Hilton Aspire") {
            return Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
        }
        else{
            return Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        }
    }
    
    func formatDateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
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
