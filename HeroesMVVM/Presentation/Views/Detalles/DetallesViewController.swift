//
//  DetallesViewController.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 28/1/24.
//

import UIKit

class DetallesViewController: UIViewController {
    
    @IBOutlet weak var DescripcionHero: UILabel!
    
    @IBOutlet weak var ImagenHero: UIImageView!
    
    @IBOutlet weak var NameHero: UILabel!
    
    var detalle: Detalles
    private var detallesViewModel: DetallesViewModel
    
    init(detalle: Detalles, detallesViewModel: DetallesViewModel) {
           self.detalle = detalle
           self.detallesViewModel = detallesViewModel
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    func configureView() {
        guard URL(string: detalle.photo) != nil else {
            print("Invalid image URL: \(detalle.photo)")
            return
        }
        if let imageURL = URL(string: detalle.photo) {
            ImagenHero.load(from: imageURL) { [self] in
                print("Image loaded for \(detalle.name)")
            }
        } else {
            print("Error: Invalid URL for image")
        }
        NameHero.text = detalle.name
        DescripcionHero.text = detalle.description
    }
}
