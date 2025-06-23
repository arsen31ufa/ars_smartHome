import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        navigationController.navigationBar.isHidden = false
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = Constants.Colors.primary
        navigationController.setViewControllers([homeVC], animated: true)
    }
    
    func showDeviceDetails(for device: Device) {
        let detailsVC = DeviceDetailsViewController(device: device)
        navigationController.pushViewController(detailsVC, animated: true)
    }
} 