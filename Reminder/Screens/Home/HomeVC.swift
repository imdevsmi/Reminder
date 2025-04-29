//
//  HomeVC.swift
//  Reminder
//
//  Created by Sami Gündoğan on 28.04.2025.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    private let homeVM: HomeVMProtocol = HomeVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        homeVM.loadTasksFromStorage()
        
        view.backgroundColor = .systemBackground
        setupUI()
        
        homeVM.loadAvailableDates(for: 30)
        homeVM.loadTasksFromStorage()
        homeVM.updateSelectedDate(at: 0)
        
        welcomeLabel.text = homeVM.greetingText
        dateCollectionView.reloadData()
        taskCollectionView.reloadData()
    }
    
    private lazy var dateCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
        
        return collectionView
    }()
    
    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Reminder"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var taskCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let taskCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        taskCollectionView.backgroundColor = .systemBackground
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        taskCollectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.reuseIdentifier)
        taskCollectionView.showsVerticalScrollIndicator = false
        
        return taskCollectionView
    }()
    
    private var addButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func addButtonTapped() {
        
        let addTaskVC = NewTaskVC()
        
        addTaskVC.modalPresentationStyle = .overFullScreen
        present(addTaskVC, animated: true, completion: nil)
    }
    
    private func setupUI() {
        
        view.addSubview(taskCollectionView)
        view.addSubview(addButton)
        view.addSubview(dateCollectionView)
        view.addSubview(welcomeLabel)
        
        dateCollectionView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            // date constraints
            dateCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dateCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            dateCollectionView.heightAnchor.constraint(equalToConstant: 48),
            
            // welcome label constraint
            welcomeLabel.topAnchor.constraint(equalTo: dateCollectionView.bottomAnchor, constant: 4),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            //reminder constraint
            taskCollectionView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            taskCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            taskCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            
            //button constraint
            addButton.widthAnchor.constraint(equalToConstant: 80),
            addButton.heightAnchor.constraint(equalToConstant: 80),
            addButton.topAnchor.constraint(equalTo: taskCollectionView.bottomAnchor, constant: 16) ,
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView {
            // Örnek: 7 günlük bir range gösterebiliriz veya 30 gün vs.
            return homeVM.availableDates.count
        } else {
            // Reminder'lar
            return homeVM.tasksForSelectedDate.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionView {
            // Kullanıcının seçtiği tarih indexPath.item ile alınır
            // ViewModel’e bu index gönderilir, ilgili tarih selectedDate olarak ayarlanır
            homeVM.updateSelectedDate(at: indexPath.item)

            // Seçilen tarihe göre reminder listesi filtreleneceği için yeniden yüklenir
            taskCollectionView.reloadData()
        }else if collectionView == taskCollectionView {
            let updateSelectedDate = homeVM.availableDates[indexPath.item]
            print("Selected task: \(updateSelectedDate)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dateCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            let date = homeVM.availableDates[indexPath.item]
            var content = UIListContentConfiguration.cell()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM"
            content.text = formatter.string(from: date)
            content.textProperties.alignment = .center
            content.textProperties.color = .label
            content.textProperties.numberOfLines = 0
            content.textProperties.font = .systemFont(ofSize: 13, weight: .regular)
            cell.contentConfiguration = content

            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.reuseIdentifier, for: indexPath) as! TaskCollectionViewCell
            let task = homeVM.tasksForSelectedDate[indexPath.item]
            cell.configure(with: task)
          

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dateCollectionView {
            return CGSize(width: 80, height: 48)
        } else {
            let width = collectionView.bounds.width
            return CGSize(width: width, height: 80)
        }
    }
}

#Preview {
    HomeVC()
}
