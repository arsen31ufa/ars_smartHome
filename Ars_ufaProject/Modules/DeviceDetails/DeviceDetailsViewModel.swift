import Foundation
import Combine
import Resolver
import DGCharts

class DeviceDetailsViewModel {
    
    // MARK: - Публикуемые свойства
    @Published private(set) var telemetryData: [ChartDataEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentMetrics: [String] = []
    
    // MARK: - Свойства
    let device: Device
    
    // MARK: - Зависимости
    @Injected private var deviceService: DeviceServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(device: Device) {
        self.device = device
        // Логика экрана деталей будет здесь
    }
    
    // MARK: - Публичные методы
    func fetchTelemetry(for type: TelemetryType) {
        isLoading = true
        errorMessage = nil
        
        deviceService.fetchTelemetry(for: device.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] telemetry in
                // Фильтруем данные по нужному типу и преобразуем в точки для графика
                let entries = telemetry
                    .filter { $0.type == type }
                    .enumerated()
                    .map { (index, data) -> ChartDataEntry in
                        return ChartDataEntry(x: Double(index), y: data.value)
                    }
                self?.telemetryData = entries
                // Формируем массив строк с текущими значениями всех метрик
                var metrics: [String] = []
                for t in TelemetryType.allCases {
                    if let last = telemetry.filter({ $0.type == t }).last {
                        metrics.append("\(t.rawValue): \(last.value) \(last.unit)")
                    } else {
                        metrics.append("\(t.rawValue): —")
                    }
                }
                self?.currentMetrics = metrics
            })
            .store(in: &cancellables)
    }
} 