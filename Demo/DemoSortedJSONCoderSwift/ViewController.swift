//
//  ViewController.swift
//  DemoSortedJSONCoderSwift
//

import UIKit
import SortedJSONCoder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String:Any] = [
            "1":"",
            "2":"",
            "10":"",
            "20":"",
        ]
        
        let encoder = SortedJSONEncoder()
        
        do {
            let data = try encoder.encode(dict, options: .literal)
            let string = String(data: data, encoding: .utf8)!
            print(string)
            assert(string == "{\"1\":\"\",\"10\":\"\",\"2\":\"\",\"20\":\"\"}")
        } catch {
            print(error)
        }
        
        do {
            let data = try encoder.encode(dict, options: .numeric)
            let string = String(data: data, encoding: .utf8)!
            print(string)
            assert(string == "{\"1\":\"\",\"2\":\"\",\"10\":\"\",\"20\":\"\"}")
        } catch {
            print(error)
        }
        
        do {
            let data = try encoder.encode(dict, comparator: { (s1: String, s2: String) -> ComparisonResult in
                if s1 == s2 { return .orderedSame }
                else if s1 < s2 { return .orderedAscending }
                else { return .orderedDescending }
            })
            let string = String(data: data, encoding: .utf8)!
            print(string)
            assert(string == "{\"1\":\"\",\"10\":\"\",\"2\":\"\",\"20\":\"\"}")
        } catch {
            print(error)
        }
    }
}
