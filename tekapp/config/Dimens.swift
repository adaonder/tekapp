//
//  Dimens.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import Foundation

///Dimens: Boşluk, text ve icon boyutları standart ve tek yerden erişmek için yazıldı.
final public class Dimens {
    public static var shared = Dimens()
    
    //MARK: Boşluklar
    var spaceSmall: CGFloat = 5
    var spaceNormal: CGFloat = 20
    
    //MARK: Metin Boyutları
    var textSizeHeader: CGFloat = 20
    var textSizeTitle: CGFloat = 16
    var textSizeNormal: CGFloat = 14
    
    //MARK: Icon Boyutu
    var iconSizeBack: CGFloat = 32
}
