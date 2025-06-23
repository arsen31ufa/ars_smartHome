import UIKit

// MARK: - Константы для всего приложения
enum Constants {
    
    // MARK: - Цвета
    enum Colors {
        static let primary = UIColor(red: 1.00, green: 0.65, blue: 0.00, alpha: 1.00) // #FFA500
        static let background = UIColor.systemGroupedBackground
        static let secondaryBackground = UIColor.secondarySystemGroupedBackground
        static let text = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00) // #333333
        static let secondaryText = UIColor.secondaryLabel
    }
    
    // MARK: - Шрифты
    enum Fonts {
        static func regular(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        
        static func medium(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        
        static func semibold(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        
        static func bold(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
    
    // MARK: - Отступы
    enum Padding {
        static let small: CGFloat = 8.0
        static let medium: CGFloat = 16.0
        static let large: CGFloat = 24.0
    }
    
    // MARK: - Радиусы скругления
    enum CornerRadius {
        static let small: CGFloat = 8.0
        static let medium: CGFloat = 12.0
        static let large: CGFloat = 16.0
    }
} 