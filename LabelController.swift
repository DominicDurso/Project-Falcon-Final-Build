//
//  LabelController.swift
//  Project Falcon V4
//
//  Created by Dominic Durso on 10/7/24.
//
import UIKit
import WebKit
import SwiftSoup
class LabelController: UIViewController, WKNavigationDelegate {
    
    var dateLabel: UILabel!
    var periods: UILabel!
    var lab: UILabel!
    var scheduleForLabel: UILabel!
    var advisoryLabel: UILabel!
    var flexLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textAlignment = .center
        view.addSubview(dateLabel)

        scheduleForLabel = UILabel()
        scheduleForLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleForLabel.font = UIFont.systemFont(ofSize: 16)
        scheduleForLabel.textAlignment = .center
        scheduleForLabel.numberOfLines = 0
        view.addSubview(scheduleForLabel)

        // Chapel Schedule Container
        let chapelContainerView = UIView()
        chapelContainerView.translatesAutoresizingMaskIntoConstraints = false
        chapelContainerView.backgroundColor = UIColor(named: "DarkNavyBlue") ?? UIColor(red: 0.0, green: 0.15, blue: 0.35, alpha: 1.0)
        chapelContainerView.layer.cornerRadius = 8
        chapelContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(chapelContainerView)
        
        // Add the label to the container
        lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = UIFont.boldSystemFont(ofSize: 32)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.lineBreakMode = .byWordWrapping
        lab.textColor = .white
        chapelContainerView.addSubview(lab)

        // PERIODS CONTAINER
        let periodsContainerView = UIView()
        periodsContainerView.translatesAutoresizingMaskIntoConstraints = false
        periodsContainerView.backgroundColor = .white
        periodsContainerView.layer.borderWidth = 1
        periodsContainerView.layer.borderColor = UIColor.lightGray.cgColor
        periodsContainerView.layer.cornerRadius = 8
        periodsContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        // Shadow
        periodsContainerView.layer.shadowColor = UIColor.black.cgColor
        periodsContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        periodsContainerView.layer.shadowRadius = 8
        periodsContainerView.layer.shadowOpacity = 0.09
        view.addSubview(periodsContainerView)

        periods = UILabel()
        periods.translatesAutoresizingMaskIntoConstraints = false
        periods.textAlignment = .left
        periods.numberOfLines = 0
        periods.font = UIFont.boldSystemFont(ofSize: 28)
        periodsContainerView.addSubview(periods)

        // Gold Divider Bar
        let dividerBar = UIView()
        dividerBar.translatesAutoresizingMaskIntoConstraints = false
        dividerBar.backgroundColor = UIColor(named: "GoldColor") ?? UIColor(red: 0.95, green: 0.76, blue: 0.2, alpha: 1.0)
        view.addSubview(dividerBar)

        // ADVISORY CONTAINER
        let advisoryContainerView = UIView()
        advisoryContainerView.translatesAutoresizingMaskIntoConstraints = false
        advisoryContainerView.backgroundColor = .white
        advisoryContainerView.layer.borderWidth = 1
        advisoryContainerView.layer.cornerRadius = 8
        advisoryContainerView.layer.borderColor = UIColor.lightGray.cgColor
        advisoryContainerView.layer.shadowColor = UIColor.black.cgColor
        advisoryContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        advisoryContainerView.layer.shadowRadius = 8
        advisoryContainerView.layer.shadowOpacity = 0.09

        advisoryLabel = UILabel()
        advisoryLabel.translatesAutoresizingMaskIntoConstraints = false
        advisoryLabel.font = UIFont.systemFont(ofSize: 16)
        advisoryLabel.textAlignment = .center
        advisoryLabel.numberOfLines = 0
        advisoryContainerView.addSubview(advisoryLabel)

