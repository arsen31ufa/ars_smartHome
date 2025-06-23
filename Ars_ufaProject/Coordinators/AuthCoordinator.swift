import UIKit
import Resolver

protocol AuthCoordinatorDelegate: AnyObject {
    func didFinishAuth(coordinator: AuthCoordinator)
}

class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: AuthCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func didFinishAuth() {
        delegate?.didFinishAuth(coordinator: self)
    }
} 