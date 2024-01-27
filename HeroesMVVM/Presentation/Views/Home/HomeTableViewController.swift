//
//  HomeTableViewController.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import UIKit

class HomeTableViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    // ViewModel
    private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel = HomeViewModel()) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.register(UINib(nibName: "CeldaTableViewCell", bundle: nil), forCellReuseIdentifier: CeldaTableViewCell.identifier)
        
        homeViewModel.loadHero()
        setObserver()
        
        // Precargar las imágenes antes de que la tabla sea visible
        let dispatchGroup = DispatchGroup()
        
        for hero in homeViewModel.heroes {
            if let url = URL(string: hero.photo) {
                let imageView = UIImageView()
                imageView.load(from: url) {
                    // Este bloque será llamado cuando la carga de la imagen esté completa
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }

    private func setObserver() {
        homeViewModel.homeStatusLoad = { [weak self] status in
            switch status {
            case .loading:
                print("Home Loading")
            case .loaded:
                self?.tableViewOutlet.reloadData()
            case .error:
                print("Home Error \(NetworkError.self)")
            case .none:
                print("Home None")
            }
        }
    }
}

// MARK: - Extension Delegate
extension HomeTableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: NAVEGAR AL DETALLLE
        
    }
    
}

extension HomeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CeldaTableViewCell.identifier, for: indexPath) as! CeldaTableViewCell
        let hero = homeViewModel.heroes[indexPath.row]
        cell.configure(with: hero)
        return cell
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
