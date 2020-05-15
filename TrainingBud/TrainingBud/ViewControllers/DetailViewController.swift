//
//  DetailViewController.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 16/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

struct CustomData {
    var title: String
    var url: String
    var backgroundImage: UIImage
}

class DetailViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewPop: UIView!
    @IBOutlet weak var imageViewHost: UIImageView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var scrollViewDetail: UIScrollView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var btnJoin1: UIButton!
    
    fileprivate let data = [
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: #imageLiteral(resourceName: "islandZero")),
        CustomData(title: "Subscribe to maxcodes boiiii!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "islandThree")),
        CustomData(title: "StoreKit Course!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "islandZero")),
        CustomData(title: "Collection Views!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "islandZero")),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: #imageLiteral(resourceName: "islandOne")),
    ]
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadView()
        
        view1.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view1.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view1.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view1.trailingAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view1.frame.width/2.5).isActive = true

    }

    private func LoadView() {
         // corner radius
        viewTop.layer.cornerRadius = 30
        // border
        // viewPop.layer.borderWidth = 1.0
        //viewPop.layer.borderColor = UIColor.black.cgColor
        
        //viewTop background color
        viewTop.backgroundColor = UIColor.purple
        // shadow
        viewTop.layer.shadowColor = UIColor.purple.cgColor
        viewTop.layer.shadowOffset = CGSize(width: 3, height: 10)
        viewTop.layer.shadowOpacity = 0.7
        viewTop.layer.shadowRadius = 4.0
        viewTop.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        //Back button
        self.btnBack.layer.cornerRadius = 30
        
        //Join button
        self.btnJoin1.layer.cornerRadius = 10
        self.btnJoin1.clipsToBounds = true
        self.btnJoin1.layer.masksToBounds = false
        self.btnJoin1.layer.shadowRadius = 10
        self.btnJoin1.layer.shadowOpacity = 0.7
        self.btnJoin1.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.btnJoin1.layer.shadowColor = UIColor.black.cgColor
    }

        }

        extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
            }
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return data.count
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
                cell.data = self.data[indexPath.item]
                return cell
            }
        }


        class CustomCell: UICollectionViewCell {
            
            var data: CustomData? {
                didSet {
                    guard let data = data else { return }
                    bg.image = data.backgroundImage
                    
                }
            }
            
            fileprivate let bg: UIImageView = {
               let iv = UIImageView()
                iv.translatesAutoresizingMaskIntoConstraints = false
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
                        iv.layer.cornerRadius = 12
                return iv
            }()
            
            override init(frame: CGRect) {
                super.init(frame: .zero)
                


                
                contentView.addSubview(bg)

                bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
                bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
                bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
