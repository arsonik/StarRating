//
//  RatingViewController.swift
//  Star Rating
//
//  Created by Florian Morello on 21/04/16.
//  Copyright © 2016 Arsonik. All rights reserved.
//

import UIKit
import PureLayout

@objc public protocol RatingViewControllerDelegate: class {
	optional func ratingViewControllerWillDisappear(controller: RatingViewController)
	func ratingViewControllerDidRate(controller: RatingViewController, rate: Int)
}

public class RatingViewController: UIViewController {

	public var numberOfStars: Int = 5
	public var starsSpacing: CGFloat = 30

	public var selectedStarText = "★"
	public var notSelectedStarText = "☆"
	public var starFontSize: CGFloat = 100
	public var cornerRadius: CGFloat = 10

	public var selectedColor = UIColor.blackColor()
	public var notSelectedColor = UIColor.whiteColor()

	public let titleLabel = UILabel()
	public let subtitleLabel = UILabel()

	public var rate: Int = 0 {
		didSet {
			rate = min(numberOfStars, rate)
			rate = max(0, rate)
		}
	}

	public weak var delegate: RatingViewControllerDelegate?

	private lazy var buttons: [UIButton] = {
		return (0..<self.numberOfStars).flatMap {_ in
			let button = UIButton(type: .Custom)
			button.contentEdgeInsets = UIEdgeInsetsZero
			button.titleLabel?.font = UIFont.systemFontOfSize(self.starFontSize)
			button.layer.cornerRadius = self.cornerRadius
			button.layer.masksToBounds = true
			return button
		}
	}()

	override public func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		delegate?.ratingViewControllerWillDisappear?(self)
	}

	override public func viewDidLoad() {
		super.viewDidLoad()

		// backdrop
		let vev = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
		view.insertSubview(vev, atIndex: 0)
		vev.autoPinEdgesToSuperviewEdges()



		let container = UIView()
		view.addSubview(container)
		container.autoCenterInSuperview()
		titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		subtitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)

		[titleLabel, subtitleLabel].forEach {
			container.addSubview($0)
			$0.autoAlignAxisToSuperviewAxis(.Vertical)
		}

		titleLabel.autoPinEdgeToSuperviewEdge(.Top)
		subtitleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 20)

		buttons.enumerate().forEach { index, button in
			container.addSubview(button)
			button.autoPinEdge(.Top, toEdge: .Bottom, ofView: subtitleLabel, withOffset: 20)
			button.autoPinEdgeToSuperviewMargin(.Bottom)

			if button == buttons.first {
				button.autoPinEdge(.Leading, toEdge: .Leading, ofView: container)
			} else {
				button.autoPinEdge(.Leading, toEdge: .Trailing, ofView: buttons[index-1], withOffset: self.starsSpacing)
			}
			if button == buttons.last {
				button.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: container)
			}

			button.addTarget(self, action: #selector(RatingViewController.selectStar(_:)), forControlEvents: UIControlEvents.PrimaryActionTriggered)
		}

		update()
	}

	override public var preferredFocusedView: UIView? {
		return buttons[max(0, rate-1)]
	}

	@IBAction func selectStar(button: UIButton) {
		rate = buttons.indexOf(button)! + 1
		delegate?.ratingViewControllerDidRate(self, rate: rate)
	}

	override public func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
		if let button = context.previouslyFocusedView as? UIButton {
			button.backgroundColor = UIColor.clearColor()
		}
		if let button = context.nextFocusedView as? UIButton {
			button.backgroundColor = UIColor.whiteColor()
			rate = buttons.indexOf(button)! + 1
			update()
		}
	}

	func update() {
		(0..<min(rate, numberOfStars)).forEach { i in
			buttons[i].setTitle(self.selectedStarText, forState: .Normal)
			buttons[i].setTitleColor(self.selectedColor, forState: .Normal)
		}
		(rate..<numberOfStars).forEach { i in
			buttons[i].setTitle(self.notSelectedStarText, forState: .Normal)
			buttons[i].setTitleColor(self.notSelectedColor, forState: .Normal)
		}
	}
}