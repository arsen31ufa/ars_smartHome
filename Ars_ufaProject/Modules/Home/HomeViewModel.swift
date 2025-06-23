import Foundation
import Combine
import Resolver

class HomeViewModel {
    
    // MARK: - Публикуемые свойства
    @Published private(set) var devices: [Device] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Зависимости
    @Injected private var deviceService: DeviceServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Публичные методы
    func fetchDevices() {
        isLoading = true
        errorMessage = nil
        
        deviceService.fetchDevices()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] devices in
                self?.devices = devices
            })
            .store(in: &cancellables)
    }
} 