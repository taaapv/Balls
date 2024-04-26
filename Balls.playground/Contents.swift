import PlaygroundSupport
import UIKit

public class Balls: UIView {
	private var colors: [UIColor]
	private var balls: [UIView] = []
	private var ballSize: CGSize = CGSize(width: 40, height: 40)
	private var animator: UIDynamicAnimator?
	private var snapBehavior: UISnapBehavior?
	private var collisionBehavior: UICollisionBehavior
	
	public init(colors: [UIColor]) {
		self.colors = colors
		collisionBehavior = UICollisionBehavior(items: [])
		collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
		super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
		backgroundColor = UIColor.gray
		animator = UIDynamicAnimator(referenceView: self)
		ballsView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let touchLocation = touch.location(in: self)
			for ball in balls {
				if (ball.frame.contains(touchLocation)) {
					snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
					snapBehavior?.damping = 0.5
					animator?.addBehavior(snapBehavior!)
				}
			}
		}
	}
	
	override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let touchLocation = touch.location(in: self)
			if let snapBehavior = snapBehavior {
				snapBehavior.snapPoint = touchLocation
			}
		}
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let snapBehavior = snapBehavior {
			animator?.removeBehavior(snapBehavior)
		}
		snapBehavior = nil
	}
	
	func ballsView() {
		for (index, color) in colors.enumerated() {
			let ball = UIView(frame: CGRect.zero)
			ball.backgroundColor = color
			addSubview(ball)
			balls.append(ball)
			let origin = 40*index + 100
			ball.frame = CGRect(x: origin, y: origin, width: Int(ballSize.width), height: Int(ballSize.width))
			ball.layer.cornerRadius = ball.bounds.width / 2.0
			collisionBehavior.addItem(ball)
		}
	}
}
let balls = Balls(colors: [#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)])
PlaygroundPage.current.liveView = balls
