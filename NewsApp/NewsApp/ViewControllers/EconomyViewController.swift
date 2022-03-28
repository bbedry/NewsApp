//
//  EconomyViewController.swift
//  NewsApp
//
//  Created by Bedri Doğan on 16.03.2022.
//

import UIKit
import Moya

class EconomyViewController: UIViewController {

    @IBOutlet weak var economyTableView: UITableView!
    private var newsListViewModel : NewsListViewModel?
    let provider = MoyaProvider<MyService>()
    var newsArray : [NewsDetail]? = []
    override func viewDidLoad() {
        super.viewDidLoad()

        economyTableView.delegate = self
        economyTableView.dataSource = self
        self.economyTableView.register(UINib(nibName: "HeadlineTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        provider.request(.getEconomy, completion: getNewsType(result:))
        let label = UILabel()
        label.textColor = UIColor.systemCyan
        label.font = UIFont(name: "Georgia-Bold", size: 26)
        label.text = "Economy"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }
    func getNewsType(result: Result<Response, MoyaError>){
        switch result {
        case .success(let response):
            decodeAndShow(response)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
     fileprivate func decodeAndShow(_ response: (Response)){
         do {
             let decodeData = try response.map(News.self)
             self.newsListViewModel = NewsListViewModel.init(newsList: decodeData)
             DispatchQueue.main.async {
                 if let newsListViewModel = self.newsListViewModel {
                     for counter in 0..<newsListViewModel.numberOfRowsInSection(){
                         self.newsArray?.append(NewsDetail.init(category: newsListViewModel.newsList.news[counter].category,
                                                                title: newsListViewModel.newsList.news[counter].spot,
                                                                spot: newsListViewModel.newsList.news[counter].spot,
                                                                imageURL: newsListViewModel.newsList.news[counter].imageURL,
                                                                videoURL: newsListViewModel.newsList.news[counter].videoURL,
                                                                webUrl: newsListViewModel.newsList.news[counter].webUrl))
                     }
                 }
                 self.economyTableView.reloadData()
             }
         }
         catch {
             print(error)
         }
    }
    
}
extension EconomyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tabBarController?.delegate = self
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HeadlineTableViewCell {
            if let title = self.newsArray?[indexPath.row].title {
                cell.titleLabel.text = title
            }
            if let urlString = URL(string: String(self.newsArray?[indexPath.row].imageURL ?? "")){
                DispatchQueue.main.async {
                    cell.headlineImageView.kf.setImage(with: urlString)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "toDetailsVC") as! DetailsViewController
        detailVC.selectedNew = self.newsArray?[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 0.1){
        cell.layer.transform = CATransform3DIdentity
        cell.alpha = 1.0
        }
    }
}
extension EconomyViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let indexPath = IndexPath(row: 0, section: 0)
        economyTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
