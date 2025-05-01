//
//  HomeVC.swift
//  Reminder
//
//  Created by Sami Gündoğan on 28.04.2025.
//

import UIKit
import SnapKit

// MARK: - HomeVC

class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let homeVM: HomeVMProtocol = HomeVM()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewTaskAdded), name: .didAddNewTask, object: nil)

        homeVM.loadAvailableDates(for: 30)
        homeVM.loadTasksFromStorage()
        homeVM.updateSelectedDate(at: 0)

        welcomeLabel.text = homeVM.greetingText
        dateCollectionView.reloadData()
        taskCollectionView.reloadData()
        
        greetingStackView.addArrangedSubview(welcomeLabel)
        greetingStackView.addArrangedSubview(calendarButton)

        view.addSubview(greetingStackView)

        NSLayoutConstraint.activate([
            greetingStackView.topAnchor.constraint(equalTo: dateCollectionView.bottomAnchor, constant: 16),
            greetingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            greetingStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeVM.loadTasksFromStorage()
        if let selectedDate = homeVM.selectedDate,
           let index = homeVM.availableDates.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: selectedDate) }) {
            homeVM.updateSelectedDate(at: index)
        }
        
        taskCollectionView.reloadData()
    }
    
    @objc private func handleNewTaskAdded() {
        homeVM.loadTasksFromStorage()
        
        if let selectedDate = homeVM.selectedDate,
           let index = homeVM.availableDates.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: selectedDate) }) {
            homeVM.updateSelectedDate(at: index)
        }

        taskCollectionView.reloadData()
    }
    
    // MARK: - UI Elements
    
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
        label.text = "Good Morning Sami"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        let image = UIImage(systemName: "calendar", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let greetingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 36
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 32
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var welcomeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, calendarButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    // MARK: - Actions
    
    @objc func addButtonTapped() {
        let addTaskVC = NewTaskVC()
        addTaskVC.modalPresentationStyle = .overFullScreen
        present(addTaskVC, animated: true, completion: nil)
    }
    
    @objc private func calendarButtonTapped() {
        
    }
    
    // MARK: - Layout
    
    private func setupUI() {
        view.addSubview(taskCollectionView)
        view.addSubview(addButton)
        view.addSubview(dateCollectionView)
        view.addSubview(welcomeLabel)
        
        dateCollectionView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dateCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateCollectionView.heightAnchor.constraint(equalToConstant: 48),
            
            welcomeLabel.topAnchor.constraint(equalTo: dateCollectionView.bottomAnchor, constant: 4),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            taskCollectionView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            taskCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            taskCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            
            addButton.widthAnchor.constraint(equalToConstant: 64),
            addButton.heightAnchor.constraint(equalToConstant: 64),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        /*
        welcomeLabel.snp.makeConstraints { make in
            welcomeLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.leading.equalToSuperview().offset(0)
                make.trailing.equalToSuperview().offset(0)
                make.height.equalTo(48)
            }
        }
         */
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView {
            return homeVM.availableDates.count
        } else {
            return homeVM.tasksForSelectedDate.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionView {
            homeVM.updateSelectedDate(at: indexPath.item)
            taskCollectionView.reloadData()
        } else if collectionView == taskCollectionView {
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
            formatter.dateFormat = "dd MMM"
            content.text = formatter.string(from: date)
            content.textProperties.alignment = .center
            content.textProperties.numberOfLines = 1
            
            let isToday = Calendar.current.isDateInToday(date)
            let isPast = date < Date().startOfDay()
            let isSelected = Calendar.current.isDate(date, inSameDayAs: homeVM.selectedDate ?? Date())
            
            if isToday {
                content.textProperties.font = .boldSystemFont(ofSize: 16)
                content.textProperties.color = .black
            } else {
                content.textProperties.font = .systemFont(ofSize: 16)
                content.textProperties.color = .lightGray
            }

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

extension HomeVC: TaskCellDelegate {
    func didToggleTaskCompletion(_ task: Task) {
        homeVM.updateTask(task)
        taskCollectionView.reloadData()
    }
}

// MARK: - Preview

#Preview {
    HomeVC()
}
