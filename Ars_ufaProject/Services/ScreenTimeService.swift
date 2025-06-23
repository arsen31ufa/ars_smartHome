import Foundation
import Combine
import FamilyControls

// MARK: - Сервис для работы с ScreenTime API
class ScreenTimeService: UserActivityServiceProtocol {

    func fetchActivity() -> AnyPublisher<TimeInterval, Error> {
        // Здесь будет логика работы с ScreenTime API
        // Пока возвращаем моковое значение
        return Just(3600.0) // 1 час
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
} 