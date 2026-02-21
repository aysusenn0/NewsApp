//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Aysu on 20.02.2026.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageUrl: URL?
    var imageData: Data? = nil  //datada saklanacak ve sürekli çekilmeyecek resimler

    init(title: String, subtitle: String, imageUrl: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
}
class NewsTableViewCell: UITableViewCell {
    
    static let identifier: String = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let newsSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsSubTitleLabel)
        contentView.addSubview(newsTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame = CGRect(
            x: 5,
            y: 0,
            width: contentView.frame.size.width - 150,
            height: 70
        )
        newsSubTitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height / 2
        )
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 145,
            y: 0,
            width: 150,
            height: contentView.frame.size.height - 10
        )
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsSubTitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsSubTitleLabel.text = viewModel.subtitle
        //Image :
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageUrl {
            //fetch the image
            URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
                guard let data = data, error == nil else { return }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
