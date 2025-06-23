import UIKit
import SnapKit
import Combine
import Resolver

class StatisticsViewController: UIViewController {
    // MARK: - ViewModel
    // @Injected private var viewModel: StatisticsViewModel
    private var viewModel = StatisticsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI элементы
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика ScreenTime"
        label.font = Constants.Fonts.bold(size: 24)
        label.textAlignment = .center
        return label
    }()
    private let usageLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.regular(size: 20)
        label.textAlignment = .center
        label.textColor = Constants.Colors.primary
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.regular(size: 15)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Обновить", for: .normal)
        button.titleLabel?.font = Constants.Fonts.semibold(size: 17)
        button.backgroundColor = Constants.Colors.primary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.CornerRadius.medium
        return button
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchUsage()
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.backgroundColor = Constants.Colors.background
        title = "Статистика"
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, usageLabel, errorLabel, refreshButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        refreshButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(160)
        }
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
    }
    
    // MARK: - Привязки
    private func setupBindings() {
        // Привязка времени использования
        viewModel.$usageTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                if time > 0 {
                    let hours = Int(time) / 3600
                    let minutes = (Int(time) % 3600) / 60
                    let seconds = Int(time) % 60
                    self?.usageLabel.text = String(format: "Время в приложении сегодня: %02d:%02d:%02d", hours, minutes, seconds)
                    self?.usageLabel.isHidden = false
                } else {
                    self?.usageLabel.text = "Нет данных о времени использования"
                    self?.usageLabel.isHidden = false
                }
            }
            .store(in: &cancellables)
        // Привязка ошибок
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] msg in
                if let msg = msg, !msg.isEmpty {
                    self?.errorLabel.text = msg
                    self?.errorLabel.isHidden = false
                    self?.usageLabel.isHidden = true
                } else {
                    self?.errorLabel.text = nil
                    self?.errorLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Действия
    @objc private func refreshTapped() {
        viewModel.fetchUsage()
    }
} 