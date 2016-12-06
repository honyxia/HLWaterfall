//
//  HLWaterfallLayout.swift
//  HLWaterfall
//
//  Created by hony on 16/12/6.
//  Copyright © 2016年 hony. All rights reserved.
//

import UIKit

/// 定义数据源
protocol HLWaterfallLayoutDataSource: class {
    /// 返回列数
    func numberOfCols(_ waterfallLayout: HLWaterfallLayout) -> Int
    /// 返回每一个 item 的高度
    func waterfallLayout(_ waterfallLayout: HLWaterfallLayout, heightOfItem item: Int) -> CGFloat
}

class HLWaterfallLayout: UICollectionViewFlowLayout {
    
    /// 定义数据源属性
    weak var waterfallDataSource: HLWaterfallLayoutDataSource?
    
    /// cell 对应的 UICollectionViewLayoutAttributes
    fileprivate lazy var layoutAttrs: [UICollectionViewLayoutAttributes] = []
    
    /// 列数（如果外界没有赋值，默认返回3列）
    fileprivate lazy var cols: Int = {
        return self.waterfallDataSource?.numberOfCols(self) ?? 3
    }()
    
    /// 存储每一列的最大Y值
    fileprivate lazy var cellMaxYs: [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
    
    /// 准备布局
    override func prepare() {
        super.prepare()
        
        // 每一个 cell 都对应着一个 UICollectionViewLayoutAttributes 对象，它决定着 cell 怎么去展示
       
        // 获取 collectionView 中 cell 的个数
        let cellCount = collectionView!.numberOfItems(inSection: 0)
        
        let cellW: CGFloat  = (collectionView!.bounds.size.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in 0..<cellCount {
            // 创建第 0 section 的第 i 个cell 对应的 indexPath
            let indexPath = IndexPath(item: i, section: 0)
            // 创建 UICollectionViewLayoutAttributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 高度，从数据源中获取
            guard let cellH: CGFloat = waterfallDataSource?.waterfallLayout(self, heightOfItem: i) else {
                fatalError("请实现数据源方法，返回对应 cell 的高度")
            }
            // 找到所有列中的高度最小的Y值
            let minMaxY = cellMaxYs.min()!
            let minYIndex = cellMaxYs.index(of: minMaxY)!
            let cellX: CGFloat = sectionInset.left + (cellW + minimumInteritemSpacing) * CGFloat(minYIndex)
            let cellY: CGFloat = minMaxY + minimumLineSpacing
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            // 保存 attr
            layoutAttrs.append(attr)
            // 更新数组中的目前高度最低的Y值
            cellMaxYs[minYIndex] = minMaxY + minimumLineSpacing + cellH
        }
    }
    
    /// 返回所有布局
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return layoutAttrs
    }
    
    // 设置 contentSize
    override var collectionViewContentSize: CGSize {
        let h = cellMaxYs.max()! + sectionInset.bottom
        return CGSize(width: 0, height: h)
    }
}
