//
//  ViewController.swift
//  Star Rating
//
//  Created by Florian Morello on 21/04/16.
//  Copyright © 2016 Arsonik. All rights reserved.
//

import UIKit
import PureLayout
import StarRating

class ViewController: UIViewController, RatingViewControllerDelegate {

	@IBAction func rateMe() {
		let rating = RatingViewController()
		rating.rate = 2
		rating.delegate = self
		rating.modalPresentationStyle = .OverCurrentContext

		rating.titleLabel.text = "How would you rate the new Model S ?"
		rating.subtitleLabel.text = "Here is a subtitle"

		presentViewController(rating, animated: true, completion: nil)
	}

	func ratingViewControllerDidRate(controller: RatingViewController, rate: Int) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}




	override func viewDidLoad() {
		super.viewDidLoad()

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			guard let data = NSData(contentsOfURL: NSURL(string: "https://www.teslamotors.com/sites/default/files/images/homepage/home_hero_auto3.jpg?cache1")!) else {
				return
			}
			let image = UIImageView(image: UIImage(data: data))
			image.contentMode = .ScaleAspectFill

			dispatch_async(dispatch_get_main_queue()) {
				self.view.insertSubview(image, atIndex: 0)
				image.autoPinEdgesToSuperviewEdges()
			}
		}
	}
}


