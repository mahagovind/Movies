//
//  TopRatedViewController.swift
//  Movies
//
//  Created by Maha Govindarajan on 2/7/16.
//  Copyright © 2016 Maha Govindarajan. All rights reserved.
//

import UIKit
import AFNetworking;
import SwiftyJSON;
import MBProgressHUD;

class TopRatedViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet var moviesTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var networkWarningView: UIView!
    var movies : [NSDictionary] = []
    var jsonMovieObject : JSON = []
    var searchActive : Bool = false
    var moviesSearchFiltered : [NSDictionary] = []
    let apiKey = "29d31c10f7de4c325c08893264cb57a0"
    var url : NSURL = NSURL()
    var request : NSURLRequest = NSURLRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        showLoadingHUD()
        networkWarningView.hidden = true
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        moviesTableView.insertSubview(refreshControl, atIndex: 0)
        url = NSURL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")!
        request = NSURLRequest(URL: url)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                if let requestError = errorOrNil {
                    print(requestError)
                    self.networkWarningView.hidden = false
                    self.searchBar.hidden = true
                  //  self.moviesTableView.hidden = true
                    self.moviesTableView.reloadData()
                    self.hideLoadingHUD()
                } else {
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                
                                self.movies = responseDictionary["results"] as! [NSDictionary]
                                self.jsonMovieObject = JSON(self.movies)
                                self.networkWarningView.hidden = true
                                self.searchBar.hidden = false
                                self.moviesTableView.hidden = false
                                self.moviesTableView.reloadData()
                                self.hideLoadingHUD()
                               
                        }
                    }
                }
        });
        task.resume()
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsCancelButton = false
        searchBar.text = ""
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsCancelButton = true
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        moviesSearchFiltered = movies.filter{
            let tmp: NSString = $0["title"] as! String
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
            
        }
        if(moviesSearchFiltered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.moviesTableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return moviesSearchFiltered.count
        }
        return movies.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("topRatedcell", forIndexPath: indexPath) as! TopRatedTableViewCell
        var movie : JSON;
        if(searchActive){
            movie = JSON(moviesSearchFiltered[indexPath.row])
        } else {
            movie = JSON(movies[indexPath.row])
        }
        let basePosterUrl = "https://image.tmdb.org/t/p/w342"
        let url  = NSURL(string:basePosterUrl + movie["poster_path"].stringValue)
        cell.titleLabel.text = movie["title"].stringValue
        cell.overviewLabel.text = movie["overview"].stringValue
        cell.posterImage.setImageWithURL(url!)
        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        showLoadingHUD()
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                if let requestError = errorOrNil {
                    print(requestError)
                    self.networkWarningView.hidden = false
                    self.searchBar.hidden = true
                   // self.moviesTableView.hidden = true
                } else {
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                
                                self.movies = responseDictionary["results"] as! [NSDictionary]
                                self.jsonMovieObject = JSON(self.movies)
                                print("test")
                                self.networkWarningView.hidden = true
                                self.searchBar.hidden = false
                                self.moviesTableView.hidden = false
                                self.moviesTableView.reloadData()
                                refreshControl.endRefreshing()
                                self.hideLoadingHUD()
                                
                        }
                    }
                }
        });
        task.resume()
    }
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(moviesTableView, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(moviesTableView, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailsViewController = segue.destinationViewController as! DetailsViewController
        let indexPath = moviesTableView.indexPathForCell(sender as! TopRatedTableViewCell)
        if(searchActive) {
            detailsViewController.movie = JSON(moviesSearchFiltered[indexPath!.row])
        } else {
            detailsViewController.movie = JSON(movies[indexPath!.row])
        }
    }
    
    
}
