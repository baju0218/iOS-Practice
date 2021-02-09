//
//  AllPhotosCollectionViewController.swift
//  MyPhotos
//
//  Created by 백종운 on 2021/02/08.
//

import UIKit
import Photos

class AllPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver {

    // MARK: - Property
    
    // Photo
    // 항상 에셋을 새로 가져오면 전부 초기화
    private var allPhotos: PHFetchResult<PHAsset>! {
        didSet {
            selectMode = false
            isSelectedPhotos = [Bool](repeating: false, count: allPhotos.count)
            selectedPhotosCount = 0
            
            OperationQueue.main.addOperation { [weak self] in
                self?.updateUI()
                self?.collectionView.reloadData()
            }
        }
    }
    private var imageManger: PHCachingImageManager = PHCachingImageManager()
    
    // Thumbnail
    private var thumbnailSize: CGSize!
    private var seperatorSize: CGFloat = 4
    
    // Select
    private var selectMode: Bool = false
    private var isSelectedPhotos: [Bool] = [Bool]()
    private var selectedPhotosCount: Int = 0
    
    // MARK: - Initialization
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: - Method
    
    // 에셋이 생성 or 변경되었을 때만 호출하는 함수
    // 에셋이 없는 경우 : 버튼 삭제 및 빈 화면 출력
    // 에셋이 있는 경우 : 버튼을 Select으로 초기화
    private func updateUI() {
        self.navigationItem.title = "All Photos"
        
        if allPhotos.count == 0 {
            self.navigationItem.rightBarButtonItem?.title = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            self.collectionView.backgroundView = UINib(nibName: "EmptyBackgroundView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? UIView
        }
        else {
            self.navigationItem.rightBarButtonItem?.title = "Select"
            self.navigationItem.rightBarButtonItem?.style = .plain
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            self.collectionView.backgroundView = nil
        }
    }
    
    // MARK: - IBAction
    
    // 에셋이 있는 경우에만 버튼이 활성화
    // 사진 선택 모드를 바꿈
    @IBAction func selectButton(_ sender: UIBarButtonItem) {
        selectMode = !selectMode
        
        if selectMode {
            self.navigationItem.title = "Select Items"
            
            sender.title = "Cancel"
            sender.style = .done
            
            self.tabBarController?.tabBar.isHidden = true
            
        }
        else {
            self.navigationItem.title = "All Photos"
            
            sender.title = "Select"
            sender.style = .plain
            
            // 선택된 사진만 컬렉션 뷰에 리로드
            var indexPaths = [IndexPath]()
            isSelectedPhotos.indices.filter{ isSelectedPhotos[$0] }.forEach{ indexPaths.append(IndexPath(item: $0, section: 0)) }
            isSelectedPhotos = [Bool](repeating: false, count: allPhotos.count)
            selectedPhotosCount = 0
            collectionView.reloadItems(at: indexPaths)
            
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: fetchOption)
        PHPhotoLibrary.shared().register(self)
        
        let screenSize = UIScreen.main.bounds
        let thumbnailLength = (min(screenSize.height, screenSize.width) - seperatorSize * 3) / 4
        thumbnailSize = CGSize(width: thumbnailLength, height: thumbnailLength)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "All Photos Collection View Cell", for: indexPath) as? AllPhotosCollectionViewCell else {
            print("error: failed to load all photos collection view cell")
            return UICollectionViewCell()
        }
        let photo = allPhotos[indexPath.item]
        
        // 셀의 이미지는 똑같지만, 알파값을 변경해야 할 때
        if cell.id == photo.localIdentifier {
            cell.alphaView.isHidden = !self.isSelectedPhotos[indexPath.item]
            cell.checkMarkView.isHidden = !self.isSelectedPhotos[indexPath.item]
        }
        // 셀의 이미지를 불러와야할 때
        else {
            cell.id = photo.localIdentifier
            
            imageManger.requestImage(for: photo, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { (image, _) in
                
                if cell.id == photo.localIdentifier {
                    cell.thumbnail.image = image
                    cell.alphaView.isHidden = !self.isSelectedPhotos[indexPath.item]
                    cell.checkMarkView.isHidden = !self.isSelectedPhotos[indexPath.item]
                }
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectMode {
            isSelectedPhotos[indexPath.item] = !isSelectedPhotos[indexPath.item]
            
            if isSelectedPhotos[indexPath.item] { selectedPhotosCount += 1 }
            else { selectedPhotosCount -= 1 }
            
            if selectedPhotosCount == 0 { self.navigationItem.title = "Select Items" }
            else { self.navigationItem.title = "\(selectedPhotosCount) Photos Selected" }
            
            collectionView.reloadItems(at: [indexPath])
        }
        else {
            
        }
        
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: seperatorSize, left: 0, bottom: seperatorSize, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return seperatorSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return seperatorSize
    }
    
    // MARK: - PHPhotoLibraryChangeObserver
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: allPhotos) else {
            return
        }
        
        allPhotos = changes.fetchResultAfterChanges
    }
}
