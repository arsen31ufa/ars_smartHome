import Foundation
import Combine

// MARK: - Протокол сервиса для работы с устройствами
protocol DeviceServiceProtocol {
    func fetchDevices() -> AnyPublisher<[Device], Error>
    func fetchTelemetry(for deviceId: String) -> AnyPublisher<[Telemetry], Error>
}

// Реализация сервиса устройств
class DeviceService: DeviceServiceProtocol {
    init() {}
    
    func fetchDevices() -> AnyPublisher<[Device], Error> {
        // Моковые данные
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchTelemetry(for deviceId: String) -> AnyPublisher<[Telemetry], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
} 