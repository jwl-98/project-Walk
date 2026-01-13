import UIKit
import SnapKit

class OnboardingPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let item: OnboardingItem
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Color.toiletBackGround
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Lifecycle
    
    init(item: OnboardingItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureData()
    }
    
    // MARK: - Configuration
    
    private func configureUI() {
        view.backgroundColor = Color.sheetColor
        view.addSubview(imageView)
        view.addSubview(textStackView)
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.width.height.equalTo(200)
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(Pedding.normal)
        }
    }
    
    private func configureData() {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        
        if item.isSystemImage {
            imageView.image = UIImage(systemName: item.imageName)
        } else {
            imageView.image = UIImage(named: item.imageName)
        }
    }
}
