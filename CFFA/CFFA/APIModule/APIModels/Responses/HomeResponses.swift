//
//  HomeResponses.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/17/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation

struct HomeThreads: Codable {
    var popular: [PostOnly]?
    var fresh: [PostOnly]?
    var feed: [PostOnly]?
}
