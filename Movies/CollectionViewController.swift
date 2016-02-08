//
//  CollectionViewController.swift
//  Movies
//
//  Created by Maha Govindarajan on 2/7/16.
//  Copyright © 2016 Maha Govindarajan. All rights reserved.
//

import UIKit
import SwiftyJSON;

class CollectionViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet var collectionsView: UICollectionView!
    var movies : [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionsView.delegate = self
        collectionsView.dataSource = self
        collectionsView.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseI.dentifier:forIndexPath:
  
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionViewCell
        
            let movie = JSON(movies[indexPath.row])
        
            let basePosterUrl = "https://image.tmdb.org/t/p/w342"
            let url  = NSURL(string:basePosterUrl + movie["poster_path"].stringValue)
            cell.titleLabel.text = movie["title"].stringValue
            cell.posterView.setImageWithURL(url!)
            
            return cell
        
    }
    
    func pressed(sender: UIButton!) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MoviesViewController") as! MoviesViewController
        secondViewController.navigationItem.hidesBackButton = true

        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailsViewController = segue.destinationViewController as! DetailsViewController
        let indexPath = collectionsView.indexPathForCell(sender as! CollectionViewCell)
            detailsViewController.movie = JSON(movies[indexPath!.row])

    }

}
