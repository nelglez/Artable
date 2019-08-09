//
//  ViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/7/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet weak var loginOutButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categories = [Category]()
    var selectedCategory: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        setupCollectionView()
        
        setupInitialAnonymousUser()
    
    }
    //Called every single time when the view appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCategoriesListener()
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
        loginOutButton.title = "Logout"
        } else {
            loginOutButton.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener.remove() //Saves you data $$$
        categories.removeAll()
        collectionView.reloadData()
    }
    
   
    private func setupInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously() { (result, error) in
                if let error = error {
                    print("Error signing user anonymously: \(error.localizedDescription)")
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    return
                }
            }
        }
    }
    
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCellNibFile, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    }
    
    
    private func setCategoriesListener() {
        listener = db.categories.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
                
            })
        })
    }
    
  
    
    private func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    


    @IBAction func logInOutPressed(_ sender: UIBarButtonItem) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                    }
                     self.presentLoginController()
                }
            } catch {
                print(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }
    }
    

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    private func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    private func onDocumentModified(change: DocumentChange, category: Category) {
        if change.newIndex == change.oldIndex {
            //Item changed but it is still in the same position
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            //Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    private func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCollectionViewCell {
        
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width //Getting width of current device
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCategory = categories[indexPath.item]
        
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destinationVC = segue.destination as? ProductsViewController {
                destinationVC.category = selectedCategory
            }
        }
    }
    
}

//Prior Code Left for reference

//    private func fetchDocument() {
//        let docRef = db.collection("categories").document("MbjP1DgbKzEsM98fG2UR") // reference to the database
//
//        docRef.addSnapshotListener { (snapshot, error) in
//            self.categories.removeAll()
//            guard let data = snapshot?.data() else { return }
//
//            let newCategory = Category(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
//
////        docRef.getDocument { (snapshot, error) in
////
////            guard let data = snapshot?.data() else { return }
////
////            let newCategory = Category(data: data)
////            self.categories.append(newCategory)
////            self.collectionView.reloadData()
////        }
//
//    }
//
//    private func fetchCollection() {
//        let collectionReference = db.collection("categories")
//
//
//
//       listener = collectionReference.addSnapshotListener { (snapshot, error) in
//            guard let documents = snapshot?.documents else { return }
//
//        print(snapshot?.documentChanges.count)
//
//            self.categories.removeAll()
//            for doc in documents {
//                let data = doc.data()
//                let newCategory = Category(data: data)
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }
//    }
