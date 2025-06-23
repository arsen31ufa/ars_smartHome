import Foundation
import Combine

// MARK: - Моковый сервис аутентификации для тестирования
class MockAuthService: AuthenticationServiceProtocol {
    
    // Имитируем, что пользователь уже залогинен для быстрой разработки
    var isUserAuthenticated: Bool {
        return UserDefaults.standard.bool(forKey: "isMockUserAuthenticated")
    }

    init() {
        UserDefaults.standard.set(false, forKey: "isMockUserAuthenticated")
    }

    func signIn(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            // Имитируем задержку сети
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if email == "test@test.com" && password == "123456" {
                    let user = User(uid: "mock_user_123", email: email)
                    UserDefaults.standard.set(true, forKey: "isMockUserAuthenticated")
                    promise(.success(user))
                } else {
                    let error = NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Неверный email или пароль"])
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signUp(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        // Логика регистрации для мока может быть такой же, как и вход
        return signIn(withEmail: email, password: password)
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            UserDefaults.standard.set(false, forKey: "isMockUserAuthenticated")
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
} 