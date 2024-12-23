// Category.swift

import Foundation
import SwiftUI

// MARK: - Category Model
struct Category: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var colorHex: String // Store color as HEX string for Codable compliance

    init(id: UUID = UUID(), name: String, color: Color) {
        self.id = id
        self.name = name
        self.colorHex = color.toHex() // Convert Color to HEX string
    }
}

// MARK: - Color Extension to Handle HEX Conversion
extension Color {
    /// Converts a Color to its HEX string representation.
    func toHex() -> String {
        let uiColor = UIColor(self)
        guard let components = uiColor.cgColor.components, components.count >= 3 else {
            return "#FFFFFF" // Default to white if conversion fails
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(r * 255),
                      lroundf(g * 255),
                      lroundf(b * 255))
    }

    /// Initializes a Color from a HEX string.
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count

        var r, g, b: Double
        switch length {
        case 6:
            r = Double((rgb & 0xFF0000) >> 16) / 255
            g = Double((rgb & 0x00FF00) >> 8) / 255
            b = Double(rgb & 0x0000FF) / 255
        default:
            return nil
        }

        self.init(red: r, green: g, blue: b)
    }
}

