import Foundation
import Combine
import Resolver

class StatisticsViewModel: ObservableObject {
    @Published var usageTime: TimeInterval = 0
    @Published var errorMessage: String?
    
    @Injected private var userActivityService: UserActivityServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsage() {
        userActivityService.fetchActivity()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] time in
                self?.usageTime = time
            })
            .store(in: &cancellables)
    }
} 