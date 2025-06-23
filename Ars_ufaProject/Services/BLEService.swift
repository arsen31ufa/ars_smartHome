import Foundation
import Combine

// MARK: - Протокол BLE сервиса
protocol BLEServiceProtocol {
    func startScanning()
    func stopScanning()
    var discoveredDevices: AnyPublisher<[Device], Never> { get }
}

// Реализация BLE-сервиса
class BLEService: BLEServiceProtocol {
    init() {}
    var discoveredDevices: AnyPublisher<[Device], Never> {
        Just([]).eraseToAnyPublisher()
    }
    func startScanning() {}
    func stopScanning() {}
} 