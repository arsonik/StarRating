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
	@objc optional func ratingViewControllerWillDisappear(_ controller: RatingViewController)
	func ratingViewControllerDidRate(_ controller: RatingViewController, rate: Int)
}

public class RatingViewController: UIViewController {

	public var numberOfStars: Int = 5
	public var starsSpacing: CGFloat = 30

	public var selectedStarText = "★"
	public var notSelectedStarText = "☆"
	public var starFontSize: CGFloat = 100
	public var cornerRadius: CGFloat = 10

	public var selectedColor = UIColor.black()
	public var notSelectedColor = UIColor.white()

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
			let button = UIButton(type: .custom)
			button.contentEdgeInsets = UIEdgeInsetsZero
			button.titleLabel?.font = UIFont.systemFont(ofSize: self.starFontSize)
			button.layer.cornerRadius = self.cornerRadius
			button.layer.masksToBounds = true
			return button
		}
	}()

	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		delegate?.ratingViewControllerWillDisappear?(self)
	}

	override public func viewDidLoad() {
		super.viewDidLoad()

		// backdrop
		let vev = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		view.insertSubview(vev, at: 0)
		vev.autoPinEdgesToSuperviewEdges()



		let container = UIView()
		view.addSubview(container)
		container.autoCenterInSuperview()
		titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleHeadline)
		subtitleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)

		[titleLabel, subtitleLabel].forEach {
			container.addSubview($0)
			$0.autoAlignAxis(toSuperviewAxis: .vertical)
		}

		titleLabel.autoPinEdge(toSuperviewEdge: .top)
		subtitleLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)

		buttons.enumerated().forEach { index, button in
			container.addSubview(button)
			button.autoPinEdge(.top, to: .bottom, of: subtitleLabel, withOffset: 20)
			button.autoPinEdge(toSuperviewMargin: .bottom)

			if button == buttons.first {
				button.autoPinEdge(.leading, to: .leading, of: container)
			} else {
				button.autoPinEdge(.leading, to: .trailing, of: buttons[index-1], withOffset: self.starsSpacing)
			}
			if button == buttons.last {
				button.autoPinEdge(.trailing, to: .trailing, of: container)
			}

			button.addTarget(self, action: #selector(RatingViewController.selectStar(_:)), for: UIControlEvents.primaryActionTriggered)
		}

		update()
	}

	override public var preferredFocusedView: UIView? {
		return buttons[max(0, rate-1)]
	}

	@IBAction func selectStar(_ button: UIButton) {
		rate = buttons.index(of: button)! + 1
		delegate?.ratingViewControllerDidRate(self, rate: rate)
	}

	override public func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
		if let button = context.previouslyFocusedView as? UIButton {
			button.backgroundColor = UIColor.clear()
		}
		if let button = context.nextFocusedView as? UIButton {
			button.backgroundColor = UIColor.white()
			rate = buttons.index(of: button)! + 1
			update()
		}
	}

	func update() {
		(0..<min(rate, numberOfStars)).forEach { i in
			buttons[i].setTitle(self.selectedStarText, for: UIControlState())
			buttons[i].setTitleColor(self.selectedColor, for: UIControlState())
		}
		(rate..<numberOfStars).forEach { i in
			buttons[i].setTitle(self.notSelectedStarText, for: UIControlState())
			buttons[i].setTitleColor(self.notSelectedColor, for: UIControlState())
		}
	}
}
