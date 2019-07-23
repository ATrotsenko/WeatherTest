//
//  MainWeatherViewController.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/22/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

protocol MainWeatherView: class {
    func reload()
}

class MainWeatherViewController: BaseAbstractViewController, MainWeatherView {
    
    @IBOutlet weak var generalWeatherView: GeneralWeatherView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    var viewModel: MainWeatherViewModel
    
    // MARK: - Initialization
    init(viewModel: MainWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: MainWeatherViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupTableView()
        
        viewModel.connect(to: self)
        viewModel.getWeather(coordinates: nil)
    }

    func setupTableView() {
        tableView.registerCell(WeatherTableViewCell.self)
    }
    
    func setupCollectionView() {
        collectionView.registerCell(WeatherCollectionViewCell.self)
    }
    
    // MARK: - Action
    @IBAction func locationButtonAction(_ button: UIButton) {
        
    }
    
    func reload() {
        generalWeatherView.update(weather: viewModel.selectedWeather())
        collectionView.reload()
        tableView.reload()
    }
}

extension MainWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hoursCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cls: WeatherTableViewCell.self, indexPath: indexPath)
        cell.set(weather: viewModel.weather(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WeatherTableViewCell.height
    }
}

extension MainWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hoursCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cls: WeatherCollectionViewCell.self, indexPath: indexPath)
        cell.set(weather: viewModel.weather(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return WeatherCollectionViewCell.size
    }
}
