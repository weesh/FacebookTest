//
//  ViewController.swift
//  facebook
//
//  Created by Kenneth Wieschhoff on 3/20/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var eventTable: UITableView!
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "CellDetailTableViewCell", bundle: nil)
        eventTable.register(cellNib, forCellReuseIdentifier: "CellDetailTableViewCell")
        eventTable.estimatedRowHeight = 100.0
        eventTable.rowHeight = UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfEvents() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetailTableViewCell") as? CellDetailTableViewCell,
                let event = viewModel.eventAtIndex(index: indexPath.row) {
            cell.configureCell(event: event)
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Event Doesn't Exist or Couldn't instantiate cell?"
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetailTableViewCell") as? CellDetailTableViewCell {
            return cell.frame.height
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
}

