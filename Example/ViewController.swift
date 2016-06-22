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

	func ratingViewControllerDidRate(_ controller: RatingViewController, rate: Int) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}




	override func viewDidLoad() {
		super.viewDidLoad()

		DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async {
			guard let data = try? Data(contentsOf: URL(string: "https://www.teslamotors.com/sites/default/files/images/homepage/home_hero_auto3.jpg?cache1")!) else {
				return
			}
			let image = UIImageView(image: UIImage(data: data))
			image.contentMode = .scaleAspectFill

			DispatchQueue.main.async {
				self.view.insertSubview(image, at: 0)
				image.autoPinEdgesToSuperviewEdges()
			}
		}
	}
}


