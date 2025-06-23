import Foundation
import Combine
#if !targetEnvironment(simulator)
import DeviceActivity
import FamilyControls
#endif

// Протокол для сервиса сбора ScreenTime
protocol UserActivityServiceProtocol {
    /// Получить время использования приложения за сегодня (в секундах)
    func fetchActivity() -> AnyPublisher<TimeInterval, Error>
}

// MARK: - Реализация с реальным ScreenTime (iOS 16+) и fallback для симулятора
class UserActivityServiceImpl: UserActivityServiceProtocol {
    func fetchActivity() -> AnyPublisher<TimeInterval, Error> {
        #if targetEnvironment(simulator)
        // Для симулятора возвращаем моковые данные
        let mockTime: TimeInterval = 1 * 3600 + 23 * 60
        return Just(mockTime)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        #else
        // Для реального устройства используем DeviceActivityReport
        return Future { promise in
            Task {
                do {
                    // Запрашиваем разрешение (однократно, можно вынести в отдельный сервис)
                    let center = AuthorizationCenter.shared
                    try? await center.requestAuthorization(for: .individual)

                    let store = DeviceActivityReportStore()
                    let interval = DateInterval(start: Calendar.current.startOfDay(for: Date()), end: Date())
                    let predicate = DeviceActivityReport.Predicate(applications: .all)
                    let reports = try await store.activities(for: predicate, during: interval)

                    // Суммируем usageTime для текущего приложения
                    let bundleID = Bundle.main.bundleIdentifier ?? ""
                    var total: TimeInterval = 0
                    for (_, activity) in reports {
                        if let appUsage = activity.applicationActivity[ApplicationToken(bundleIdentifier: bundleID)] {
                            total += appUsage.totalActivityDuration
                        }
                    }
                    promise(.success(total))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        #endif
    }
}

// MARK: - Моковая реализация для тестов
class MockUserActivityService: UserActivityServiceProtocol {
    func fetchActivity() -> AnyPublisher<TimeInterval, Error> {
        let mockTime: TimeInterval = 42 * 60 // 42 минуты
        return Just(mockTime)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
} 