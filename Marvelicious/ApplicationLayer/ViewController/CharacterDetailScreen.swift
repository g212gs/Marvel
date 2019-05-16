//
//  CharacterDetailScreen.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 17/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

class CharacterDetailScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewTableHeader: ParallaxHeader!
    @IBOutlet var viewHeaderComics: UIView!
    @IBOutlet weak var lblAttribution: UILabel!
    
    public var character: Characters? = nil
    public var strAttribution: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.tableView.tableFooterView = UIView()
        
        self.view.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.clear
        
        DispatchQueue.main.async {
            // Main thread implementation
            let frameViewHeader: CGRect = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width)
                , height: 320)
            self.viewTableHeader.frame = frameViewHeader
            self.viewTableHeader.charactersObj = self.character
            self.tableView.tableHeaderView = self.viewTableHeader
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.character?.name ?? "--"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }

}

extension CharacterDetailScreen: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let characterObj = self.character, let comicsArr = characterObj.comics?.items {
            return 1 + ((comicsArr.count > 0) ? 1 : 0)
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            if let characterObj = self.character, let comicsArr = characterObj.comics?.items {
                return comicsArr.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell: CharacterDetailCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailCell.self)
                , for: indexPath) as? CharacterDetailCell {
                cell.cellType = .description
                cell.strDetail = self.character?.descriptionValue ?? ""
                return cell
            }
        default:
            if let characterObj = self.character, let comicsArr = characterObj.comics?.items {
                
                if indexPath.row < comicsArr.count {
                  let comics = comicsArr[indexPath.row]
                    if let cell: CharacterDetailCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailCell.self)
                        , for: indexPath) as? CharacterDetailCell {
                        
                        cell.cellType = .comicsName
                        cell.strDetail = comics.name ?? "--"
                        return cell
                    }
                }
            }
        }
        return UITableViewCell()
    }
}

extension CharacterDetailScreen: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return self.viewHeaderComics
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 1) ? 50.0 : 0.0
    }
}

extension CharacterDetailScreen: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UITableView.self) {
            if let header: ParallaxHeader = self.tableView.tableHeaderView as? ParallaxHeader {
                header.layoutHeaderView(forScrollViewOffset: scrollView.contentOffset, inset: scrollView.contentInset)
                
                self.tableView.tableHeaderView = header
            }
        }
    }
}