        NSLayoutConstraint.activate([
            advisoryLabel.topAnchor.constraint(equalTo: advisoryContainerView.topAnchor, constant: 12),
            advisoryLabel.bottomAnchor.constraint(equalTo: advisoryContainerView.bottomAnchor, constant: -12),
            advisoryLabel.leadingAnchor.constraint(equalTo: advisoryContainerView.leadingAnchor, constant: 20),
            advisoryLabel.trailingAnchor.constraint(equalTo: advisoryContainerView.trailingAnchor, constant: -20),
        ])

        // FLEX CONTAINER
        let flexContainerView = UIView()
        flexContainerView.translatesAutoresizingMaskIntoConstraints = false
        flexContainerView.backgroundColor = .white
        flexContainerView.layer.borderWidth = 1
        flexContainerView.layer.cornerRadius = 8
        flexContainerView.layer.borderColor = UIColor.lightGray.cgColor
        flexContainerView.layer.shadowColor = UIColor.black.cgColor
        flexContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        flexContainerView.layer.shadowRadius = 8
        flexContainerView.layer.shadowOpacity = 0.09

        flexLabel = UILabel()
        flexLabel.translatesAutoresizingMaskIntoConstraints = false
        flexLabel.font = UIFont.systemFont(ofSize: 16)
        flexLabel.textAlignment = .center
        flexLabel.numberOfLines = 0
        flexContainerView.addSubview(flexLabel)

        NSLayoutConstraint.activate([
            flexLabel.topAnchor.constraint(equalTo: flexContainerView.topAnchor, constant: 12),
            flexLabel.bottomAnchor.constraint(equalTo: flexContainerView.bottomAnchor, constant: -12),
            flexLabel.leadingAnchor.constraint(equalTo: flexContainerView.leadingAnchor, constant: 20),
            flexLabel.trailingAnchor.constraint(equalTo: flexContainerView.trailingAnchor, constant: -20),
        ])

