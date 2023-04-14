//
//  UserListViewController.swift
//  TestTaskNativeApp
//
//  Created by Александр Янчик on 13.04.23.
//

import UIKit

class UserListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var usersList: UserModel?
    private var networkeManager = NetworkeManager()
    private var selectdIndex = IndexPath(row: 0, section: 0)
    private var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registrationCell()
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registrationCell() {
        let nib = UINib(nibName: UserListTableViewCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: UserListTableViewCell.id)
    }
    
    private func setupView() {
        self.view.applyGradient(colors: [
            UIColor(
                red: 255/255,
                green: 79/255,
                blue: 128/255,
                alpha: 1
            ).cgColor,
            UIColor(
                red: 194/255,
                green: 58/255,
                blue: 172/255,
                alpha: 1
            ).cgColor
        ])
    }
    
    private func getData() {
        NetworkeManager().getDataInObject { result in
            self.usersList = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } failure: { error in
            self.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }

    }
    
    func getDataWithPagin(page: Int) {
        NetworkeManager().getDataWithPaging(page: page) { result in
            self.usersList?.userContent.append(contentsOf: result.userContent)
            self.usersList?.totalPages = result.totalPages
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } failure: { error in
            self.showAlert(title: "Error", message: "\(error.localizedDescription)")

        }

    }
    
}

extension UserListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return usersList?.userContent.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.id, for: indexPath)
        guard let userListCell = cell as? UserListTableViewCell else { return cell }
        guard let usersList else { return cell}
        userListCell.selectionStyle = .none
        userListCell.set(user: usersList.userContent[indexPath.row])
        
        return userListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let usersList else { return }
        if indexPath.item == usersList.userContent.count - 1 {
            self.page += 1
            if usersList.totalPages != usersList.page {
                getDataWithPagin(page: page)
            }
        }
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        selectdIndex = indexPath
        present(picker, animated: true)
    }
    
}
extension UserListViewController: UINavigationControllerDelegate {
    
}

extension UserListViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let name = usersList?.userContent[selectdIndex.row].name else { return }
        guard let id = usersList?.userContent[selectdIndex.row].id else { return }
        
        NetworkeManager().uploadImage(name: name, id: id, image: image)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
