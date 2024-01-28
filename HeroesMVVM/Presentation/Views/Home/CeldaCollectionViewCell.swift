//
//  CollectionViewCell.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 27/1/24.
//

import UIKit


class CeldaCollectionViewCell: UITableViewCell {
    @IBOutlet weak var ImagenHeroe: UIImageView!
    
    @IBOutlet weak var NameHeroe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
    }
    func setupConstraints() {
            // Asegúrate de que la imagen tenga restricciones para todos los lados
            ImagenHeroe.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                ImagenHeroe.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                ImagenHeroe.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                ImagenHeroe.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                ImagenHeroe.widthAnchor.constraint(equalToConstant: 180),
                ImagenHeroe.heightAnchor.constraint(equalToConstant: 180)
            ])

            NameHeroe.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NameHeroe.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                NameHeroe.leadingAnchor.constraint(equalTo: ImagenHeroe.trailingAnchor, constant: 8),
                NameHeroe.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                NameHeroe.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
    
    func configure(with hero: HeroModel) {
        print("Configuring cell for hero: \(hero.name)")
        
        NameHeroe.text = hero.name
        
        if let imageURL = URL(string: hero.photo) {
            ImagenHeroe.load(from: imageURL) {
                print("Image loaded for \(hero.name)")
            }
        } else {
            print("Error: Invalid URL for image")
        }
    }
}
extension UIImageView {
    func load(from url: URL, completion: @escaping () -> Void) {
        print("Loading image from URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Error loading image from URL: \(url)")
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    print("Error creating image from data")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
                print("Image loaded successfully")
                completion() // Llamada al bloque de finalización
            }
        }.resume()
    }
}
