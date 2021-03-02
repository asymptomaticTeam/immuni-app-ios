
import Foundation
import Models
import Tempura

struct ScannerVM: ViewModelWithLocalState {}

extension ScannerVM {
    init?(state: AppState?, localState _: ScannerLS) {
        guard let _ = state else {
            return nil
        }
    }
}

// MARK: - View

class ScannerView: UIView, ViewControllerModellableView {
    typealias VM = ScannerVM

    private static let horizontalSpacing: CGFloat = 30.0
    static let orderRightMargin: CGFloat = UIDevice.getByScreen(normal: 70, narrow: 50)
    static let labelLeftMargin: CGFloat = 25

    private let backgroundGradientView = GradientView()
    private let title = UILabel()
    private var backButton = ImageButton()
    let scrollView = UIScrollView()

    private let scannerCard = ScannerCellView()

    var didTapBack: Interaction?
    var didTapScannerAction: Interaction?

    // MARK: - Setup

    func setup() {
        addSubview(backgroundGradientView)
        addSubview(scrollView)
        addSubview(title)
        addSubview(backButton)

        scrollView.addSubview(scannerCard)

        backButton.on(.touchUpInside) { [weak self] _ in
            self?.didTapBack?()
        }
        scannerCard.didTapAction = { [weak self] in
            self?.didTapScannerAction?()
        }

    }

    // MARK: - Style

    func style() {
        Self.Style.background(self)
        Self.Style.backgroundGradient(backgroundGradientView)

        Self.Style.scrollView(scrollView)
        Self.Style.title(title)

        SharedStyle.navigationBackButton(backButton)
    }

    // MARK: - Update

    func update(oldModel _: VM?) {
        guard let _ = model else {
            return
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundGradientView.pin.all()

        backButton.pin
            .left(Self.horizontalSpacing)
            .top(universalSafeAreaInsets.top + 20)
            .sizeToFit()

        title.pin
            .vCenter(to: backButton.edge.vCenter)
            .horizontally(Self.horizontalSpacing + backButton.intrinsicContentSize.width + 5)
            .sizeToFit(.width)

        scrollView.pin
            .horizontally()
            .below(of: title)
            .marginTop(5)
            .bottom(universalSafeAreaInsets.bottom)

        scannerCard.pin
            .horizontally()
            .sizeToFit(.width)
            .marginTop(25)


        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scannerCard.frame.maxY)
    }
}

// MARK: - Style

private extension ScannerView {
    enum Style {
        static func background(_ view: UIView) {
            view.backgroundColor = Palette.grayWhite
        }

        static func backgroundGradient(_ gradientView: GradientView) {
            gradientView.isUserInteractionEnabled = false
            gradientView.gradient = Palette.gradientBackgroundBlueOnBottom
        }

        static func scrollView(_ scrollView: UIScrollView) {
            scrollView.backgroundColor = .clear
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            scrollView.showsVerticalScrollIndicator = false
        }

        static func title(_ label: UILabel) {
            let content = "Scansione documenti"
            TempuraStyles.styleShrinkableLabel(
                label,
                content: content,
                style: TextStyles.navbarSmallTitle.byAdding(
                    .color(Palette.grayDark),
                    .alignment(.center)
                ),
                numberOfLines: 2
            )
        }
    }
}
