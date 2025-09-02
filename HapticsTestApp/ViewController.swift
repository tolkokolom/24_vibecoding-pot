//
//  ViewController.swift
//  HapticsTestApp
//
//  Created by Developer on Current Date.
//  Copyright © 2024 Your Name. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    // Decorative background glow (non-interactive)
    private let backgroundGlow = GlowBorderView()
    private let composeButton = UIButton(type: .system)
    
    // MARK: - Haptic Properties
    
    /// Impact Feedback Generators
    private let lightImpactFeedback = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    private let rigidImpactFeedback = UIImpactFeedbackGenerator(style: .rigid)
    private let softImpactFeedback = UIImpactFeedbackGenerator(style: .soft)
    
    /// Notification Feedback Generator
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    /// Selection Feedback Generator
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    // MARK: - State Properties
    private var isHapticsEnabled = true
    private var currentCategory = 0 // 0: Impact, 1: Notification, 2: Selection
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDecor()
        setupUI()
        setupHaptics()
        createHapticControls()
        setupComposeButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundGlow.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundGlow.stopAnimating()
    }
    
    private func setupDecor() {
        backgroundGlow.translatesAutoresizingMaskIntoConstraints = false
        backgroundGlow.isUserInteractionEnabled = false
        backgroundGlow.alpha = 0.6
        backgroundGlow.strokeWidth = 12
        backgroundGlow.cornerRadius = 40
        backgroundGlow.contentInset = 0
        // Put on top of all content
        view.addSubview(backgroundGlow)
        backgroundGlow.layer.zPosition = 1000
        NSLayoutConstraint.activate([
            backgroundGlow.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundGlow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundGlow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundGlow.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupComposeButton() {
        composeButton.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        composeButton.configuration = config
        composeButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        composeButton.accessibilityLabel = "Compose"
        composeButton.addTarget(self, action: #selector(openComposer), for: .touchUpInside)
        view.addSubview(composeButton)
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            composeButton.widthAnchor.constraint(equalToConstant: 56),
            composeButton.heightAnchor.constraint(equalToConstant: 56),
            composeButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            composeButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func openComposer() {
        let composer = ComposeViewController()
        composer.modalPresentationStyle = .overFullScreen
        composer.modalTransitionStyle = .coverVertical
        composer.onSend = { [weak self] _ in
            guard let self else { return }
            if self.isHapticsEnabled {
                self.notificationFeedback.notificationOccurred(.success)
            }
        }
        present(composer, animated: true)
        if isHapticsEnabled { lightImpactFeedback.impactOccurred() }
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        // Configure main UI elements
        titleLabel.text = "VIBECOOODEEEEEEERS NAHUUUUY"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        descriptionLabel.text = "Explore all iOS haptic feedback types. Each button demonstrates different haptic patterns that you can feel on your iPhone."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        
        // Configure segmented control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Impact", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Notification", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Selection", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(categoryChanged(_:)), for: .valueChanged)
        
        // Configure scroll view and stack view
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        view.backgroundColor = .systemBackground
    }
    
    private func setupHaptics() {
        // Prepare all haptic feedback generators
        // This ensures they're ready to provide immediate feedback
        lightImpactFeedback.prepare()
        mediumImpactFeedback.prepare()
        heavyImpactFeedback.prepare()
        rigidImpactFeedback.prepare()
        softImpactFeedback.prepare()
        notificationFeedback.prepare()
        selectionFeedback.prepare()
    }
    
    private func createHapticControls() {
        // Clear existing controls
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add haptics toggle
        let hapticsToggle = createToggleSection(
            title: "Enable Haptics",
            isOn: isHapticsEnabled,
            action: #selector(hapticsToggled(_:))
        )
        stackView.addArrangedSubview(hapticsToggle)
        
        // Add separator
        let separator = createSeparator()
        stackView.addArrangedSubview(separator)
        
        // Add category-specific controls
        switch currentCategory {
        case 0:
            createImpactControls()
        case 1:
            createNotificationControls()
        case 2:
            createSelectionControls()
        default:
            break
        }
    }
    
    // MARK: - Impact Haptics
    
    private func createImpactControls() {
        let title = createSectionTitle("Impact Feedback")
        stackView.addArrangedSubview(title)
        
        let subtitle = createSubtitle("Physical impact sensations with varying intensities")
        stackView.addArrangedSubview(subtitle)
        
        // Light Impact
        let lightButton = createHapticButton(
            title: "Light Impact",
            subtitle: "Subtle, gentle vibration",
            systemImage: "circle.fill",
            action: #selector(lightImpactTapped)
        )
        stackView.addArrangedSubview(lightButton)
        
        // Medium Impact
        let mediumButton = createHapticButton(
            title: "Medium Impact",
            subtitle: "Moderate vibration strength",
            systemImage: "circle.fill",
            action: #selector(mediumImpactTapped)
        )
        stackView.addArrangedSubview(mediumButton)
        
        // Heavy Impact
        let heavyButton = createHapticButton(
            title: "Heavy Impact",
            subtitle: "Strong, pronounced vibration",
            systemImage: "circle.fill",
            action: #selector(heavyImpactTapped)
        )
        stackView.addArrangedSubview(heavyButton)
        
        // Rigid Impact (iOS 13+)
        let rigidButton = createHapticButton(
            title: "Rigid Impact",
            subtitle: "Sharp, precise vibration",
            systemImage: "square.fill",
            action: #selector(rigidImpactTapped)
        )
        stackView.addArrangedSubview(rigidButton)
        
        // Soft Impact (iOS 13+)
        let softButton = createHapticButton(
            title: "Soft Impact",
            subtitle: "Gentle, rounded vibration",
            systemImage: "oval.fill",
            action: #selector(softImpactTapped)
        )
        stackView.addArrangedSubview(softButton)
    }
    
    // MARK: - Notification Haptics
    
    private func createNotificationControls() {
        let title = createSectionTitle("Notification Feedback")
        stackView.addArrangedSubview(title)
        
        let subtitle = createSubtitle("Contextual feedback for different notification types")
        stackView.addArrangedSubview(subtitle)
        
        // Success Notification
        let successButton = createHapticButton(
            title: "Success",
            subtitle: "Positive outcome feedback",
            systemImage: "checkmark.circle.fill",
            action: #selector(successNotificationTapped)
        )
        stackView.addArrangedSubview(successButton)
        
        // Warning Notification
        let warningButton = createHapticButton(
            title: "Warning",
            subtitle: "Cautionary feedback",
            systemImage: "exclamationmark.triangle.fill",
            action: #selector(warningNotificationTapped)
        )
        stackView.addArrangedSubview(warningButton)
        
        // Error Notification
        let errorButton = createHapticButton(
            title: "Error",
            subtitle: "Negative outcome feedback",
            systemImage: "xmark.circle.fill",
            action: #selector(errorNotificationTapped)
        )
        stackView.addArrangedSubview(errorButton)
    }
    
    // MARK: - Selection Haptics
    
    private func createSelectionControls() {
        let title = createSectionTitle("Selection Feedback")
        stackView.addArrangedSubview(title)
        
        let subtitle = createSubtitle("Feedback for UI element selection and interaction")
        stackView.addArrangedSubview(subtitle)
        
        // Single Selection
        let selectionButton = createHapticButton(
            title: "Selection Changed",
            subtitle: "Single selection feedback",
            systemImage: "hand.tap.fill",
            action: #selector(selectionTapped)
        )
        stackView.addArrangedSubview(selectionButton)
        
        // Multiple Selections Demo
        let multipleButton = createHapticButton(
            title: "Multiple Selections",
            subtitle: "Rapid selection changes",
            systemImage: "hand.tap.fill",
            action: #selector(multipleSelectionsTapped)
        )
        stackView.addArrangedSubview(multipleButton)
        
        // Picker Demo
        let pickerDemo = createPickerDemo()
        stackView.addArrangedSubview(pickerDemo)
    }
    
    // MARK: - UI Creation Helpers
    
    private func createSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }
    
    private func createSubtitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }
    
    private func createToggleSection(title: String, isOn: Bool, action: Selector) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.addTarget(self, action: action, for: .valueChanged)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(toggle)
        
        container.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        return container
    }
    
    private func createHapticButton(title: String, subtitle: String, systemImage: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 12
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Create content stack view
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.isUserInteractionEnabled = false
        
        // Icon
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: systemImage)
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Text stack
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textStack)
        
        button.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: button.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -16)
        ])
        
        return button
    }
    
    private func createPickerDemo() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = "Picker Selection Demo"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textAlignment = .center
        
        let picker = UISegmentedControl()
        picker.insertSegment(withTitle: "Option 1", at: 0, animated: false)
        picker.insertSegment(withTitle: "Option 2", at: 1, animated: false)
        picker.insertSegment(withTitle: "Option 3", at: 2, animated: false)
        picker.selectedSegmentIndex = 0
        picker.addTarget(self, action: #selector(pickerSelectionChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(picker)
        
        container.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        return container
    }
    
    // MARK: - Actions
    
    @objc private func categoryChanged(_ sender: UISegmentedControl) {
        currentCategory = sender.selectedSegmentIndex
        // Trigger selection feedback when switching categories
        if isHapticsEnabled {
            selectionFeedback.selectionChanged()
        }
        createHapticControls()
    }
    
    @objc private func hapticsToggled(_ sender: UISwitch) {
        isHapticsEnabled = sender.isOn
        // Provide feedback for the toggle action itself
        if isHapticsEnabled {
            lightImpactFeedback.impactOccurred()
        }
    }
    
    // MARK: - Impact Feedback Actions
    
    @objc private func lightImpactTapped() {
        guard isHapticsEnabled else { return }
        lightImpactFeedback.impactOccurred()
    }
    
    @objc private func mediumImpactTapped() {
        guard isHapticsEnabled else { return }
        mediumImpactFeedback.impactOccurred()
    }
    
    @objc private func heavyImpactTapped() {
        guard isHapticsEnabled else { return }
        heavyImpactFeedback.impactOccurred()
    }
    
    @objc private func rigidImpactTapped() {
        guard isHapticsEnabled else { return }
        rigidImpactFeedback.impactOccurred()
    }
    
    @objc private func softImpactTapped() {
        guard isHapticsEnabled else { return }
        softImpactFeedback.impactOccurred()
    }
    
    // MARK: - Notification Feedback Actions
    
    @objc private func successNotificationTapped() {
        guard isHapticsEnabled else { return }
        notificationFeedback.notificationOccurred(.success)
    }
    
    @objc private func warningNotificationTapped() {
        guard isHapticsEnabled else { return }
        notificationFeedback.notificationOccurred(.warning)
    }
    
    @objc private func errorNotificationTapped() {
        guard isHapticsEnabled else { return }
        notificationFeedback.notificationOccurred(.error)
    }
    
    // MARK: - Selection Feedback Actions
    
    @objc private func selectionTapped() {
        guard isHapticsEnabled else { return }
        selectionFeedback.selectionChanged()
    }
    
    @objc private func multipleSelectionsTapped() {
        guard isHapticsEnabled else { return }
        // Simulate rapid selections with delays
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                self.selectionFeedback.selectionChanged()
            }
        }
    }
    
    @objc private func pickerSelectionChanged(_ sender: UISegmentedControl) {
        guard isHapticsEnabled else { return }
        selectionFeedback.selectionChanged()
    }
}
