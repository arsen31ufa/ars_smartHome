import Foundation
import Combine
import Resolver

class LoginViewModel {
    
    // MARK: - Публикуемые свойства
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var isLoginSuccessful = false
    
    // MARK: - Зависимости
    @Injected private var authService: AuthenticationServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Публичные методы
    func signIn() {
        isLoading = true
        errorMessage = nil
        
        authService.signIn(withEmail: email, password: password)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] user in
                print("Успешный вход пользователя: \(user.email ?? "")")
                self?.isLoginSuccessful = true
            })
            .store(in: &cancellables)
    }
} 