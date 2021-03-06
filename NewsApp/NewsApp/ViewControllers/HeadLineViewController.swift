//
//  HeadLineViewController.swift
//  NewsApp
//
//  Created by Bedri Doğan on 16.03.2022.
//

import UIKit
import Kingfisher
import Moya

class HeadLineViewController: UIViewController {
    
    private var newsListViewModel : NewsListViewModel?
    
    @IBOutlet weak var headLineTableView: UITableView!
    @IBOutlet weak var headLinesLabel: UILabel!
    
    var newsArray : [NewsDetail]? = []
    let provider = MoyaProvider<MyService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider.request(.getHeader, completion: getNewsType(result:))
        
        headLineTableView.dataSource = self
        headLineTableView.delegate = self
        
        self.headLineTableView.register(UINib(nibName: "HeadlineTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont(name: "Georgia-Bold", size: 26)
        label.text = "Headline"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }
    
    func getNewsType(result: Result<Response, MoyaError>){
        switch result{
        case .success(let response):
            decodeAndShow(response)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    fileprivate func decodeAndShow(_ response: (Response)){
        do {
            let decodeData = try response.map(News.self)
            self.newsListViewModel = NewsListViewModel(newsList: decodeData)
            DispatchQueue.main.async {
                if let newsListModel = self.newsListViewModel {
                    for counter in 0..<newsListModel.numberOfRowsInSection(){
                        self.newsArray?.append(NewsDetail(category: newsListModel.newsList.news[counter].category, title:
                                                            newsListModel.newsList.news[counter].title, spot:
                                                            newsListModel.newsList.news[counter].spot, imageURL:
                                                            newsListModel.newsList.news[counter].imageURL, videoURL:
                                                            newsListModel.newsList.news[counter].videoURL, webUrl:
                                                            newsListModel.newsList.news[counter].webUrl))
                    }
                }
                self.headLineTableView.reloadData()
            }
        }
        catch {
            print(error)
        }
    }

}
// Mark UITableViewDataSource, UITableViewDelegate

extension HeadLineViewController : UITableViewDelegate, UITableViewDataSource {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "toDetailsVC") as! DetailsViewController
        detailVC.selectedNew = self.newsArray?[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransForm = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransForm
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 0.1){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
}
// Mark UITabbarControllerDelegate

extension HeadLineViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        headLineTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
