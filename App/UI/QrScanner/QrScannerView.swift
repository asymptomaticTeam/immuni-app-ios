
import Foundation
import Models
import Tempura
import Lottie

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
     var choiceMargin: CGFloat = 10

    private let backgroundGradientView = GradientView()
    private let title = UILabel()
    private let choice = UILabel()
//    private let code = UILabel()
    private var backButton = ImageButton()
    let scrollView = UIScrollView()

    private let scannerCard = ScannerCellView()
    private let fieldCard = FieldCellView()
    let checkmark = AnimationView()
    let titleLabel = UILabel()
    let detailsLabel = UILabel()

    var didTapBack: Interaction?
    var didTapScanAction: Interaction?
    var didTapUploadAction: Interaction?
    var success = false
    // MARK: - Setup

    func setup() {
        addSubview(backgroundGradientView)
        addSubview(scrollView)
        addSubview(title)
        addSubview(backButton)
        self.addSubview(self.checkmark)
        self.addSubview(self.titleLabel)
        self.addSubview(self.detailsLabel)
//        addSubview(code)


        scrollView.addSubview(scannerCard)
        scrollView.addSubview(choice)
        
        scrollView.addSubview(fieldCard)

        backButton.on(.touchUpInside) { [weak self] _ in
            self?.didTapBack?()
        }
        scannerCard.didTapScanAction = { [weak self] in
            self?.choiceMargin = 90
            self?.setNeedsLayout()
            self?.didTapScanAction?()
        }
        scannerCard.didTapUploadAction = { [weak self] in
            self?.success.toggle()
            self?.subviews.first?.removeFromSuperview()
            self?.subviews.first?.removeFromSuperview()
            self?.subviews.first?.removeFromSuperview()
            self?.subviews.first?.removeFromSuperview()
            self?.setNeedsLayout()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self?.didTapBack?()
               // Code you want to be delayed
            }
        }
        fieldCard.didTapFieldAction = { [weak self] in
            self?.success.toggle()
            self?.subviews.first?.removeFromSuperview()
            self?.subviews.first?.removeFromSuperview()
            self?.subviews.first?.removeFromSuperview()
            self?.subviews.first?.removeFromSuperview()
            self?.setNeedsLayout()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self?.didTapBack?()
               // Code you want to be delayed
            }
        }
        
        

    }

    // MARK: - Style

    func style() {
        Self.Style.root(self)
        Self.Style.animation(self.checkmark, animation: AnimationAsset.confirmationCheck.animation)
        Self.Style.background(self)
        Self.Style.backgroundGradient(backgroundGradientView)

        Self.Style.scrollView(scrollView)
        Self.Style.title(title)
        Self.Style.details(choice, details: "Oppure")

        Self.Style.titleLabel(self.titleLabel, content: "Dati caricati con successo")
        Self.Style.details(self.detailsLabel, details: "Grazie per il tuo contributo")

        

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
        if !success {
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
            
        choice.pin
            .below(of: scannerCard)
            .marginTop(choiceMargin)
            .horizontally(Self.horizontalSpacing + backButton.intrinsicContentSize.width + 5)
            .sizeToFit(.width)
            
        fieldCard.pin
            .horizontally()
            .below(of: choice)
            .sizeToFit(.width)
            .marginTop(15)

        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: fieldCard.frame.maxY)
        }
        else {
            self.titleLabel.pin
              .horizontally(30)
              .sizeToFit(.width)
              .top(to: self.edge.vCenter)

            self.checkmark.pin
              .size(100)
              .hCenter()
              .bottom(to: self.edge.vCenter)

            self.detailsLabel.pin
              .horizontally(30)
              .below(of: self.titleLabel)
              .marginTop(20)
              .sizeToFit(.width)
        }
    }
}

// MARK: - Style

private extension ScannerView {
    enum Style {
        

        static func root(_ view: UIView) {
          view.backgroundColor = Palette.white
        }

        static func animation(_ view: AnimationView, animation: Animation?) {
          view.animation = animation
          view.loopMode = .playOnce
          view.playIfPossible()
        }

        static func titleLabel(_ label: UILabel, content: String) {
          let style = TextStyles.h1.byAdding(
            .color(Palette.grayDark),
            .alignment(.center)
          )

          TempuraStyles.styleStandardLabel(
            label,
            content: content,
            style: style
          )
        }

        static func details(_ label: UILabel, details: String?) {
          let style = TextStyles.p.byAdding(
            .color(Palette.grayNormal),
            .alignment(.center)
          )

          TempuraStyles.styleStandardLabel(
            label,
            content: details,
            style: style
          )
        
      }
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