        // Stack view for advisory and flex containers
        let infoStackView = UIStackView(arrangedSubviews: [advisoryContainerView, flexContainerView])
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillEqually
        infoStackView.spacing = 16
        view.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            scheduleForLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 40),
            scheduleForLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            chapelContainerView.topAnchor.constraint(equalTo: scheduleForLabel.bottomAnchor, constant: 24),
            chapelContainerView.leadingAnchor.constraint(equalTo: periodsContainerView.leadingAnchor),
            chapelContainerView.trailingAnchor.constraint(equalTo: periodsContainerView.trailingAnchor),
            
            dividerBar.topAnchor.constraint(equalTo: chapelContainerView.bottomAnchor),
            dividerBar.leadingAnchor.constraint(equalTo: periodsContainerView.leadingAnchor),
            dividerBar.trailingAnchor.constraint(equalTo: periodsContainerView.trailingAnchor),
            dividerBar.heightAnchor.constraint(equalToConstant: 2), // Thin bar

            periodsContainerView.topAnchor.constraint(equalTo: dividerBar.bottomAnchor),
            periodsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            periodsContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            periodsContainerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
        ])

        NSLayoutConstraint.activate([
            periods.topAnchor.constraint(equalTo: periodsContainerView.topAnchor, constant: 12),
            periods.bottomAnchor.constraint(equalTo: periodsContainerView.bottomAnchor, constant: -12),
            periods.leadingAnchor.constraint(equalTo: periodsContainerView.leadingAnchor, constant: 20),
            periods.trailingAnchor.constraint(equalTo: periodsContainerView.trailingAnchor, constant: -20),
            periods.centerXAnchor.constraint(equalTo: periodsContainerView.centerXAnchor),

            infoStackView.topAnchor.constraint(equalTo: periodsContainerView.bottomAnchor, constant: 20),
            infoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
        ])
        
        updateScheduleLabel()
    }
    
    func updateScheduleLabel() {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"

        let today = Date()
        let validDate = today

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("📆 Today (yyyy-MM-dd): \(formatter.string(from: validDate))")

        print("🟡 Today is: \(validDate)")

        if StaticSchedule.isNoSchoolDay(validDate) {
            print("🛑 Today is a no school day")
        } else {
            print("✅ Today is a school day")
        }

        if let cycleNum = StaticSchedule.cycleDay(for: validDate) {
            print("🔁 Found cycle day: \(cycleNum)")
            let periodsList = CycleDays.match(day: cycleNum).getPeriods()
            print("📚 Period Order: \(periodsList)")
        } else {
            print("❌ No cycle day found for today")
        }

        guard !StaticSchedule.isNoSchoolDay(validDate),
              let cycleDayNumber = StaticSchedule.cycleDay(for: validDate),
              let scheduleType = StaticSchedule.scheduleType(for: validDate),
              let slots = StaticSchedule.schedule(for: scheduleType) else {
            scheduleForLabel.text = "No Schedule Found"
            lab?.text = ""
            periods.text = ""
            advisoryLabel.text = ""
            flexLabel.text = ""
            return
        }

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"

        dateLabel.text = dateFormatter.string(from: today)
        scheduleForLabel.text = "Schedule for \(weekdayFormatter.string(from: today))"

        print("📋 scheduleType: \(String(describing: scheduleType))")

        print("🔢 cycleDayNumber: \(String(describing: cycleDayNumber))")

        let periodOrder = CycleDays.match(day: cycleDayNumber).getPeriods()
        print("🔠 Final Period Letters for Schedule: \(periodOrder)")
        print("🕒 Time Slots: \(slots.map { "\($0.startTime)-\($0.endTime)" })")

        guard periodOrder.count == slots.count else {
            print("🚫 Mismatched schedule slot and period letter count")
            lab?.text = "Schedule Error"
            periods.text = ""
            return
        }

        let combinedSchedule = zip(periodOrder, slots).map { label, slot in
            let labelText = NSMutableAttributedString(string: "\(label): ", attributes: [
                .font: UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold),
                .foregroundColor: UIColor.black
            ])
            let timeText = NSAttributedString(string: "\(slot.startTime)–\(slot.endTime)", attributes: [
                .font: UIFont.systemFont(ofSize: 24),
                .foregroundColor: UIColor.black
            ])
            labelText.append(timeText)
            return labelText
        }

        lab?.text = "\(scheduleType.name) Schedule"
        // Ensure lab is still added to chapelContainerView and constraints are active
        if lab.superview == nil {
            // Find chapelContainerView by traversing up the view hierarchy from lab
            if let chapelContainerView = periods.superview?.superview?.subviews.first(where: { $0.subviews.contains(lab) }) ?? view.subviews.first(where: { $0.subviews.contains(lab) }) {
                chapelContainerView.addSubview(lab)
            }
        }
        NSLayoutConstraint.activate([
            lab.topAnchor.constraint(equalTo: lab.superview!.topAnchor, constant: 10),
            lab.bottomAnchor.constraint(equalTo: lab.superview!.bottomAnchor, constant: -10),
            lab.leadingAnchor.constraint(equalTo: lab.superview!.leadingAnchor, constant: 10),
            lab.trailingAnchor.constraint(equalTo: lab.superview!.trailingAnchor, constant: -10),
        ])
        let info = StaticSchedule.advisoryAndFlexInfo(for: scheduleType)

        let advisoryStatus = info.hasAdvisory ? "Yes" : "No"
        let flexStatus = info.hasFlex ? "Yes" : "No"

        let advisoryText = NSMutableAttributedString(string: "Advisory\n", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ])
        advisoryText.append(NSAttributedString(string: advisoryStatus, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]))
        advisoryLabel.attributedText = advisoryText

        let flexText = NSMutableAttributedString(string: "Flex\n", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ])
        flexText.append(NSAttributedString(string: flexStatus, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]))
        flexLabel.attributedText = flexText

        let fullScheduleText = NSMutableAttributedString()
        for (index, item) in combinedSchedule.enumerated() {
            fullScheduleText.append(item)
            if index < combinedSchedule.count - 1 {
                fullScheduleText.append(NSAttributedString(string: "\n"))
            }
        }
        periods.attributedText = fullScheduleText
    }
    
    // No longer needed; remove handleScrapedData
    
    // No longer needed; remove getLabelString
}
