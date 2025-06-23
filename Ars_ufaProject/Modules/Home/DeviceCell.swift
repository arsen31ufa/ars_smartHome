import UIKit
import SnapKit
import SDWebImage

class DeviceCell: UITableViewCell {

    static let reuseIdentifier = "DeviceCell"
    
    // MARK: - UI элементы
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.secondaryBackground
        view.layer.cornerRadius = Constants.CornerRadius.medium
        return view
    }()
    
    private let deviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.CornerRadius.small
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.semibold(size: 15)
        label.textColor = Constants.Colors.text
        label.numberOfLines = 2
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.regular(size: 12)
        label.textColor = Constants.Colors.secondaryText
        label.numberOfLines = 2
        return label
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.medium(size: 12)
        return label
    }()

    // MARK: - Инициализация
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        contentView.backgroundColor = Constants.Colors.background
        contentView.addSubview(containerView)
        
        containerView.addSubview(deviceImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(typeLabel)
        
        let statusStack = UIStackView(arrangedSubviews: [statusIndicator, statusLabel])
        statusStack.spacing = Constants.Padding.small
        statusStack.alignment = .center
        containerView.addSubview(statusStack)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: Constants.Padding.medium, left: Constants.Padding.medium, bottom: Constants.Padding.medium, right: Constants.Padding.medium))
        }
        
        deviceImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Padding.medium)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.Padding.medium)
            make.leading.equalTo(deviceImageView.snp.trailing).offset(Constants.Padding.medium)
            make.trailing.equalToSuperview().offset(-Constants.Padding.medium)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
        }
        
        statusIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(10)
        }
        
        statusStack.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(Constants.Padding.small)
            make.leading.equalTo(nameLabel)
            make.bottom.equalToSuperview().offset(-Constants.Padding.medium)
        }
    }
    
    // MARK: - Конфигурация
    func configure(with device: Device) {
        nameLabel.text = device.name
        typeLabel.text = device.type.rawValue
        
        // Загрузка изображения по URL через SDWebImage
        if let urlString = device.imageUrl, let url = URL(string: urlString) {
            deviceImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            deviceImageView.image = UIImage(systemName: "photo")
        }
        
        if device.isConnected {
            statusIndicator.backgroundColor = .systemGreen
            statusLabel.text = "В сети"
            statusLabel.textColor = .systemGreen
        } else {
            statusIndicator.backgroundColor = .systemGray
            statusLabel.text = "Не в сети"
            statusLabel.textColor = .systemGray
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
} 