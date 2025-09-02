import UIKit
import QuartzCore

/// A reusable view that renders an animated neon gradient stroke around its bounds.
/// - The effect uses a `CAGradientLayer` masked by a `CAShapeLayer` to produce a colorful stroke.
/// - Colors are animated by rotating the gradient layer, creating a subtle motion similar to iOS accent glows.
final class GlowBorderView: UIView {

	// MARK: - Configuration

	/// Thickness of the visible gradient stroke
	var strokeWidth: CGFloat = 10 { didSet { setNeedsLayout() } }

	/// Corner radius for the rounded-rect border
	var cornerRadius: CGFloat = 44 { didSet { setNeedsLayout() } }

	/// Inset from the view edges to the stroke path
	var contentInset: CGFloat = 6 { didSet { setNeedsLayout() } }

	/// Animation duration for a full rotation of the gradient layer
	var rotationDuration: CFTimeInterval = 10

	/// Gradient colors for the neon effect. Use vivid hues for best results.
	var colors: [UIColor] = [
		UIColor.systemRed,
		UIColor.systemOrange,
		UIColor.systemYellow,
		UIColor.systemGreen,
		UIColor.systemTeal,
		UIColor.systemBlue,
		UIColor.systemIndigo,
		UIColor.systemPurple,
		UIColor.systemPink
	] { didSet { gradientLayer.colors = colors.map { $0.cgColor } } }

	// MARK: - Layers

	private let gradientLayer = CAGradientLayer()
	private let maskShapeLayer = CAShapeLayer()
	private let glowShadowLayer = CAShapeLayer()

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	private func commonInit() {
		isUserInteractionEnabled = false
		backgroundColor = .clear

		// Gradient setup
		gradientLayer.type = .conic
		gradientLayer.colors = colors.map { $0.cgColor }
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		layer.addSublayer(gradientLayer)

		// Mask stroke
		maskShapeLayer.fillColor = UIColor.clear.cgColor
		maskShapeLayer.strokeColor = UIColor.white.cgColor
		maskShapeLayer.lineCap = .round
		maskShapeLayer.lineJoin = .round
		gradientLayer.mask = maskShapeLayer

		// Outer soft glow using shadow on a stroked path (separate layer to not affect mask)
		glowShadowLayer.fillColor = UIColor.clear.cgColor
		glowShadowLayer.strokeColor = UIColor.systemPink.withAlphaComponent(0.7).cgColor
		glowShadowLayer.lineCap = .round
		glowShadowLayer.lineJoin = .round
		glowShadowLayer.shadowColor = UIColor.systemPink.cgColor
		glowShadowLayer.shadowOpacity = 0.9
		glowShadowLayer.shadowRadius = 18
		glowShadowLayer.shadowOffset = .zero
		layer.insertSublayer(glowShadowLayer, below: gradientLayer)
	}

	// MARK: - Layout

	override func layoutSubviews() {
		super.layoutSubviews()
		CATransaction.begin()
		CATransaction.setDisableActions(true)

		gradientLayer.frame = bounds

		let insetBounds = bounds.insetBy(dx: contentInset + strokeWidth / 2, dy: contentInset + strokeWidth / 2)
		let path = UIBezierPath(roundedRect: insetBounds, cornerRadius: cornerRadius)

		maskShapeLayer.path = path.cgPath
		maskShapeLayer.lineWidth = strokeWidth

		glowShadowLayer.path = path.cgPath
		glowShadowLayer.lineWidth = strokeWidth

		CATransaction.commit()
	}

	// MARK: - Animation

	func startAnimating() {
		let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
		rotation.fromValue = 0
		rotation.toValue = 2 * Double.pi
		rotation.duration = rotationDuration
		rotation.repeatCount = .infinity
		rotation.timingFunction = CAMediaTimingFunction(name: .linear)
		gradientLayer.add(rotation, forKey: "gradient-rotation")
	}

	func stopAnimating() {
		gradientLayer.removeAnimation(forKey: "gradient-rotation")
	}
}
