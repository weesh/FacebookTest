//
//  ViewModel.swift
//  facebook
//
//  Created by Kenneth Wieschhoff on 3/20/21.
//

import Foundation

struct Event: Decodable {
    var title: String
    var start: String
    var end: String
    var startDate: Date?
    var endDate: Date?
    var overlaps: Bool

    private enum CodingKeys : String, CodingKey { case title, start, end }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        start = try container.decode(String.self, forKey: .start)
        end = try container.decode(String.self, forKey: .end)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        self.startDate = dateFormatter.date(from:start)!
        self.endDate = dateFormatter.date(from:end)!
        self.overlaps = false
    }
}

struct EventData: Decodable {
    var events: [Event]
}


class ViewModel {
    private var events: [Event]?
    
    init() {
        let events = loadJson()!
        self.events = events.sorted { (event1, event2) -> Bool in
            return event1.startDate ?? Date() < event2.startDate ?? Date()
        }
        calculateOverlaps()
    }
    
    private func loadJson() -> [Event]? {
        if let url = Bundle.main.url(forResource: "mock", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Event].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func calculateOverlaps() {
        guard let eventList = self.events else {
            print("No events?")
            return
        }
        
        for (index1, event1) in eventList.enumerated()  {
            if event1.overlaps { continue }
            
            for (index2, event2)  in eventList.enumerated() {
                if index1 == index2 { continue }
                if event2.overlaps { continue}
                if event1.startDate! <= event2.startDate! &&
                    event1.endDate! >= event2.endDate! {
                    events?[index1].overlaps = true
                    events?[index2].overlaps = true
                }
            }
            
            if index1 != 0 {
                if events![index1-1].endDate! > event1.startDate! {
                    events![index1].overlaps = true
                    events![index1-1].overlaps = true
                }
            }
        }
    }
    
    func numberOfEvents() -> Int? {
        return events?.count
    }
    
    func eventAtIndex(index: Int) -> Event? {
        return events?[index] ?? nil
    }
}
