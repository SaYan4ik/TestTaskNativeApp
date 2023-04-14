//
//  UserListTableViewCell.swift
//  TestTaskNativeApp
//
//  Created by Александр Янчик on 13.04.23.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    private var user: UserContentModel? {
        didSet {
            dataSetup()
        }
    }
    
    static var id = String(describing: UserListTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImageView.image = UIImage(systemName: "person")
    }
    
    func set(user: UserContentModel) {
        self.user = user
    }
    
    private func loadImage(url: String) {
        DispatchQueue.global().async { [weak self] in
            guard let self,
                  let imageURL = URL(string: url),
                  let data = try? Data(contentsOf: imageURL),
                  let resultImage = UIImage(data: data)
            else { return}
            
            DispatchQueue.main.async {
                self.avatarImageView.image = resultImage
            }
        }
    }
    
    private func dataSetup() {
        guard let user else { return }
        self.nameLabel.text = user.name
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height / 2
        self.container.layer.cornerRadius = 20
        
        guard let imageString = user.image else { return }
        loadImage(url: imageString)
        
    }
    
}
