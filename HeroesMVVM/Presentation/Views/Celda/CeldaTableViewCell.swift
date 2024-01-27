//
//  TableViewCell.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 26/1/24.
//

import UIKit

class CeldaTableViewCell: UITableViewCell {
    static let identifier = "HomeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Puedes configurar propiedades de estilo aquí si es necesario
    }
    
    @IBAction func NextBoton(_ sender: Any) {
    }
    func configure(with hero: HeroModel) {
        DispatchQueue.main.async {
            guard let url = URL(string: hero.photo) else {
                print("Invalid image URL: \(hero.photo)")
                return
            }
            self.textLabel?.text = hero.name
            self.imageView?.load(from: url){
                // Este bloque será llamado cuando la carga de la imagen esté completa
                print("Image loading completed for \(url)")
            }
        }
    }
}
