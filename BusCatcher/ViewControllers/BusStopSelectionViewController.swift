//
//  BusStopSelectionViewController.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/20/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import UIKit

class BusStopSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var busStops = ["Portal","Woodward"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "busstopcustomcell", for: indexPath) as! BusStopTableViewCell
        
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black,UIColor.white]
        layer.transform = CATransform3DMakeRotation(180, 0, 0, 0)
        cell.layer.addSublayer(layer)
        
        
        cell.busStopNameLabel.text = busStops[indexPath.row]
        //configure your cell
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
