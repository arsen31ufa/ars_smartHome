import Foundation
import Combine

// MARK: - Моковый сервис для работы с устройствами
class MockDeviceService: DeviceServiceProtocol {

    private let mockDevices: [Device] = [
        Device(id: "1", name: "Термостат в гостиной", type: .thermostat, imageUrl: "https://cdn-icons-png.flaticon.com/512/2936/2936956.png", isConnected: true, telemetry: []),
        Device(id: "2", name: "Увлажнитель в спальне", type: .hygrostat, imageUrl: "https://cdn-icons-png.flaticon.com/512/1684/1684375.png", isConnected: false, telemetry: []),
        Device(id: "3", name: "Монитор качества воздуха", type: .airQualityMonitor, imageUrl: "https://cdn-icons-png.flaticon.com/512/2936/2936952.png", isConnected: true, telemetry: []),
        Device(id: "4", name: "Розетка для торшера", type: .smartPlug, imageUrl: "https://cdn-icons-png.flaticon.com/512/3062/3062634.png", isConnected: true, telemetry: [])
    ]

    func fetchDevices() -> AnyPublisher<[Device], Error> {
        // Имитируем задержку сети
        return Just(mockDevices)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchTelemetry(for deviceId: String) -> AnyPublisher<[Telemetry], Error> {
        // Находим устройство по ID
        guard let device = mockDevices.first(where: { $0.id == deviceId }) else {
            let error = NSError(domain: "DeviceServiceError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Устройство не найдено"])
            return Fail(error: error).eraseToAnyPublisher()
        }

        // Генерируем случайные данные для каждого типа телеметрии
        var generatedTelemetry: [Telemetry] = []
        let now = Date()
        
        for type in TelemetryType.allCases {
            // Генерируем 20 точек для каждого графика
            for i in 0..<20 {
                let timestamp = now.addingTimeInterval(-Double(20 - i) * 60) // Каждую минуту за последние 20 минут
                let value: Double
                let unit: String
                
                switch type {
                case .temperature:
                    value = Double.random(in: 18.0...25.0)
                    unit = "°C"
                case .humidity:
                    value = Double.random(in: 40.0...60.0)
                    unit = "%"
                case .co2:
                    value = Double.random(in: 400...1000)
                    unit = "ppm"
                case .power:
                    value = Double.random(in: 0...100)
                    unit = "Вт"
                }
                
                generatedTelemetry.append(Telemetry(type: type, value: round(value * 10) / 10.0, unit: unit, timestamp: timestamp))
            }
        }

        return Just(generatedTelemetry)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
} 