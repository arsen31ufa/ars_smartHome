import UIKit
import SnapKit
import Combine
import Resolver

class LoginViewController: UIViewController {

    // MARK: - Координатор
    weak var coordinator: AuthCoordinator?

    // MARK: - Зависимости
    // @Injected private var viewModel: LoginViewModel
    private var viewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI элементы
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Умный Дом"
        label.font = Constants.Fonts.bold(size: 34)
        label.textColor = Constants.Colors.primary
        label.textAlignment = .center
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = Constants.Colors.primary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.CornerRadius.medium
        button.titleLabel?.font = Constants.Fonts.semibold(size: 17)
        return button
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.backgroundColor = Constants.Colors.background
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = Constants.Padding.medium
        stackView.setCustomSpacing(Constants.Padding.large, after: titleLabel)
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.Padding.large)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Настройка привязок
    private func setupBindings() {
        // Привязка текстовых полей к ViewModel
        emailTextField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        // Привязка состояния загрузки
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loginButton.isEnabled = !isLoading
                self?.loginButton.alpha = isLoading ? 0.5 : 1.0
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        // Привязка сообщения об ошибке
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if let message = message {
                    self?.showErrorAlert(message: message)
                }
            }
            .store(in: &cancellables)
            
        // Привязка успешного входа
        viewModel.$isLoginSuccessful
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccess in
                if isSuccess {
                    self?.coordinator?.didFinishAuth()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Действия
    @objc private func loginButtonTapped() {
        viewModel.signIn()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Расширение для Publisher из UITextField
extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
} 