//
//  ProductImageCollectionViewCell.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 11/12/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import CollectionViewPagingLayout

class ProductImageCollectionViewCell: UICollectionViewCell, ScaleTransformView {
    var scaleOptions = ScaleTransformViewOptions(
        minScale: 0.60,
        maxScale: 1.00,
        scaleRatio: 0.40,
        translationRatio: .init(x: 0.66, y: 0.20),
        minTranslationRatio: .init(x: -5.00, y: -5.00),
        maxTranslationRatio: .init(x: 2.00, y: 0.00),
        keepVerticalSpacingEqual: true,
        keepHorizontalSpacingEqual: true,
        scaleCurve: .linear,
        translationCurve: .linear,
        shadowEnabled: true,
        shadowColor: .black,
        shadowOpacity: 0.60,
        shadowRadiusMin: 2.00,
        shadowRadiusMax: 13.00,
        shadowOffsetMin: .init(width: 0.00, height: 2.00),
        shadowOffsetMax: .init(width: 0.00, height: 6.00),
        shadowOpacityMin: 0.10,
        shadowOpacityMax: 0.10,
        blurEffectEnabled: true,
        blurEffectRadiusRatio: 0.20,
        blurEffectStyle: .light,
        rotation3d: nil,
        translation3d: nil
    )
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    // The card view that we apply effects on
    var card: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        // Adjust the card view frame you can use Autolayout too
        let cardFrame = CGRect(x: 15,
                               y: 30,
                               width: frame.width - 30,
                               height: frame.width - 30)
        card = UIImageView(frame: cardFrame)
        contentView.addSubview(card)
    }
}
