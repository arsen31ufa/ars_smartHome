import UIKit
import SnapKit
import Combine
import Resolver

class HomeViewController: UIViewController {

    // MARK: - Координатор
    weak var coordinator: HomeCoordinator?

    // MARK: - Зависимости
    // @Injected private var viewModel: HomeViewModel
    private var viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI элементы
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchDevices()
        setupStatisticsButton()
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.backgroundColor = Constants.Colors.background
        title = "Мои устройства"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Настройка таблицы
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DeviceCell.self, forCellReuseIdentifier: DeviceCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Настройка привязок
    private func setupBindings() {
        // Обновление таблицы при изменении списка устройств
        viewModel.$devices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Отображение индикатора загрузки
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
            
        // Отображение ошибок
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if let message = message {
                    // TODO: Показать алерт с ошибкой
                    print("Ошибка: \(message)")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Кнопка статистики
    private func setupStatisticsButton() {
        let statsButton = UIBarButtonItem(title: "Статистика", style: .plain, target: self, action: #selector(statisticsTapped))
        navigationItem.rightBarButtonItem = statsButton
    }
    
    @objc private func statisticsTapped() {
        let statsVC = StatisticsViewController()
        navigationController?.pushViewController(statsVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.reuseIdentifier, for: indexPath) as? DeviceCell else {
            return UITableViewCell()
        }
        let device = viewModel.devices[indexPath.row]
        cell.configure(with: device)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let device = viewModel.devices[indexPath.row]
        coordinator?.showDeviceDetails(for: device)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
} 