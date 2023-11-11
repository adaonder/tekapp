//
//  Dimens.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import Foundation

///Dimens: Boşluk, text ve icon boyutları standart ve tek yerden erişmek için yazıldı.
public class Dimens {
    public static var shared = Dimens()
    
    //Boşluklar
    var spaceSmall: CGFloat = 5
    var spaceNormal: CGFloat = 20
    
    //Metin Boyutları
    var textSizeHeader: CGFloat = 20
    var textSizeTitle: CGFloat = 16
    var textSizeNormal: CGFloat = 14
    
    //Icon Boyutu
    var iconSizeBack: CGFloat = 32
}
