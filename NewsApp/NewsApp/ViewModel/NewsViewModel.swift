//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Bedri Doğan on 17.03.2022.
//

import Foundation
import Moya

struct NewsListViewModel {
    let newsList : News
    
    func numberOfRowsInSection() -> Int {
        return newsList.news.count
    }
}

struct NewsViewModel {
    let newsList : News
    
    var category : String?
    {
        return self.newsList.news.first?.category
    }
    var title : String?
    {
        return self.newsList.news.first?.title
    }
    var spot : String?
    {
        return self.newsList.news.first?.spot
    }
    var imageURL : String? {
        return self.newsList.news.first?.imageURL
    }
    var videoURL : String? {
        return self.newsList.news.first?.videoURL
    }
    var webURL : String? {
        return self.newsList.news.first?.webUrl
    }
    
}
