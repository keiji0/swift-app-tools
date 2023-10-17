//
//  Device.swift
//  
//  
//  Created by keiji0 on 2022/04/09
//  
//

import Foundation

/// SahredConfigureの抽象化されたデバイス
///
/// デバイスID、macOSとiOS/iPadOSで透過的にdeviceIDを識別するためのID
/// UIDevice.current.identifierForVendorはiOSのみでmacOSでは使用できず
/// 端末のSerial Noはアプリケーション側では取得できないので自前のアプリ初起動時にUUIDを生成してそれをDeviceIDとして使用する
public protocol Device : AnyObject, Identifiable {
    /// デバイス間を識別するID
    var id: UUID { get }
}

/// インスタントデバイス
/// UUIDを指定してすぐに利用できるデバイスの実態
public class InstantDevice : Device {
    /// デバイスID
    public let id: UUID
    /// デバイスIDを指定して生成
    public init(_ id: UUID = UUID()) {
        self.id = id
    }
}
