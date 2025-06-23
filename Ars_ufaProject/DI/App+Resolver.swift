import Foundation
import Resolver
import UIKit
import DGCharts

// MARK: - Регистрация зависимостей
extension Resolver: @retroactive ResolverRegistering {
    public static func registerAllServices() {
        // MARK: - Сервисы
        register { MockAuthService() as AuthenticationServiceProtocol }
        register { MockDeviceService() as DeviceServiceProtocol }
        //register { BLEService() as BLEServiceProtocol }.implements(BLEServiceProtocol.self).scope(.application)
        register { UserActivityServiceImpl() as UserActivityServiceProtocol }

        // MARK: - ViewModels
        //register { LoginViewModel() }
        //register { HomeViewModel() }
        //register { _, args in DeviceDetailsViewModel(device: args()) }
        //register { StatisticsViewModel() }
        //register { SettingsViewModel() }
    }
} 
