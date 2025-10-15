import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct CaffeineTrackerEntry: TimelineEntry {
    let date: Date
    let beverages: [BeverageData]
    let currentCaffeine: Double
    let maxCaffeine: Double
    let totalIntakes: Int
}

// MARK: - Beverage Data Model
struct BeverageData: Identifiable {
    let id: String
    let name: String
    let caffeine: Double
    let volume: Double
    let colorHex: String
    
    var color: Color {
        Color(hex: colorHex) ?? .orange
    }
}

// MARK: - Timeline Provider
struct CaffeineTrackerProvider: TimelineProvider {
    func placeholder(in context: Context) -> CaffeineTrackerEntry {
        CaffeineTrackerEntry(
            date: Date(),
            beverages: getPlaceholderBeverages(),
            currentCaffeine: 150,
            maxCaffeine: 400,
            totalIntakes: 3
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CaffeineTrackerEntry) -> Void) {
        let entry = CaffeineTrackerEntry(
            date: Date(),
            beverages: loadBeverages(),
            currentCaffeine: loadCurrentCaffeine(),
            maxCaffeine: loadMaxCaffeine(),
            totalIntakes: loadTotalIntakes()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CaffeineTrackerEntry>) -> Void) {
        let currentDate = Date()
        let entry = CaffeineTrackerEntry(
            date: currentDate,
            beverages: loadBeverages(),
            currentCaffeine: loadCurrentCaffeine(),
            maxCaffeine: loadMaxCaffeine(),
            totalIntakes: loadTotalIntakes()
        )
        
        // Update every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    // MARK: - Data Loading
    private func loadBeverages() -> [BeverageData] {
        let sharedDefaults = UserDefaults(suiteName: "group.caffeine_tracker.widgets")
        var beverages: [BeverageData] = []
        
        for i in 0..<4 {
            if let id = sharedDefaults?.string(forKey: "beverage_\(i)_id"),
               !id.isEmpty,
               let name = sharedDefaults?.string(forKey: "beverage_\(i)_name"),
               let caffeine = sharedDefaults?.double(forKey: "beverage_\(i)_caffeine"),
               let volume = sharedDefaults?.double(forKey: "beverage_\(i)_volume"),
               let colorHex = sharedDefaults?.string(forKey: "beverage_\(i)_color") {
                
                beverages.append(BeverageData(
                    id: id,
                    name: name,
                    caffeine: caffeine,
                    volume: volume,
                    colorHex: colorHex
                ))
            }
        }
        
        return beverages.isEmpty ? getPlaceholderBeverages() : beverages
    }
    
    private func loadCurrentCaffeine() -> Double {
        let sharedDefaults = UserDefaults(suiteName: "group.caffeine_tracker.widgets")
        return sharedDefaults?.double(forKey: "current_caffeine") ?? 0
    }
    
    private func loadMaxCaffeine() -> Double {
        let sharedDefaults = UserDefaults(suiteName: "group.caffeine_tracker.widgets")
        return sharedDefaults?.double(forKey: "max_caffeine") ?? 400
    }
    
    private func loadTotalIntakes() -> Int {
        let sharedDefaults = UserDefaults(suiteName: "group.caffeine_tracker.widgets")
        return sharedDefaults?.integer(forKey: "total_intakes") ?? 0
    }
    
    private func getPlaceholderBeverages() -> [BeverageData] {
        return [
            BeverageData(id: "1", name: "Caffè", caffeine: 95, volume: 250, colorHex: "#FF6B35"),
            BeverageData(id: "2", name: "Tè", caffeine: 40, volume: 250, colorHex: "#4CAF50"),
            BeverageData(id: "3", name: "Energy", caffeine: 80, volume: 250, colorHex: "#2196F3"),
            BeverageData(id: "4", name: "Cola", caffeine: 34, volume: 330, colorHex: "#9C27B0")
        ]
    }
}

// MARK: - Color Extension
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let length = hexSanitized.count
        let r, g, b, a: Double
        
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            a = Double(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
