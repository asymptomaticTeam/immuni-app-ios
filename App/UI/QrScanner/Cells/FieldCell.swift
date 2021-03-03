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

struct FieldCellVM: ViewModel {}

// MARK: - View

class FieldCellView: UIView, ModellableView, ReusableView {
    typealias VM = FieldCellVM
    
    static let containerInset: CGFloat = 25
    static let labelLeftMargin: CGFloat = 25
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
    private var carica = false

    var didTapFieldAction: Interaction?
    
    private let backgroundGradientView = GradientView()
    private let title2 = UILabel()
    
    private let titleAutonomous = UILabel()
    private let iconAutonomous = UIImageView()
    
    private let titleCallCenter = UILabel()
    private let iconCallCenter = UIImageView()

    private let choice = UILabel()
    private var backButton = ImageButton()
    let scrollView = UIScrollView()
    private let headerView = UploadDataAutonomousHeaderView()

    private let textFieldCun = TextFieldCun()
    private let textFieldHealthCard = TextFieldHealthCard()
    private let pickerFieldSymptomsDate = PickerSymptomsDate()
    private let asymptomaticCheckBox = AsymptomaticCheckBox()

    private let containerForm = UIView()
    private let containerCallCenter = UIView()
    
    // MARK: - Setup

    func setup() {
        addSubview(containerForm)

//        containerForm.addSubview(iconAutonomous)
//        containerForm.addSubview(titleAutonomous)
//        containerForm.addSubview(textFieldCun)
//        containerForm.addSubview(textFieldHealthCard)
//        containerForm.addSubview(pickerFieldSymptomsDate)
//        containerForm.addSubview(asymptomaticCheckBox)
//        containerForm.addSubview(actionButtonAutonomous)
        
        addSubview(container)
        container.addSubview(title)
        container.addSubview(message)
        container.addSubview(textFieldCun)
        container.addSubview(scanButton)
        container.addSubview(imageContent)


        container.accessibilityElements = [title, message, codeMessage, textFieldCun, scanButton, uploadButton, imageContent]

        uploadButton.on(.touchUpInside) { [weak self] _ in

        }
        scanButton.on(.touchUpInside) { [weak self] _ in
            guard let self = self else { return }
               self.didTapFieldAction?()
        }
    }

    // MARK: - Style

    func style() {
        Self.Style.container(container)
        Self.Style.title(title)
        Self.Style.message(message, message: "Inserisci il codice del referto")
        Self.Style.message(codeMessage, message: "Ecco il tuo codice")
        let attString = NSAttributedString(string: "")
        Self.Style.code(self.code, codeParts: attString)
        SharedStyle.primaryButton(scanButton, title: "Carica")
        SharedStyle.primaryButton(uploadButton, title: "Carica")
        Self.Style.imageContent(imageContent, image: Asset.Settings.UploadData.stethoscope.image)
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
            .height(280)

        title.pin
            .left(Self.labelLeftMargin)
            .right(Self.orderRightMargin)
            .top(Self.containerInset)
            .sizeToFit(.width)

        message.pin
            .left(Self.labelLeftMargin)
            .right(Self.orderRightMargin)
            .sizeToFit(.width)
            .below(of: title)
            .marginTop(Self.labelTopMargin)
        
        textFieldCun.pin
            .horizontally(25)
            .below(of: message)
            .marginTop(25)
            .height(50)

        scanButton.pin
          .left(Self.labelLeftMargin)
          .right(Self.orderRightMargin)
          .size(buttonSize(for: bounds.width))
          .minHeight(Self.buttonMinHeight)
          .below(of: textFieldCun)
          .marginTop(Self.buttonTopMargin)

        imageContent.pin
            .after(of: title, aligned: .center)
            .sizeToFit()
        
            
            codeMessage.pin
                .horizontally(20)
                .sizeToFit(.width)
                .marginTop(20)
                .marginLeft(100)
                .below(of: scanButton)
            
            code.pin
              .horizontally(20)
              .marginLeft(100)
              .sizeToFit(.width)
              .below(of: codeMessage)

        
    }

    func buttonSize(for width: CGFloat) -> CGSize {
        let labelWidth = width - FieldCellView.orderRightMargin - FieldCellView.labelLeftMargin

        var buttonSize = uploadButton.titleLabel?.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.infinity)) ?? .zero

        buttonSize.width = width - FieldCellView.orderRightMargin - FieldCellView.labelLeftMargin
        buttonSize.height = FieldCellView.buttonMinHeight

        return buttonSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let imageSize = imageContent.intrinsicContentSize
        let labelWidth = size.width - FieldCellView.orderRightMargin - FieldCellView.labelLeftMargin
            - 2 * FieldCellView.containerInset - imageSize.width
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

private extension FieldCellView {
    enum Style {
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
            let content = "Vuoi caricare manualmente il referto?"
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
