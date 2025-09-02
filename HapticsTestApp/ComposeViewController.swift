import UIKit

/// A full-screen composer with a large UITextView and a neon glow border.
final class ComposeViewController: UIViewController, UITextViewDelegate {

	private let glowView = GlowBorderView()
	private let textView = UITextView()
	private let sendButton = UIButton(type: .system)

	var onSend: ((String) -> Void)?

	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		glowView.startAnimating()
		textView.becomeFirstResponder()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		glowView.stopAnimating()
	}

	private func configureUI() {
		view.backgroundColor = .black

		// Glow border covering the full screen
		glowView.translatesAutoresizingMaskIntoConstraints = false
		glowView.strokeWidth = 14
		glowView.cornerRadius = 50
		glowView.contentInset = 10
		view.addSubview(glowView)

		// Large text input
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.backgroundColor = .clear
		textView.textColor = .white
		textView.font = UIFont.systemFont(ofSize: 20, weight: .regular)
		textView.keyboardDismissMode = .interactive
		textView.delegate = self
		textView.text = ""
		textView.accessibilityLabel = "Message Composer"
		view.addSubview(textView)

		// Floating send button (paper plane icon)
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		var config = UIButton.Configuration.filled()
		config.baseBackgroundColor = .white
		config.baseForegroundColor = .black
		config.cornerStyle = .capsule
		sendButton.configuration = config
		sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
		sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
		sendButton.accessibilityLabel = "Send"
		view.addSubview(sendButton)

		let guide = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			glowView.topAnchor.constraint(equalTo: view.topAnchor),
			glowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			glowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			glowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			textView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 24),
			textView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 24),
			textView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -24),
			textView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -120),

			sendButton.widthAnchor.constraint(equalToConstant: 64),
			sendButton.heightAnchor.constraint(equalToConstant: 64),
			sendButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -24),
			sendButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -24)
		])
	}

	@objc private func handleSend() {
		let text = textView.text ?? ""
		onSend?(text)
		dismiss(animated: true)
	}
}
