//
//  NewsModel.swift
//  NewsApp
//
//  Created by Bedri Doğan on 17.03.2022.
//

import Foundation

struct News: Decodable {
    let news : [NewsDetail]
}

struct NewsDetail : Decodable {
    let category : String?
    let title : String?
    let spot : String?
    let imageURL : String?
    let videoURL : String?
    let webUrl : String?
}
