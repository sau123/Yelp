//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Saumeel Gajera on 7/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class Preferences{
    var sortMode = 0, distanceMode = 0
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
//    var currentPrefs = Preferences!()
    
    @IBOutlet weak var sortBySegmentCtrl: UISegmentedControl!
    @IBOutlet weak var distanceSegmentCtrl: UISegmentedControl!
    var sortFilterIndex : Int? = 0
    var distanceFilterIndex : Int? = 0
    weak var delegate : FilterViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!

    var isDistanceExpanded = false
    var isSortByExpanded = false
    var isOfferingDeal : Bool?
    
    var categories : [[String:String]]!
    var distanceFilters : [[String:String]]!
    var sortByFilters : [[String:String]]!
    
    var sortByFilter : Int! = 0
    var distanceFilter : Int! = 0
    var dealsFilter : Bool! = false
//    var sort : [[String:AnyObject]]!
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        currentPrefs = currentPrefs ?? Preferences()
//        initSwitches()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categories = yelpCategories()
//        distanceFilters = yelpDistanceFilters()
//        sortByFilters = yelpSortByFilters()
        
        sortBySegmentCtrl.selectedSegmentIndex = sortFilterIndex!
        distanceSegmentCtrl.selectedSegmentIndex = distanceFilter!
        print("in viewDidLoad")
        tableView.reloadData()
    }
    
    /*
    func initSwitches(){
        sortBySegmentCtrl.selectedSegmentIndex = currentPrefs.sortMode
        distanceSegmentCtrl.selectedSegmentIndex = currentPrefs.distanceMode
    }

    
    func preferencesFromTableData() -> Preferences {
        let newPrefs = Preferences()
        newPrefs.sortMode = sortBySegmentCtrl.selectedSegmentIndex
        newPrefs.distanceMode = distanceSegmentCtrl.selectedSegmentIndex
        return newPrefs
    }
 */
    
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        return 2
    //    }
    
    @IBAction func dealsButtonTapped(sender: AnyObject) {
        dealsFilter = (sender as! UISwitch).on
    }
    @IBAction func sortBySegmentedControlTapped(sender: AnyObject) {
        sortByFilter = (sender as! UISegmentedControl).selectedSegmentIndex
    }
    
    @IBAction func distanceSegmentedControlTapped(sender: AnyObject) {
        distanceFilter = (sender as! UISegmentedControl).selectedSegmentIndex
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 4
//    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0: return 1
//        case 1: return isDistanceExpanded ? distanceFilters.count ?? 0 : 1
//        case 2: return isSortByExpanded ? sortByFilters.count ?? 0 : 1
//        case 3: return categories?.count ?? 0
//        default: return 0
//        }
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories != nil{
            return categories.count
        }else{
            return 0
        }
    }
    
