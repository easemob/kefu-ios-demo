//
//  FastRoom+Media.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/2/22.
//

import Whiteboard

extension FastRoom {
    /// Insert MP3 or MP4
    /// - Parameters:
    ///   - src: media source
    ///   - title: media title
    ///   - completionHandler: source id in whiteboard
    @objc
    public func insertMedia(_ src: URL, title: String, completionHandler: ((String)->Void)? = nil) {
        let appParam = WhiteAppParam.createMediaPlayerApp(src.absoluteString, title: title)
        room?.addApp(appParam, completionHandler: completionHandler ?? { _ in })
    }
    
    /// Insert image in current viewer's center
    /// - Parameters:
    ///   - src: image source
    ///   - imageSize: image size
    @objc
    public func insertImg(_ src: URL, imageSize: CGSize) {
        let info = WhiteImageInformation(size: imageSize)
        if let x = room?.state.cameraState?.centerX,
           let y = room?.state.cameraState?.centerY {
            info.centerX = CGFloat(x.floatValue)
            info.centerY = CGFloat(y.floatValue)
        }
        room?.insertImage(info, src: src.absoluteString)
    }
    
    /// Insert pptx
    /// - Parameters:
    ///   - pages: pptx files. source, preview, and itemSize
    ///   - title: pptx's title
    ///   - completionHandler: source id in whiteboard
    @objc
    public func insertPptx(_ pages: [WhitePptPage],
                           title: String,
                           completionHandler: ((String)->Void)? = nil) {
        let scenes = pages.enumerated().map { (index, item) -> WhiteScene in
            return WhiteScene(name: (index + 1).description, ppt: item)
        }
        let appParam = WhiteAppParam.createSlideApp("/" + UUID().uuidString, scenes: scenes, title: title)
        room?.addApp(appParam, completionHandler: completionHandler ?? { _ in })
    }
    
    @objc
    public func insertPptx(uuid: String,
                           url: String,
                           title: String,
                           completionHandler: ((String)->Void)? = nil) {
        let appParam = WhiteAppParam.createSlideApp("/" + UUID().uuidString, taskId: uuid, url: url, title: title)
        room?.addApp(appParam, completionHandler: completionHandler ?? { _ in })
    }
    
    /// Insert pdf, ppt, or doc
    /// - Parameters:
    ///   - pages: files. source, preview, and itemSize
    ///   - title: file title
    ///   - completionHandler: source id in whiteboard
    @objc
    public func insertStaticDocument(_ pages: [WhitePptPage],
                                     title: String,
                                     completionHandler: ((String)->Void)? = nil) {
        let scenes = pages.enumerated().map { (index, item) -> WhiteScene in
            return WhiteScene(name: (index + 1).description, ppt: item)
        }
        let appParam = WhiteAppParam.createDocsViewerApp("/" + UUID().uuidString, scenes: scenes, title: title)
        room?.addApp(appParam, completionHandler: completionHandler ?? { _ in })
    }
}
