import WidgetKit
import SwiftUI

// MARK: - Single Beverage Widget View (Small)
struct SingleBeverageWidgetView: View {
    let entry: CaffeineTrackerEntry
    
    var beverage: BeverageData {
        entry.beverages.first ?? BeverageData(
            id: "default",
            name: "Caffè",
            caffeine: 95,
            volume: 250,
            colorHex: "#FF6B35"
        )
    }
    
    var body: some View {
        ZStack {
            // Background with beverage color
            beverage.color
            
            VStack(alignment: .leading, spacing: 8) {
                // Emoji icon
                Text(getEmoji(for: beverage.name))
                    .font(.system(size: 32))
                
                Spacer()
                
                // Beverage name
                Text(beverage.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                // Caffeine amount
                HStack(spacing: 4) {
                    Text("\(Int(beverage.caffeine))mg")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(12)
                }
                
                // Volume
                Text("\(Int(beverage.volume))ml")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
    }
    
    private func getEmoji(for name: String) -> String {
        let lowercased = name.lowercased()
        if lowercased.contains("caffè") || lowercased.contains("coffee") || lowercased.contains("espresso") {
            return "☕️"
        } else if lowercased.contains("tè") || lowercased.contains("tea") {
            return "🍵"
        } else if lowercased.contains("energy") {
            return "⚡️"
        } else if lowercased.contains("cola") || lowercased.contains("soda") {
            return "🥤"
        } else {
            return "☕️"
        }
    }
}

// MARK: - Quick Add Grid Widget View (Medium)
struct QuickAddGridWidgetView: View {
    let entry: CaffeineTrackerEntry
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Quick Add")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            // Grid 2x2
            VStack(spacing: 8) {
                // First row
                HStack(spacing: 8) {
                    if entry.beverages.count > 0 {
                        BeverageCardView(beverage: entry.beverages[0])
                    }
                    if entry.beverages.count > 1 {
                        BeverageCardView(beverage: entry.beverages[1])
                    }
                }
                
                // Second row
                HStack(spacing: 8) {
                    if entry.beverages.count > 2 {
                        BeverageCardView(beverage: entry.beverages[2])
                    }
                    if entry.beverages.count > 3 {
                        BeverageCardView(beverage: entry.beverages[3])
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color(UIColor.systemBackground))
    }
}

// MARK: - Beverage Card View
struct BeverageCardView: View {
    let beverage: BeverageData
    
    var body: some View {
        ZStack {
            beverage.color
            
            VStack(spacing: 4) {
                // Emoji
                Text(getEmoji(for: beverage.name))
                    .font(.system(size: 24))
                
                // Name
                Text(beverage.name)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                // Caffeine
                Text("\(Int(beverage.caffeine))mg")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(8)
            }
            .padding(8)
        }
        .cornerRadius(16)
    }
    
    private func getEmoji(for name: String) -> String {
        let lowercased = name.lowercased()
        if lowercased.contains("caffè") || lowercased.contains("coffee") || lowercased.contains("espresso") {
            return "☕️"
        } else if lowercased.contains("tè") || lowercased.contains("tea") {
            return "🍵"
        } else if lowercased.contains("energy") {
            return "⚡️"
        } else if lowercased.contains("cola") || lowercased.contains("soda") {
            return "🥤"
        } else {
            return "☕️"
        }
    }
}

// MARK: - Caffeine Gauge Widget View (Medium/Large)
struct CaffeineGaugeWidgetView: View {
    let entry: CaffeineTrackerEntry
    
    var percentage: Double {
        guard entry.maxCaffeine > 0 else { return 0 }
        return min((entry.currentCaffeine / entry.maxCaffeine) * 100, 100)
    }
    
    var gaugeColor: Color {
        switch percentage {
        case 0...25:
            return .green
        case 25...50:
            return .yellow
        case 50...75:
            return .orange
        default:
            return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Greeting
            Text(getGreeting())
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            // Circular gauge
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 100, height: 100)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: CGFloat(percentage / 100))
                    .stroke(gaugeColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                // Center text
                VStack(spacing: 2) {
                    Text("\(Int(entry.currentCaffeine))mg")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("/ \(Int(entry.maxCaffeine))mg")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            // Intakes count
            Text("\(entry.totalIntakes) assunzioni oggi")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Buongiorno ☕️"
        } else if hour < 17 {
            return "Buon pomeriggio ☕️"
        } else {
            return "Buonasera ☕️"
        }
    }
}

// MARK: - Widget Configuration
@main
struct CaffeineTrackerWidget: Widget {
    let kind: String = "CaffeineTrackerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaffeineTrackerProvider()) { entry in
            CaffeineTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Caffeine Tracker")
        .description("Track your caffeine intake")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Entry View
struct CaffeineTrackerWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: CaffeineTrackerEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SingleBeverageWidgetView(entry: entry)
        case .systemMedium:
            QuickAddGridWidgetView(entry: entry)
        default:
            CaffeineGaugeWidgetView(entry: entry)
        }
    }
}

// MARK: - Previews
struct CaffeineTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = CaffeineTrackerEntry(
            date: Date(),
            beverages: [
                BeverageData(id: "1", name: "Caffè", caffeine: 95, volume: 250, colorHex: "#FF6B35"),
                BeverageData(id: "2", name: "Tè", caffeine: 40, volume: 250, colorHex: "#4CAF50"),
                BeverageData(id: "3", name: "Energy", caffeine: 80, volume: 250, colorHex: "#2196F3"),
                BeverageData(id: "4", name: "Cola", caffeine: 34, volume: 330, colorHex: "#9C27B0")
            ],
            currentCaffeine: 150,
            maxCaffeine: 400,
            totalIntakes: 3
        )
        
        Group {
            CaffeineTrackerWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small - Single Beverage")
            
            CaffeineTrackerWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Medium - Quick Add Grid")
        }
    }
}
