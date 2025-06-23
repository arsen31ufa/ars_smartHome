import Foundation
import Combine

// MARK: - Моковый BLE сервис
class MockBLEService: BLEServiceProtocol {

    private let devicesSubject = PassthroughSubject<[Device], Never>()

    var discoveredDevices: AnyPublisher<[Device], Never> {
        return devicesSubject.eraseToAnyPublisher()
    }

    func startScanning() {
        // Имитируем обнаружение устройств
    }

    func stopScanning() {
        // ...
    }
} 