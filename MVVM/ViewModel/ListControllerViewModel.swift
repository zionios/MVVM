//
//  ListControllerViewModel.swift
//  MVVM
//
//  Created by 성준 on 2022/03/28.
//

import Foundation

final class ListControllerViewModel {

    var users: Observable<[UserTableViewCellViewModel]> = Observable(value: [])
    var filterdUsers: Observable<[UserTableViewCellViewModel]> = Observable(value: [])
    
    func fetchUsersData() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users")  else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            do {
                let userModels = try JSONDecoder().decode([User].self, from: data)
                self.users.value = userModels.compactMap({ user in
                    UserTableViewCellViewModel(name: user.name)
                })
                self.filterdUsers.value = self.users.value
                
            } catch let e {
                print(e.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func userNameContainsFilter(_ name: String) {
        guard name != "" else {
            filterdUsers.value = users.value
            return
        }
        
        filterdUsers.value = users.value?.filter({ model in
            model.name.contains(name)
        })
    }
}


