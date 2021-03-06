//
//  MovieNight.swift
//  Movie Night App
//
//  Created by Arwin Oblea on 11/21/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation

enum MovieNight {
  enum MovieNightSortType: CustomStringConvertible {
    case popularityDesc
    
    var description: String {
      switch self {
      case .popularityDesc: return "popularity.desc"
      }
    }
  }
  
  case certification(api: String)
  case genre(api: String)
  case people(api: String, page: Int)
  case discover(api: String, sortBy: MovieNightSortType, country: String, certification: [Certification], withPeople: [Person], withGenres: [Genre])
  case movie(imagePath: String)
}

extension MovieNight: Endpoint {
  var base: String {
    switch self {
    case .movie:
      return "https://image.tmdb.org" // for movie image
    default:
      return "https://api.themoviedb.org"
    }
  }
  
  var path: String {
    switch self {
    case .certification: return "/3/certification/movie/list"
    case .genre: return "/3/genre/movie/list"
    case .people: return "/3/person/popular"
    case .discover: return "/3/discover/movie"
    case .movie(let imagePath): return "/t/p/w500\(imagePath)"
    }
  }
  
  var queryItems: [URLQueryItem] {
    switch self {
    case .certification(let api): return [URLQueryItem(name: "api_key", value: api.description)]
    case .genre(let api): return [URLQueryItem(name: "api_key", value: api.description)]
    case .people(let api, let page): return [
      URLQueryItem(name: "api_key", value: api.description),
      URLQueryItem(name: "page", value: page.description)
      ]
    case .discover(let api, let sortBy, let country, let certification, let withPeople, let withGenres):
      return [
        URLQueryItem(name: "api_key", value: api.description),
        URLQueryItem(name: "sort_by", value: sortBy.description),
        URLQueryItem(name: "certification_country", value: country.description),
        URLQueryItem(name: "certification", value: certification.compactMap { $0.certification }.joined(separator: "|")),
        URLQueryItem(name: "with_people", value: withPeople.compactMap { $0.id.description }.joined(separator: "|")),
        URLQueryItem(name: "with_genres", value: withGenres.compactMap { $0.id.description }.joined(separator: "|"))
      ]
    case .movie: return []
    }
  }
  
}

/*
For Testing Purposes:
 // Certification List
 https://api.themoviedb.org/3/certification/movie/list?api_key=34d74b3c4d3a6d099c7422cb6b1a5c77

 // Genre List
 https://api.themoviedb.org/3/genre/movie/list?api_key=34d74b3c4d3a6d099c7422cb6b1a5c77

 // Popular People
 https://api.themoviedb.org/3/person/popular?api_key=34d74b3c4d3a6d099c7422cb6b1a5c77&page=2

 // Discover Movies 
 https://api.themoviedb.org/3/discover/movie?api_key=34d74b3c4d3a6d099c7422cb6b1a5c77&sort_by=popularity.desc&certification_country=US&certification=G&with_people=1%2C4
 
 // Movie Image Retrieval
 https://image.tmdb.org/t/p/w500 '/lcq8dVxeeOqHvvgcte707K0KVx5.jpg'
 
*/
