import UIKit
import Resolver

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        // Всегда показываем экран авторизации при запуске
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didFinishAuth(coordinator: AuthCoordinator) {
        // Убираем AuthCoordinator из дочерних, так как он свою работу выполнил
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        // Запускаем главный экран
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
} 