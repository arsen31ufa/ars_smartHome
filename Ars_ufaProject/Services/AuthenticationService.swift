import Foundation
import Combine

// MARK: - Протокол сервиса аутентификации
protocol AuthenticationServiceProtocol {
    var isUserAuthenticated: Bool { get }
    func signIn(withEmail email: String, password: String) -> AnyPublisher<User, Error>
    func signUp(withEmail email: String, password: String) -> AnyPublisher<User, Error>
    func signOut() -> AnyPublisher<Void, Error>
}

// Реализация сервиса аутентификации
class AuthenticationService: AuthenticationServiceProtocol {
    var isUserAuthenticated: Bool { false }
    func signIn(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        // Моковая реализация
        return Fail(error: NSError(domain: "Not implemented", code: 0)).eraseToAnyPublisher()
    }
    func signUp(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        return Fail(error: NSError(domain: "Not implemented", code: 0)).eraseToAnyPublisher()
    }
    func signOut() -> AnyPublisher<Void, Error> {
        return Fail(error: NSError(domain: "Not implemented", code: 0)).eraseToAnyPublisher()
    }
} 