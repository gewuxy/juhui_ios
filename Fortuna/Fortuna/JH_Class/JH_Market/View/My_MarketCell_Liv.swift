//
//  My_MarketCell_Liv.swift
//  Fortuna
//
//  Created by LCD on 2017/8/23.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
class My_MarketCell_Liv: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, M_Market_Liv>>()
    
    let dataCells = Variable([SectionModel<Int, M_Market_Liv>]())
    
    var _selectBlock:((M_Market_Liv)->Void)?
}

extension My_MarketCell_Liv {
    class func show(_ tableView:UITableView) -> My_MarketCell_Liv {
        return tableView.dequeueReusableCell(withIdentifier: "My_MarketCell_Liv") as! My_MarketCell_Liv
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeCollectionView()
        dataCells.value = [
            SectionModel(model:0,items:[M_Market_Liv()]),
            SectionModel(model:1,items:[M_Market_Liv()]),
            SectionModel(model:2,items:[M_Market_Liv()]),
            SectionModel(model:3,items:[M_Market_Liv()]),
            SectionModel(model:4,items:[M_Market_Liv()]),
            SectionModel(model:5,items:[M_Market_Liv()]),
            SectionModel(model:5,items:[M_Market_Liv()])
        ]
    }
    fileprivate func makeCollectionView() {
        //collectionView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        dataSource.configureCell = { (dataSource, coll, indexPath, model) in
            let cell = My_MarketItem_Liv.show(coll, indexPath)
            return cell
        }
        dataCells.asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        collectionView.rx
            .modelSelected(M_Market_Liv.self)
            .subscribe(onNext: { [weak self](model) in
                //self?.collectionView.deselectItem(at: self!.collectionView.indexPathsForSelectedItems, animated: true)
                self?._selectBlock?(model)
            }).addDisposableTo(disposeBag)
    }
    
    
}
/*
extension My_MarketCell_Liv:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}*/

class My_MarketItem_Liv: UICollectionViewCell {
    class func show(_ collectionView:UICollectionView, _ indexPath:IndexPath) -> My_MarketItem_Liv {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "My_MarketItem_Liv", for: indexPath) as! My_MarketItem_Liv
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var lab_1: UILabel!
    @IBOutlet weak var lab_2: UILabel!
    @IBOutlet weak var lab_3: UILabel!
    @IBOutlet weak var lab_4: UILabel!
    
}
