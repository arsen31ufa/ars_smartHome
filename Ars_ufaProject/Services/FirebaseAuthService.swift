import Foundation
import FirebaseAuth
import Combine

// MARK: - Сервис аутентификации через Firebase
class FirebaseAuthService: AuthenticationServiceProtocol {

    var isUserAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }

    func signIn(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let authResult = authResult {
                    let user = User(uid: authResult.user.uid, email: authResult.user.email)
                    promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signUp(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let authResult = authResult {
                    let user = User(uid: authResult.user.uid, email: authResult.user.email)
                    promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
} 