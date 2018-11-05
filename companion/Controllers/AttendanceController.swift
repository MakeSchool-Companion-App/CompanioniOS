//
//  AttendanceController.swift
//  companion
//
//  Created by Uchenna  Aguocha on 9/28/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import CoreLocation
class AttendanceController: UIViewController {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var attendance = [Attendance]() {
        didSet {
            DispatchQueue.main.async {
                self.attendanceTableView.reloadData()
            }
            
        }
    }
    
    static let shared = AttendanceController()
    // MARK: - UI Elements
    
    lazy var attendanceTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9019607843, blue: 0.9607843137, alpha: 1)
        tableView.register(AttendanceCell.self, forCellReuseIdentifier: AttendanceCell.attendanceCellId)
        return tableView
    }()
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAutoLayout()
        setupNavbarItem()
        
        GeoFenceServices.startMonitoringMakeschool { (started) in
            if started {
                self.locationManager.delegate = self
            }
        }
        

        
        AttendanceServices.show { (att) in
            print(att)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    // MARK: - UI Setup Methods
    
    private func setupNavbarItem() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "beaconNavItem"), style: .plain, target: self, action: #selector(tapBeaconNavItem))
    
    }
    
    private func setupAutoLayout() {
        
        view.addSubview(attendanceTableView)
        
        attendanceTableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            bottom: view.bottomAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            topPadding: 0,
            rightPadding: 0,
            bottomPadding: 0,
            leftPadding: 0,
            height: 0,
            width: 0)
        
    }
    
    // MARK: - Methods with @objc attribute
    
    @objc private func tapBeaconNavItem() {
        print("Test: Beacon Nav Item Tapped....")
        
        let scanBeaconController = ScanBeaconController()
        self.navigationController?.present(scanBeaconController, animated: true, completion: nil)
        
    }
}

// MARK: - TableView Delegate & DataSource Methods
extension AttendanceController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceCell.attendanceCellId, for: indexPath) as? AttendanceCell else {
            fatalError("Failed to initialize Attendance Cell")
        }
        
        let studentAttendance = attendance[indexPath.row]
        
        cell.checkInDateLabel.text = studentAttendance.event_in
        cell.checkOutTimeLabel.text = studentAttendance.event_in
        cell.checkInTimeLabel.text = studentAttendance.checkInTime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
}

extension AttendanceController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let att = Attendance.init(event: .onEntry, beaconId: "makeschool", event_in: "enter region", event_out: "test", id: 0, user_id: 0)
        AppDelegate.shared.attendanceNotification(attendance: att)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(region.identifier)
        let att = Attendance.init(event: .onEntry, beaconId: "test", event_in: "exit region", event_out: "test", id: 0, user_id: 0)
        AppDelegate.shared.attendanceNotification(attendance: att)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
         print(region.identifier)
        let att = Attendance.init(event: .onEntry, beaconId: "test", event_in: "test", event_out: "test", id: 0, user_id: 0)
        AppDelegate.shared.attendanceNotification(attendance: att)
    }
}
