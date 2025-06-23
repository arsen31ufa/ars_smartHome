import UIKit
import SnapKit
import DGCharts
import Combine
import Resolver
import SDWebImage

class DeviceDetailsViewController: UIViewController {

    // MARK: - Зависимости
    private var viewModel: DeviceDetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Свойства
    private let device: Device

    // MARK: - UI элементы
    private let headerView = UIView()
    private let deviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.CornerRadius.medium
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.snp.makeConstraints { $0.size.equalTo(60) }
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.semibold(size: 19)
        label.textColor = Constants.Colors.text
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.regular(size: 15)
        label.textColor = Constants.Colors.secondaryText
        label.numberOfLines = 1
        return label
    }()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.medium(size: 14)
        label.textAlignment = .left
        return label
    }()
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.snp.makeConstraints { $0.size.equalTo(10) }
        return view
    }()
    private let metricsStack = UIStackView()
    
    private let telemetrySegmentedControl: UISegmentedControl = {
        let items = ["Температура", "Влажность", "Уровень CO₂", "Энергопотр."]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = Constants.Colors.secondaryBackground
        control.selectedSegmentTintColor = Constants.Colors.primary
        control.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 11, weight: .medium)], for: .normal)
        return control
    }()
    
    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = Constants.Colors.secondaryBackground
        chartView.layer.cornerRadius = Constants.CornerRadius.medium
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.animate(xAxisDuration: 1.0)
        chartView.legend.textColor = Constants.Colors.text
        return chartView
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Инициализация
    init(device: Device) {
        self.device = device
        self.viewModel = DeviceDetailsViewModel(device: device)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchTelemetry(for: .temperature)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Обновить", style: .plain, target: self, action: #selector(refreshTapped))
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.backgroundColor = Constants.Colors.background
        title = ""
        
        // --- Header ---
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Padding.medium)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, typeLabel, statusLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 2
        infoStack.alignment = .leading
        headerView.addSubview(deviceImageView)
        headerView.addSubview(infoStack)
        deviceImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.height.equalTo(60)
        }
        infoStack.snp.makeConstraints { make in
            make.leading.equalTo(deviceImageView.snp.trailing).offset(16)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        // --- Segments ---
        view.addSubview(telemetrySegmentedControl)
        telemetrySegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constants.Padding.medium)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // --- Chart ---
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalTo(telemetrySegmentedControl.snp.bottom).offset(Constants.Padding.medium)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        
        // --- Activity ---
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(chartView)
        }
        
        // --- Fill header ---
        if let urlString = device.imageUrl, let url = URL(string: urlString) {
            deviceImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            deviceImageView.image = UIImage(systemName: "photo")
        }
        nameLabel.text = device.name
        typeLabel.text = device.type.rawValue
        if device.isConnected {
            statusLabel.text = "В сети"
            statusLabel.textColor = .systemGreen
        } else {
            statusLabel.text = "Не в сети"
            statusLabel.textColor = .systemGray
        }
        
        telemetrySegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    // MARK: - Настройка привязок
    private func setupBindings() {
        // Привязка данных к графику
        viewModel.$telemetryData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] entries in
                self?.updateChart(with: entries)
            }
            .store(in: &cancellables)
        
        // Привязка состояния загрузки
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        // Привязка текущих значений метрик
        viewModel.$currentMetrics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] metrics in
                self?.updateMetrics(metrics)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Методы
    private func updateChart(with entries: [ChartDataEntry]) {
        let type = TelemetryType.allCases[telemetrySegmentedControl.selectedSegmentIndex]
        let dataSet = LineChartDataSet(entries: entries, label: type.rawValue)
        
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 3
        dataSet.colors = [Constants.Colors.primary]
        dataSet.fill = ColorFill(color: Constants.Colors.primary)
        dataSet.fillAlpha = 0.3
        dataSet.drawFilledEnabled = true
        dataSet.valueTextColor = Constants.Colors.text
        dataSet.valueFont = Constants.Fonts.regular(size: 10)
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        chartView.animate(xAxisDuration: 0.5)
    }
    
    private func updateMetrics(_ metrics: [String]) {
        // Удаляем metricsStack, ничего не делаем
    }
    
    @objc private func segmentChanged() {
        let selectedType = TelemetryType.allCases[telemetrySegmentedControl.selectedSegmentIndex]
        viewModel.fetchTelemetry(for: selectedType)
    }
    
    @objc private func refreshTapped() {
        let selectedType = TelemetryType.allCases[telemetrySegmentedControl.selectedSegmentIndex]
        viewModel.fetchTelemetry(for: selectedType)
    }
} 