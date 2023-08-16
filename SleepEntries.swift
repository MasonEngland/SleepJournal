// Misc file containing extra functions and variables
// hopefully some of these get turned into databases for other users
// update: I got the database to work

import SwiftUI

// defines a single sleep entry
// identifiable for iteration
// Codable for database transfer
struct sleepEntry: Identifiable, Codable, Equatable {
    var id = UUID()
    var date: String
    var timeSlept: Double
    var timeWoken: Double
    var sleepDuration: Double
    init(date: String, timeSlept: Double, timeWoken: Double) {
        self.date = date
        self.timeSlept = timeSlept
        self.timeWoken = timeWoken
        self.sleepDuration = self.timeWoken < self.timeSlept ? 24 - (self.timeSlept - self.timeWoken): self.timeWoken - self.timeSlept
    }
}

// defines a time of day
struct timeOfDay: Identifiable {
    var id = UUID()
    var timef: String
    var tag: Double
}

// the list of journal entries
// changes according to user
// needs default to add to user database
var entries: [sleepEntry] = [
    /* these are birthdays of people I like that I used for testing:
     
     sleepEntry(date:"January 23, 2022", timeSlept: 22.00, timeWoken: 9.00),
    
    sleepEntry(date:"April 20, 2005", timeSlept: 22.00, timeWoken: 10.00),
    
    sleepEntry(date:"May 3, 2022", timeSlept: 24.00, timeWoken: 9.00)*/
    
    sleepEntry(date:"Example", timeSlept: 0, timeWoken: 0)
]

// defines all possible times
// probably not the best way to do this
// I'll learn...eventually
var times = [
    timeOfDay(timef: "1:00", tag: 1.00),
    
    timeOfDay(timef: "2:00", tag: 2.00),
    
    timeOfDay(timef: "3:00", tag: 3.00),
    
    timeOfDay(timef: "4:00", tag: 4.00),
    
    timeOfDay(timef: "5:00", tag: 5.00),
    
    timeOfDay(timef: "6:00", tag: 6.00),
    
    timeOfDay(timef: "7:00", tag: 7.00),
    
    timeOfDay(timef: "8:00", tag: 8.00),
    
    timeOfDay(timef: "9:00", tag: 9.00),
    
    timeOfDay(timef: "10:00", tag: 10.00),
    
    timeOfDay(timef: "11:00", tag: 11.00),
    
    timeOfDay(timef: "12:00", tag: 12.00),
    
    timeOfDay(timef: "13:00", tag: 13.00),
    
    timeOfDay(timef: "14:00", tag: 14.00),
    
    timeOfDay(timef: "15:00", tag: 15.00),
    
    timeOfDay(timef: "16:00", tag: 16.00),
    
    timeOfDay(timef: "17:00", tag: 17.00),
    
    timeOfDay(timef: "18:00", tag: 18.00),
    
    timeOfDay(timef: "19:00", tag: 19.00),
    
    timeOfDay(timef: "20:00", tag: 20.00),
    
    timeOfDay(timef: "21:00", tag: 21.00),
    
    timeOfDay(timef: "22:00", tag: 22.00),
    
    timeOfDay(timef: "23:00", tag: 23.00),
    
    timeOfDay(timef: "24:00", tag: 24.00)
]

// this function creates a list for the graph
// this is nessecary becuase it checks the amount of
// list items and stops once it reaches 7 entries
// MARK: - Functions
func LastSevenOfEntries(list: [sleepEntry]) -> [Double] {
    var lasSeven: [Double] = []
    if list.count >= 7 {
        for i in 1..<8 {
            lasSeven.append(list[list.count - i].sleepDuration)
        }
        return lasSeven.reversed()
    }
    else {
        for i in 1...(list.count) {
            lasSeven.append(list[list.count - i].sleepDuration)
        }
        return lasSeven.reversed()
    }
}

// grabs the average of a list of doubles
func getAverageofList(list: [Double]) -> Double {
    var average: Double = 0
    for i in list {
        average += i
    }
    let answer = average / Double(list.count)
    return answer
}


// enocdes sleepEntries to be pushed into database
func encodeData(list: [sleepEntry]) -> Any {
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(list)
        
        return data
    }
    catch {
        print("cannot encode")
    }
    return list
}

// decodes encoded data retrieved from database
func decodeData(data: Any) -> [sleepEntry] {
    do {
        let decoder = JSONDecoder()
        let list = try decoder.decode([sleepEntry].self, from: data as! Data)
        
        return list
    }catch {
        print("unable to decode data")
        return []
    }
}

// MARK: Explination
/* So basically, databases only support a few data types and object types. String, Int, Float, Double, Bool, ect, as well as Date.
 My "sleepEntry" Object is not supported by databases so I have to encode it something that CAN be red by the database
 and then I later have to decode it when I pull it out. It works fine and isn't very taxing in terms of memory, but
 I also can't view that info in the database myself, so I guess be happy that your data is encoded.*/
