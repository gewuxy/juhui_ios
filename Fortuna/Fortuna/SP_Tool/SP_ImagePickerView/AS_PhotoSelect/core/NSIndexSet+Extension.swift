//
//  NSIndexSet+Extension.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/7.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import Foundation

extension IndexSet {

    func aapl_indexPathsFromIndexesWithSection(_ section:Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for (idx, _) in self.enumerated() {
            indexPaths.append(IndexPath.init(item: idx, section: section))
        }
        return indexPaths;
    }
}
