import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    var onFinish: (() -> Void)?
    private var pages: [OnboardingItem] = []
    private var currentIndex = 0
    
    private lazy var pageViewController: UIPageViewController = {
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pvc.dataSource = self
        pvc.delegate = self
        return pvc
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = Color.toiletBackGround
        pc.pageIndicatorTintColor = Color.congestionNone
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.toiletBackGround
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = CornerRadius.normal
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupLayout()
        setupPageViewController()
        updateUI()
    }
    
    private func setupData() {
        pages = [
            OnboardingItem(
                title: "산책가자에 오신 것을 환영합니다",
                subtitle: "내 주변 공원을 찾고, 편안한 산책을 즐겨보세요.",
                imageName: "map.fill",
                isSystemImage: true
            ),
            OnboardingItem(
                title: "실시간 혼잡도 확인",
                subtitle: "공원의 혼잡도를 미리 확인하고, 여유로운 시간을 보내세요.",
                imageName: "person.3.fill",
                isSystemImage: true
            ),
            OnboardingItem(
                title: "다양한 편의 시설 정보",
                subtitle: "화장실, 주차장 등 필요한 시설을 쉽게 찾을 수 있어요.",
                imageName: "info.circle.fill",
                isSystemImage: true
            )
        ]
        pageControl.numberOfPages = pages.count
    }
    
    private func setupUI() {
        view.backgroundColor = Color.sheetColor
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        view.addSubview(pageControl)
        view.addSubview(actionButton)
    }
    
    private func setupLayout() {
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(Pedding.normal)
            make.height.equalTo(50)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(actionButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }
    }
    
    private func setupPageViewController() {
        if let firstPage = makePageViewController(at: 0) {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func makePageViewController(at index: Int) -> OnboardingPageViewController? {
        guard index >= 0 && index < pages.count else { return nil }
        let item = pages[index]
        let vc = OnboardingPageViewController(item: item)
        vc.view.tag = index
        return vc
    }
    
    @objc private func didTapActionButton() {
        if currentIndex == pages.count - 1 {
            onFinish?()
        } else {
            let nextIndex = currentIndex + 1
            if let nextVC = makePageViewController(at: nextIndex) {
                pageViewController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
                currentIndex = nextIndex
                updateUI()
            }
        }
    }
    
    private func updateUI() {
        pageControl.currentPage = currentIndex
        let title = (currentIndex == pages.count - 1) ? "시작하기" : "다음"
        actionButton.setTitle(title, for: .normal)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController else { return nil }
        let index = pageVC.view.tag
        return makePageViewController(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController else { return nil }
        let index = pageVC.view.tag
        return makePageViewController(at: index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first as? OnboardingPageViewController {
            currentIndex = visibleVC.view.tag
            updateUI()
        }
    }
}
