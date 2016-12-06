//
//  ViewController.swift
//  HLWaterfall
//
//  Created by hony on 16/12/6.
//  Copyright © 2016年 hony. All rights reserved.
//

import UIKit

/// cell注册标识符
private let kContentCellID = "kContentCellID"

class ViewController: UIViewController {
    
    /// collectionView
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = HLWaterfallLayout()
        // 设置每个 section 的内容的间距
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // 垂直滚动情况下，表示同一行的两个item之间的间距
        layout.minimumInteritemSpacing = 10
        // 垂直滚动情况下，表示连续行之间的行间距
        layout.minimumLineSpacing = 10
        // 设置数据源
        layout.waterfallDataSource = self
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        // 使用 kContentCellID 注册 cell class
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        cell.backgroundColor = UIColor.blue
        // 移除label
        for subv in cell.contentView.subviews {
            if subv.isKind(of: UILabel.self) {
                subv.removeFromSuperview()
            }
        }
        // 添加label
        let label = setupLabel(text: "\(indexPath.item)")
        cell.contentView.addSubview(label)
        
        return cell
    }
    
    private func setupLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        return label
    }
}

// MARK: - HLWaterfallLayoutDataSource
extension ViewController: HLWaterfallLayoutDataSource {
    func numberOfCols(_ waterfallLayout: HLWaterfallLayout) -> Int {
        return 3
    }
    func waterfallLayout(_ waterfallLayout: HLWaterfallLayout, heightOfItem item: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(100)) + 50.0
    }
}
