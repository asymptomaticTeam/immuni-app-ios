// ChooseDataUploadModeView.swift
// Copyright (C) 2020 Presidenza del Consiglio dei Ministri.
// Please refer to the AUTHORS file for more information.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import Foundation
import Models
import Tempura

struct HealthPassportVM: ViewModelWithLocalState {}

extension HealthPassportVM {
    init?(state: AppState?, localState _: HealthPassportLS) {
        guard let _ = state else {
            return nil
        }
    }
}
// MARK: - View

class HealthPassportView: UIView, ViewControllerModellableView {
    typealias VM = HealthPassportVM

    private static let horizontalSpacing: CGFloat = 30.0
    static let orderRightMargin: CGFloat = UIDevice.getByScreen(normal: 70, narrow: 50)
    static let labelLeftMargin: CGFloat = 25

    private let backgroundGradientView = GradientView()
    private let title = UILabel()
    private var backButton = ImageButton()
    let scrollView = UIScrollView()
    
    private var imageContentQR = UIImageView()
    private var imageContent = UIImageView()
    private let containerCallCenter = UIView()
    
    private let healthCardCell = HealthCardCellView()

    var didTapBack: Interaction?
    var didTapHealthWorkerMode: Interaction?
    var didTapAutonomousMode: Interaction?

    // MARK: - Setup

    func setup() {
        addSubview(backgroundGradientView)
        addSubview(title)
        addSubview(backButton)
//        addSubview(imageContentQR)
//        addSubview(imageContent)
        addSubview(healthCardCell)

        backButton.on(.touchUpInside) { [weak self] _ in
            self?.didTapBack?()
        }

    }

    // MARK: - Style

    func style() {
        Self.Style.background(self)
        Self.Style.backgroundGradient(backgroundGradientView)
        Self.Style.textFieldIcon2(imageContent)
        Self.Style.textFieldIcon(imageContentQR)

        Self.Style.scrollView(scrollView)
        Self.Style.title(title)

        SharedStyle.navigationBackButton(backButton)
    }

    // MARK: - Update

    func update(oldModel _: VM?) {
        guard let _ = self.model else {
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
        
//        imageContentQR.pin
//            .below(of: title)
//            .marginTop(40)
//            .marginLeft(75)
//            .size(200)
//            .horizontally(12)
////            .vCenter()
//
//        imageContent.pin
//            .below(of: imageContentQR)
//            .size(200)
//            .marginTop(40)
//            .marginLeft(70)
//            .horizontally(12)
//            .vCenter()
        healthCardCell.pin
            .horizontally()
            .marginTop(40)
            .sizeToFit(.width)
            .below(of: title)




    }
}

// MARK: - Style

private extension HealthPassportView {
    enum Style {
        static func textFieldIcon(_ view: UIImageView) {
            view.image = Asset.Settings.UploadData.qrImmuni.image
            view.contentMode = .scaleAspectFit
        }
        static func textFieldIcon2(_ view: UIImageView) {
            view.image = Asset.Home.logoHorizontal.image
            view.contentMode = .scaleAspectFit
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
            let content = "Passaporto sanitario"
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
