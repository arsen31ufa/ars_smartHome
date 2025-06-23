import Foundation

// MARK: - Типы телеметрии
enum TelemetryType: String, CaseIterable {
    case temperature = "Температура"
    case humidity = "Влажность"
    case co2 = "Уровень CO₂"
    case power = "Энергопотребление"
}

// MARK: - Модель данных телеметрии
struct Telemetry {
    let type: TelemetryType
    let value: Double
    let unit: String
    let timestamp: Date
}

// MARK: - Тип устройства
enum DeviceType: String {
    case thermostat = "Термостат"
    case hygrostat = "Гигростат"
    case airQualityMonitor = "Монитор кач-ва воздуха"
    case smartPlug = "Умная розетка"
    case unknown = "Неизвестное устройство"
}

// MARK: - Модель устройства
struct Device: Identifiable, Equatable {
    let id: String
    let name: String
    let type: DeviceType
    let imageUrl: String?
    var isConnected: Bool
    var telemetry: [Telemetry]
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id
    }
} 