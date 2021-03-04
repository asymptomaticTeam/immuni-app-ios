//
//  HealthCardCell.swift
//  Immuni
//
//  Created by Lorenzo Spinucci on 03/03/21.
//

//
//  CheckStatusCell.swift
//  Immuni
//
//  Created by Lorenzo Spinucci on 03/03/21.
//

// DataUploadHealthWorkerMode.swift
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
import Tempura

import Extensions

struct HealthCardCellVM: ViewModel {}

// MARK: - View

class HealthCardCellView: UIView, ModellableView, ReusableView {
    typealias VM = HealthCardCellVM
    
    static let containerInset: CGFloat = 25
    static let labelLeftMargin: CGFloat = 40
    static let labelBottomMargin: CGFloat = 10
    static let imageRightMargin: CGFloat = 10
    static let labelTopMargin: CGFloat = 10
    static let buttonTopMargin: CGFloat = 20
    static let buttonMinHeight: CGFloat = 55
    static let containerMinHeight: CGFloat = 245
    static let orderRightMargin: CGFloat = UIDevice.getByScreen(normal: 70, narrow: 50)
    var heightContainer: CGFloat = 220

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        style()
    }

    private let container = UIView()
    private let title = UILabel()
    private let message = UILabel()
    private let codeMessage = UILabel()
    private var scanButton = ButtonWithInsets()
    private var uploadButton = ButtonWithInsets()
    private var imageContent = UIImageView()
    private let code = UILabel()
    private let tampone = UILabel()
    private let vaccino1 = UILabel()
    private let vaccino2 = UILabel()
    private let status = UILabel()
    private var carica = false
    
    private var imageContentQR = UIImageView()
    private var imageContentImmuni = UIImageView()

    var didTapUploadAction: Interaction?
    var didTapScanAction: Interaction?
    
    private let backgroundGradientView = GradientView()
    private let title2 = UILabel()
    
    private let titleAutonomous = UILabel()
    private let iconAutonomous = UIImageView()
    
    private let titleCallCenter = UILabel()
    private let iconCallCenter = UIImageView()

    private var backButton = ImageButton()
    let scrollView = UIScrollView()
    private let headerView = UploadDataAutonomousHeaderView()

    private let textFieldCun = TextFieldCun()
    private let textFieldHealthCard = TextFieldHealthCard()
    private let pickerFieldSymptomsDate = PickerSymptomsDate()
    private let asymptomaticCheckBox = AsymptomaticCheckBox()

    private let containerForm = UIView()
    private let containerCallCenter = UIView()

    private var actionButtonAutonomous = ButtonWithInsets()
    private var actionButtonCallCenter = ButtonWithInsets()
    
    // MARK: - Setup

    func setup() {
        
        addSubview(container)
        container.addSubview(imageContentQR)
        container.addSubview(imageContentImmuni)

        container.accessibilityElements = [imageContentImmuni, imageContentQR]

        scanButton.on(.touchUpInside) { [weak self] _ in
            guard let self = self else { return }
            
            Self.Style.code(self.code, codeParts: NSAttributedString(string: "74936292"))
//            SharedStyle.primaryButton(self.scanButton, title: "Carica")
            self.heightContainer = 420
            self.setNeedsLayout()
            
            if self.carica {
                self.carica.toggle()
            }
            else{
                self.carica.toggle()
                self.didTapScanAction?()
            }
        }
    }

    // MARK: - Style

    func style() {
        Self.Style.textFieldIcon2(imageContentImmuni)
        Self.Style.textFieldIcon(imageContentQR)
        Self.Style.container(container)
    
    }

    // MARK: - Update

    func update(oldModel _: VM?) {
        guard let _ = model else {
            return
        }
        setNeedsLayout()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        container.pin
            .vertically()
            .horizontally(25)
            .marginTop(Self.labelTopMargin)
            .height(400)

                imageContentQR.pin
//                    .below(of: title)
//                    .marginTop(60)
                    .top(20)
                    .marginLeft(50)
                    .size(200)
                    .horizontally(12)
        //            .vCenter()
        
                imageContentImmuni.pin
                    .below(of: imageContentQR)
                    .size(200)
//                    .marginTop(20)
                    .marginLeft(50)
                    .horizontally(12)
                    .vCenter()
        
      
    }

    func buttonSize(for width: CGFloat) -> CGSize {
        let labelWidth = width - CheckStatusCellView.orderRightMargin - CheckStatusCellView.labelLeftMargin

        var buttonSize = uploadButton.titleLabel?.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.infinity)) ?? .zero

        buttonSize.width = width - CheckStatusCellView.orderRightMargin - CheckStatusCellView.labelLeftMargin
        buttonSize.height = CheckStatusCellView.buttonMinHeight

        return buttonSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let imageSize = imageContent.intrinsicContentSize
        let labelWidth = size.width - CheckStatusCellView.orderRightMargin - CheckStatusCellView.labelLeftMargin
            - 2 * CheckStatusCellView.containerInset - imageSize.width
        let titleSize = self.title.sizeThatFits(CGSize(width: labelWidth, height: .infinity))
        let messageSize = self.message.sizeThatFits(CGSize(width: labelWidth, height: .infinity))
        let buttonSize = self.uploadButton.sizeThatFits(CGSize(width: labelWidth, height: .infinity))

        return CGSize(
            width: size.width,
            height: max(titleSize.height + messageSize.height + buttonSize.height + 2 * Self.containerInset
                            + Self.labelBottomMargin + Self.buttonTopMargin, Self.containerMinHeight)
        )
    }
}

// MARK: - Style

private extension HealthCardCellView {
    enum Style {
        static func textFieldIcon(_ view: UIImageView) {
            view.image = Asset.Settings.UploadData.qrImmuni.image
            view.contentMode = .scaleAspectFit
        }
        static func textFieldIcon2(_ view: UIImageView) {
            view.image = Asset.Home.logoHorizontal.image
            view.contentMode = .scaleAspectFit
        }
        
        static func code(_ label: UILabel, codeParts: NSAttributedString) {
          let baseStyle = UIDevice.getByScreen(normal: TextStyles.alphanumericCode, narrow: TextStyles.alphanumericCodeSmall)
          let textStyle = baseStyle.byAdding(
            .color(Palette.grayDark),
            .alignment(.left),
            .lineBreakMode(.byTruncatingTail)
          )
            
            TempuraStyles.styleShrinkableLabel(
                label,
                content: codeParts.string,
                style: textStyle,
                numberOfLines: 2
            )

        }
        
        static func container(_ view: UIView) {
            view.backgroundColor = Palette.white
            view.layer.cornerRadius = SharedStyle.cardCornerRadius
            view.addShadow(.cardLightBlue)
        }

        static func title(_ label: UILabel) {
            let content = "Vuoi fare una scansione di un passaporto?"
            let textStyle = TextStyles.h4.byAdding(
                .color(Palette.purple),
                .alignment(.left)
            )

            TempuraStyles.styleStandardLabel(
                label,
                content: content,
                style: textStyle
            )
        }

        static func message(_ label: UILabel, message: String) {
            let content = message
            let textStyle = TextStyles.p.byAdding(
                .color(Palette.grayNormal),
                .alignment(.left)
            )

            TempuraStyles.styleStandardLabel(
                label,
                content: content,
                style: textStyle
            )
        }

        static func imageContent(_ imageView: UIImageView, image: UIImage) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
        }
    }
}
