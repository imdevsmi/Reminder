//
//  HomeVC.swift
//  Reminder
//
//  Created by Sami Gündoğan on 28.04.2025.
//

import SnapKit
import UIKit


// MARK: - HomeVC

class HomeVC: UIViewController {

    // MARK: - Properties

    private let homeVM: HomeVMProtocol = HomeVM()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didAddNewTask, object: nil)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        view.backgroundColor = .systemBackground
        setupUI()

        NotificationCenter.default.addObserver(self, selector: #selector(handleNewTaskAdded), name: .didAddNewTask, object: nil)

        homeVM.onTasksUpdated = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.taskCollectionView.reloadData()
            }
        }
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

    // MARK: - Selectors

    @objc private func handleNewTaskAdded() {
        homeVM.loadTasksFromStorage()
    }

    @objc func addButtonTapped() {
        let addTaskVC = NewTaskVC()
        addTaskVC.modalPresentationStyle = .overCurrentContext
        present(addTaskVC, animated: true, completion: nil)
    }

    @objc private func calendarButtonTapped() {
        
    }

    // MARK: - UI Elements

    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let itemWidth = (UIScreen.main.bounds.width - 32) / 5
        layout.itemSize = CGSize(width: itemWidth, height: 48)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier) 
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()

    private let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "calendar", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        
        return button
    }()

    private let greetingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 36
        stackView.alignment = .center
        
        return stackView
    }()

    private lazy var taskCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        let itemWidth = UIScreen.main.bounds.width - 32
        layout.itemSize = CGSize(width: itemWidth, height: 52)

        let taskCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        taskCollectionView.backgroundColor = .systemBackground
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        taskCollectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.reuseIdentifier)
        taskCollectionView.showsVerticalScrollIndicator = false
        taskCollectionView.collectionViewLayout.invalidateLayout()
        taskCollectionView.reloadData()
        
        return taskCollectionView
    }()

    private lazy var addButton: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 56, weight: .regular)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        imageView.image = image
        imageView.tintColor = .label
        imageView.backgroundColor = .systemBackground
        imageView.layer.cornerRadius = 28
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonTapped)))
        
        return imageView
    }()

    private let remindersTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Reminders"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()

    // MARK: - Layout

    private func setupUI() {
        view.addSubview(dateCollectionView)
        view.addSubview(greetingStackView)
        view.addSubview(taskCollectionView)
        view.addSubview(addButton)
        view.addSubview(remindersTitleLabel)
        greetingStackView.addArrangedSubview(welcomeLabel)
        greetingStackView.addArrangedSubview(calendarButton)
        
        homeVM.loadAvailableDates(for: 30)
        homeVM.loadTasksFromStorage()
        homeVM.updateSelectedDate(at: 0)

        welcomeLabel.text = homeVM.greetingText
        dateCollectionView.reloadData()
        taskCollectionView.reloadData()

        dateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(48)
        }
        
        taskCollectionView.snp.makeConstraints { make in
            make.top.equalTo(remindersTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(addButton.snp.top).offset(-24)
        }

        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

        remindersTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(33)
        }
        
        greetingStackView.snp.makeConstraints { make in
            make.top.equalTo(dateCollectionView.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-16)
        }
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
            let selectedTask = homeVM.tasksForSelectedDate[indexPath.item]
            print("Selected task: \(selectedTask.title)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dateCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as! DateCell
            let date = homeVM.availableDates[indexPath.item]
            let isToday = Calendar.current.isDateInToday(date)

            cell.configure(with: date, isToday: isToday)
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
            return CGSize(width: width, height: 52)
        }
    }
    
    
}

// MARK: - TaskCellDelegate

extension HomeVC: TaskCellDelegate {
    func didToggleTaskCompletion(_ task: Task) {
        homeVM.updateTask(task)
        if let selectedIndexPath = getIndexPath(for: task) {
            taskCollectionView.reloadItems(at: [selectedIndexPath])
        }
    }
    
    private func getIndexPath(for task: Task) -> IndexPath? {
        if let index = homeVM.tasksForSelectedDate.firstIndex(where: { $0.id == task.id }) {
            return IndexPath(item: index, section: 0)
        }
        return nil
    }
}

// MARK: - Preview

#Preview {
    HomeVC()
}
