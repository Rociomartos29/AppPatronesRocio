//
//  HViewController.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 28/1/24.
//

import UIKit
private let reuseIdentifier = "HomeCell"

class HViewController: UIViewController {
    
    private var homeViewModel: HomeViewModel

    @IBOutlet weak var Mitable: UITableView!
    init(homeViewModel: HomeViewModel = HomeViewModel()) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Mitable.register(UINib(nibName: "CeldaCollectionViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        Mitable.delegate = self
        Mitable.dataSource = self
        //Mitable.estimatedRowHeight = 200// Ajusta este valor según tus necesidades
        Mitable.rowHeight = UITableView.automaticDimension
        homeViewModel.loadHero()
        setObserver()
    }
    
    private func setObserver() {
        homeViewModel.homeStatusLoad = { [weak self] status in
            switch status {
            case .loading:
                print("Home Loading")
            case .loaded:
                self?.Mitable.reloadData()
            case .error:
                print("Home Error \(NetworkError.self)")
            case .none:
                print("Home None")
            }
        }
    }
}
extension HViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHero = homeViewModel.heroes[indexPath.row]
        
        let detalles = Detalles(id: selectedHero.id, name: selectedHero.name, description: selectedHero.description, photo: selectedHero.photo, favorite: false)
        
        let nextVM = DetallesViewModel(detallesUseCase: DetallesUseCase(), heroName: selectedHero.name)
        nextVM.loadDetalle()
        
        let detallesVC = DetallesViewController(detalle: detalles, detallesViewModel: nextVM)
        navigationController?.pushViewController(detallesVC, animated: true)

    }
}

extension HViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.heroes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! CeldaCollectionViewCell

        // Configura la celda con el modelo correspondiente
        let hero = homeViewModel.heroes[indexPath.item]
        cell.configure(with: hero)

        return cell
    }
}