//    func tableView(tableView: UITableView,
//                   titleForHeaderInSection section: Int) -> String? {
//        if section == 1 { return "Distance" }
//        else if section == 2 { return "Sort By" }
//        else if section == 3 { return "Category" }
//        else { return "" }
//    }
    
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0 :
//            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
//            cell.delegate = self
//            cell.switchLabel.text = "Offering Deal"
//            cell.onSwitch.on = isOfferingDeal ?? false
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCellWithIdentifier("SingleSelectCell", forIndexPath: indexPath) as! SingleSelectCell
//            
//            
//        case 2:
//            
//            
//        default:
//        }
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.delegate = self
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        
        return cell
    }
    
    func switchCell(switchcell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchcell)!
        
        switchStates[indexPath.row] = value
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String : AnyObject]()
        var selectedCategories = [String]()
        
        for (row,isSelected) in switchStates{
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0{
            filters["categories"] = selectedCategories
        }
        
        if sortByFilter != nil{
            filters["sort"] = sortByFilter
        }
        
        if distanceFilter != nil{
            filters["distance"] = distanceFilter
        }
        
        if dealsFilter != nil {
            print("dealsfilter : ",dealsFilter)
            filters["deals"] = dealsFilter
        }
        
        print("filters ",filters)
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    func yelpDistanceFilters() -> [[String:String]] {
//        
//    }
//    func yelpSortByFilters() -> [[String:String]] {
//        
//    }
    
    func yelpCategories() -> [[String:String]] {
        return [
            ["name" : "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Asturian", "code": "asturian"],
            ["name" : "Australian", "code": "australian"],
            ["name" : "Austrian", "code": "austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Bangladeshi", "code": "bangladeshi"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Bavarian", "code": "bavarian"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Beer Hall", "code": "beerhall"],
            ["name" : "Beisl", "code": "beisl"],
            ["name" : "Belgian", "code": "belgian"],
            ["name" : "Bistros", "code": "bistros"],
            ["name" : "Black Sea", "code": "blacksea"],
            ["name" : "Brasseries", "code": "brasseries"],
            ["name" : "Brazilian", "code": "brazilian"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "British", "code": "british"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Burmese", "code": "burmese"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New)"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "Chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comfortfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "german"],
            ["name" : "Giblets", "code": "giblets"],
            ["name" : "Gluten-Free", "code": "gluten_free"],
            ["name" : "Greek", "code": "greek"],
            ["name" : "Halal", "code": "halal"],
            ["name" : "Hawaiian", "code": "hawaiian"],
            ["name" : "Heuriger", "code": "heuriger"],
            ["name" : "Himalayan/Nepalese", "code": "himalayan"],
            ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name" : "Hot Dogs", "code": "hotdog"],
            ["name" : "Hot Pot", "code": "hotpot"],
            ["name" : "Hungarian", "code": "hungarian"],
            ["name" : "Iberian", "code": "iberian"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Indonesian", "code": "indonesian"],
            ["name" : "International", "code": "international"],
            ["name" : "Irish", "code": "irish"],
            ["name" : "Island Pub", "code": "island_pub"],
            ["name" : "Israeli", "code": "israeli"],
            ["name" : "Italian", "code": "italian"],
            ["name" : "Japanese", "code": "japanese"],
            ["name" : "Jewish", "code": "jewish"],
            ["name" : "Kebab", "code": "kebab"],
            ["name" : "Korean", "code": "korean"],
            ["name" : "Kosher", "code": "kosher"],
            ["name" : "Kurdish", "code": "kurdish"],
            ["name" : "Laos", "code": "laos"],
            ["name" : "Laotian", "code": "laotian"],
            ["name" : "Latin American", "code": "latin"],
            ["name" : "Live/Raw Food", "code": "raw_food"],
            ["name" : "Lyonnais", "code": "lyonnais"],
            ["name" : "Malaysian", "code": "malaysian"],
            ["name" : "Meatballs", "code": "meatballs"],
            ["name" : "Mediterranean", "code": "mediterranean"],
            ["name" : "Mexican", "code": "mexican"],
            ["name" : "Middle Eastern", "code": "mideastern"],
            ["name" : "Milk Bars", "code": "milkbars"],
            ["name" : "Modern Australian", "code": "modern_australian"],
            ["name" : "Modern European", "code": "modern_european"],
            ["name" : "Mongolian", "code": "mongolian"],
            ["name" : "Moroccan", "code": "moroccan"],
            ["name" : "New Zealand", "code": "newzealand"],
            ["name" : "Night Food", "code": "nightfood"],
            ["name" : "Norcinerie", "code": "norcinerie"],
            ["name" : "Open Sandwiches", "code": "opensandwiches"],
            ["name" : "Oriental", "code": "oriental"],
            ["name" : "Pakistani", "code": "pakistani"],
            ["name" : "Parent Cafes", "code": "eltern_cafes"],
            ["name" : "Parma", "code": "parma"],
            ["name" : "Persian/Iranian", "code": "persian"],
            ["name" : "Peruvian", "code": "peruvian"],
            ["name" : "Pita", "code": "pita"],
            ["name" : "Pizza", "code": "pizza"],
            ["name" : "Polish", "code": "polish"],
            ["name" : "Portuguese", "code": "portuguese"],
            ["name" : "Potatoes", "code": "potatoes"],
            ["name" : "Poutineries", "code": "poutineries"],
            ["name" : "Pub Food", "code": "pubfood"],
            ["name" : "Rice", "code": "riceshop"],
            ["name" : "Romanian", "code": "romanian"],
            ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name" : "Rumanian", "code": "rumanian"],
            ["name" : "Russian", "code": "russian"],
            ["name" : "Salad", "code": "salad"],
            ["name" : "Sandwiches", "code": "sandwiches"],
            ["name" : "Scandinavian", "code": "scandinavian"],
            ["name" : "Scottish", "code": "scottish"],
            ["name" : "Seafood", "code": "seafood"],
            ["name" : "Serbo Croatian", "code": "serbocroatian"],
            ["name" : "Signature Cuisine", "code": "signature_cuisine"],
            ["name" : "Singaporean", "code": "singaporean"],
            ["name" : "Slovakian", "code": "slovakian"],
            ["name" : "Soul Food", "code": "soulfood"],
            ["name" : "Soup", "code": "soup"],
            ["name" : "Southern", "code": "southern"],
            ["name" : "Spanish", "code": "spanish"],
            ["name" : "Steakhouses", "code": "steak"],
            ["name" : "Sushi Bars", "code": "sushi"],
            ["name" : "Swabian", "code": "swabian"],
            ["name" : "Swedish", "code": "swedish"],
            ["name" : "Swiss Food", "code": "swissfood"],
            ["name" : "Tabernas", "code": "tabernas"],
            ["name" : "Taiwanese", "code": "taiwanese"],
            ["name" : "Tapas Bars", "code": "tapas"],
            ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name" : "Tex-Mex", "code": "tex-mex"],
            ["name" : "Thai", "code": "thai"],
            ["name" : "Traditional Norwegian", "code": "norwegian"],
            ["name" : "Traditional Swedish", "code": "traditional_swedish"],
            ["name" : "Trattorie", "code": "trattorie"],
            ["name" : "Turkish", "code": "turkish"],
            ["name" : "Ukrainian", "code": "ukrainian"],
            ["name" : "Uzbek", "code": "uzbek"],
            ["name" : "Vegan", "code": "vegan"],
            ["name" : "Vegetarian", "code": "vegetarian"],
            ["name" : "Venison", "code": "venison"],
            ["name" : "Vietnamese", "code": "vietnamese"],
            ["name" : "Wok", "code": "wok"],
            ["name" : "Wraps", "code": "wraps"],
            ["name" : "Yugoslav", "code": "yugoslav"]
            
        ]
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
