import SwiftUI
import UniformTypeIdentifiers
import Foundation
import CoreFoundation
import Combine
import AppKit

// MARK: - 全局语言数据库 (包含搜索词典)
struct LanguageInfo: Identifiable {
    let code: String
    let name: String
    var id: String { code }
}

struct LanguageDB {
    // 默认展示的常用语言
    static let commonLanguages = [
        LanguageInfo(code: "chi", name: "中文"),
        LanguageInfo(code: "eng", name: "英语"),
        LanguageInfo(code: "jpn", name: "日语"),
        LanguageInfo(code: "kor", name: "韩语"),
        LanguageInfo(code: "fre", name: "法语"),
        LanguageInfo(code: "ger", name: "德语"),
        LanguageInfo(code: "ita", name: "意大利语"),
        LanguageInfo(code: "und", name: "未指定")
    ]
    
    // 超大冷门语言库 (涵盖全球绝大多数带有 ISO 639-2 标准代码的语言)
    static let allLanguages: [LanguageInfo] = [
        LanguageInfo(code: "afr", name: "南非荷兰语"), LanguageInfo(code: "amh", name: "阿姆哈拉语"),
        LanguageInfo(code: "ara", name: "阿拉伯语"), LanguageInfo(code: "asm", name: "阿萨姆语"),
        LanguageInfo(code: "aze", name: "阿塞拜疆语"), LanguageInfo(code: "bel", name: "白俄罗斯语"),
        LanguageInfo(code: "ben", name: "孟加拉语"), LanguageInfo(code: "bos", name: "波斯尼亚语"),
        LanguageInfo(code: "bul", name: "保加利亚语"), LanguageInfo(code: "cat", name: "加泰罗尼亚语"),
        LanguageInfo(code: "ces", name: "捷克语"), LanguageInfo(code: "chi", name: "中文"),
        LanguageInfo(code: "cym", name: "威尔士语"), LanguageInfo(code: "dan", name: "丹麦语"),
        LanguageInfo(code: "dut", name: "荷兰语"), LanguageInfo(code: "ell", name: "希腊语"),
        LanguageInfo(code: "eng", name: "英语"), LanguageInfo(code: "epo", name: "世界语"),
        LanguageInfo(code: "est", name: "爱沙尼亚语"), LanguageInfo(code: "eus", name: "巴斯克语"),
        LanguageInfo(code: "fas", name: "波斯语"), LanguageInfo(code: "fin", name: "芬兰语"),
        LanguageInfo(code: "fre", name: "法语"), LanguageInfo(code: "ger", name: "德语"),
        LanguageInfo(code: "glg", name: "加利西亚语"), LanguageInfo(code: "guj", name: "古吉拉特语"),
        LanguageInfo(code: "heb", name: "希伯来语"), LanguageInfo(code: "hin", name: "印地语"),
        LanguageInfo(code: "hrv", name: "克罗地亚语"), LanguageInfo(code: "hun", name: "匈牙利语"),
        LanguageInfo(code: "hye", name: "亚美尼亚语"), LanguageInfo(code: "ind", name: "印尼语"),
        LanguageInfo(code: "isl", name: "冰岛语"), LanguageInfo(code: "ita", name: "意大利语"),
        LanguageInfo(code: "jpn", name: "日语"), LanguageInfo(code: "kan", name: "卡纳达语"),
        LanguageInfo(code: "kat", name: "格鲁吉亚语"), LanguageInfo(code: "kaz", name: "哈萨克语"),
        LanguageInfo(code: "khm", name: "高棉语"), LanguageInfo(code: "kor", name: "韩语"),
        LanguageInfo(code: "kur", name: "库尔德语"), LanguageInfo(code: "lao", name: "老挝语"),
        LanguageInfo(code: "lat", name: "拉丁语"), LanguageInfo(code: "lav", name: "拉脱维亚语"),
        LanguageInfo(code: "lit", name: "立陶宛语"), LanguageInfo(code: "mac", name: "马其顿语"),
        LanguageInfo(code: "mal", name: "马拉雅拉姆语"), LanguageInfo(code: "mar", name: "马拉地语"),
        LanguageInfo(code: "mlt", name: "马耳他语"), LanguageInfo(code: "mon", name: "蒙古语"),
        LanguageInfo(code: "mya", name: "缅甸语"), LanguageInfo(code: "nep", name: "尼泊尔语"),
        LanguageInfo(code: "nor", name: "挪威语"), LanguageInfo(code: "pan", name: "旁遮普语"),
        LanguageInfo(code: "pol", name: "波兰语"), LanguageInfo(code: "por", name: "葡萄牙语"),
        LanguageInfo(code: "rum", name: "罗马尼亚语"), LanguageInfo(code: "rus", name: "俄语"),
        LanguageInfo(code: "san", name: "梵语"), LanguageInfo(code: "sin", name: "僧伽罗语"),
        LanguageInfo(code: "slo", name: "斯洛伐克语"), LanguageInfo(code: "slv", name: "斯洛文尼亚语"),
        LanguageInfo(code: "spa", name: "西班牙语"), LanguageInfo(code: "srp", name: "塞尔维亚语"),
        LanguageInfo(code: "swa", name: "斯瓦希里语"), LanguageInfo(code: "swe", name: "瑞典语"),
        LanguageInfo(code: "tam", name: "泰米尔语"), LanguageInfo(code: "tel", name: "泰卢固语"),
        LanguageInfo(code: "tgk", name: "塔吉克语"), LanguageInfo(code: "tgl", name: "他加禄语"),
        LanguageInfo(code: "tha", name: "泰语"), LanguageInfo(code: "tur", name: "土耳其语"),
        LanguageInfo(code: "ukr", name: "乌克兰语"), LanguageInfo(code: "und", name: "未指定"),
        LanguageInfo(code: "urd", name: "乌尔都语"), LanguageInfo(code: "uzb", name: "乌兹别克语"),
        LanguageInfo(code: "vie", name: "越南语"), LanguageInfo(code: "wel", name: "威尔士语"),
        LanguageInfo(code: "yid", name: "意第绪语"), LanguageInfo(code: "zho", name: "中文(Zho)"),
        LanguageInfo(code: "zul", name: "祖鲁语")
    ]
    
    // 工具函数：根据代码反查语言名称
    static func getName(for code: String) -> String {
        if let lang = allLanguages.first(where: { $0.code == code }) {
            return lang.name
        }
        return "未知语言"
    }
}

// MARK: - 数据模型：轨道信息
struct MediaTrack: Identifiable, Equatable {
    let id = UUID()
    let trackID: Int
    let type: String
    let codec: String
    var language: String
    var isExternal: Bool
}

// MARK: - 数据模型：封装任务
struct MuxJob: Identifiable, Equatable {
    let id = UUID()
    let baseName: String
    let videoURL: URL
    let subtitleURL: URL
    var status: String = "等待中"
    var outputURL: URL? = nil
    var mediaInfoURL: URL? = nil
    var screenshotURLs: [URL] = []
    
    var internalTracks: [MediaTrack] = []
    var externalSubtitleTrack: MediaTrack
}

// MARK: - 逻辑处理 ViewModel
class MuxerViewModel: ObservableObject {
    private enum PreferenceKey {
        static let backgroundImagePath = "backgroundImagePath"
        static let backgroundOpacity = "backgroundOpacity"
    }

    private enum PostProcessingError: LocalizedError {
        case toolUnavailable(String)
        case commandFailed(String)
        case invalidOutput(String)

        var errorDescription: String? {
            switch self {
            case .toolUnavailable(let tool):
                return "未找到 \(tool) 命令行工具"
            case .commandFailed(let message), .invalidOutput(let message):
                return message
            }
        }
    }

    private let preferences: UserDefaults

    @Published var jobs: [MuxJob] = []
    @Published var selectedJobID: UUID?
    @Published var isProcessing = false
    
    // 命名与路径状态
    @Published var outputDirectory: URL? = nil
    @Published var mediaInfoDirectory: URL? = nil
    @Published var screenshotDirectory: URL? = nil
    @Published var mediaInfoCount: Int = 1
    @Published var screenshotCount: Int = 3
    @Published var backgroundImageURL: URL? = nil {
        didSet {
            if let path = backgroundImageURL?.path {
                preferences.set(path, forKey: PreferenceKey.backgroundImagePath)
            } else {
                preferences.removeObject(forKey: PreferenceKey.backgroundImagePath)
            }
        }
    }
    @Published var backgroundOpacity: Double = 0.15 {
        didSet {
            preferences.set(backgroundOpacity, forKey: PreferenceKey.backgroundOpacity)
        }
    }
    @Published var customShowName: String = ""
    @Published var outputPrefix: String = "S01E"
    @Published var customSuffix: String = ""

    init(preferences: UserDefaults = .standard) {
        self.preferences = preferences

        if let path = preferences.string(forKey: PreferenceKey.backgroundImagePath),
           FileManager.default.fileExists(atPath: path) {
            backgroundImageURL = URL(fileURLWithPath: path)
        }

        if preferences.object(forKey: PreferenceKey.backgroundOpacity) != nil {
            let savedOpacity = preferences.double(forKey: PreferenceKey.backgroundOpacity)
            if savedOpacity.isFinite {
                backgroundOpacity = min(max(savedOpacity, 0), 1)
            }
        }
    }
    
    // 智能获取打包后的 mkvmerge 路径
    var mkvmergePath: String {
        // 优先寻找 App 内部的绿色版
        if let bundledPath = Bundle.main.path(forResource: "mkvmerge", ofType: nil, inDirectory: "mkvmerge_portable") {
            return bundledPath
        }
        // 回退机制
        if FileManager.default.fileExists(atPath: "/opt/homebrew/bin/mkvmerge") {
            return "/opt/homebrew/bin/mkvmerge"
        }
        return "/usr/local/bin/mkvmerge"
    }

    var mediaInfoPath: String? {
        if let bundledPath = Bundle.main.path(forResource: "mediainfo", ofType: nil, inDirectory: "mediainfo_portable") {
            return bundledPath
        }
        if FileManager.default.isExecutableFile(atPath: "/opt/homebrew/bin/mediainfo") {
            return "/opt/homebrew/bin/mediainfo"
        }
        if FileManager.default.isExecutableFile(atPath: "/usr/local/bin/mediainfo") {
            return "/usr/local/bin/mediainfo"
        }
        return nil
    }

    var ffmpegPath: String? {
        if let bundledPath = Bundle.main.path(forResource: "ffmpeg", ofType: nil, inDirectory: "ffmpeg_portable") {
            return bundledPath
        }
        if FileManager.default.isExecutableFile(atPath: "/opt/homebrew/bin/ffmpeg") {
            return "/opt/homebrew/bin/ffmpeg"
        }
        if FileManager.default.isExecutableFile(atPath: "/usr/local/bin/ffmpeg") {
            return "/usr/local/bin/ffmpeg"
        }
        return nil
    }

    var ffprobePath: String? {
        if let bundledPath = Bundle.main.path(forResource: "ffprobe", ofType: nil, inDirectory: "ffmpeg_portable") {
            return bundledPath
        }
        if FileManager.default.isExecutableFile(atPath: "/opt/homebrew/bin/ffprobe") {
            return "/opt/homebrew/bin/ffprobe"
        }
        if FileManager.default.isExecutableFile(atPath: "/usr/local/bin/ffprobe") {
            return "/usr/local/bin/ffprobe"
        }
        return nil
    }

    var selectedOutputURL: URL? {
        guard let selectedJobID,
              let job = jobs.first(where: { $0.id == selectedJobID }) else { return nil }
        return job.outputURL
    }

    
    // 动态生成预览文件名
    var previewFileName: String {
        if let selectedID = selectedJobID, let job = jobs.first(where: { $0.id == selectedID }) {
            return outputFileName(for: job)
        } else {
            return "\(customShowName)\(outputPrefix)01\(customSuffix).mkv"
        }
    }
    
    func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "选择包含源视频和字幕的文件夹"
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                scanAndMatchFiles(in: url)
            }
        }
    }
    
    func selectOutputDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "选择封装后文件的保存目录"
        panel.prompt = "设为保存目录"
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                self.outputDirectory = url
                prefillNamingFields(from: url.lastPathComponent)
            }
        }
    }

    func selectMediaInfoDirectory() {
        selectArtifactDirectory(
            message: "选择 MediaInfo 文本的保存目录",
            prompt: "设为 MediaInfo 目录"
        ) { self.mediaInfoDirectory = $0 }
    }

    func selectScreenshotDirectory() {
        selectArtifactDirectory(
            message: "选择字幕截图的保存目录",
            prompt: "设为截图目录"
        ) { self.screenshotDirectory = $0 }
    }

    func selectBackgroundImage() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.image]
        panel.message = "选择界面背景图片"
        panel.prompt = "使用此图片"
        if panel.runModal() == .OK {
            backgroundImageURL = panel.url
        }
    }

    private func selectArtifactDirectory(message: String, prompt: String, completion: (URL) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = message
        panel.prompt = prompt

        if panel.runModal() == .OK, let url = panel.url {
            completion(url)
        }
    }

    private func prefillNamingFields(from folderName: String) {
        // 目录名通常是“主体名.S02.后缀”；以最后一个季号作为拆分点。
        let pattern = "(?i)S(\\d{1,2})(?:E\\d*(?:\\.\\d+)?)?"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return }

        let fullRange = NSRange(folderName.startIndex..., in: folderName)
        let matches = regex.matches(in: folderName, range: fullRange)

        guard let match = matches.last,
              let seasonRange = Range(match.range(at: 1), in: folderName),
              let tokenRange = Range(match.range(at: 0), in: folderName),
              let season = Int(folderName[seasonRange]) else {
            customShowName = folderName
            customSuffix = ""
            return
        }

        customShowName = String(folderName[..<tokenRange.lowerBound])
        outputPrefix = String(format: "S%02dE", season)
        customSuffix = String(folderName[tokenRange.upperBound...])
    }
    
    private func scanAndMatchFiles(in folderURL: URL) {
        jobs.removeAll()
        selectedJobID = nil
        // MediaInfo 与截图默认写回输入文件夹。
        mediaInfoDirectory = folderURL
        screenshotDirectory = folderURL
        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) else { return }
        
        var videoFiles: [String: URL] = [:]
        var subFiles: [String: URL] = [:]
        
        for file in files {
            let ext = file.pathExtension.lowercased()
            let baseName = file.deletingPathExtension().lastPathComponent
            
            if ["mkv", "m2ts", "mp4"].contains(ext) {
                videoFiles[baseName] = file
            } else if ["srt", "ass"].contains(ext) {
                subFiles[baseName] = file
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            var tempJobs: [MuxJob] = []
            
            for (baseName, videoURL) in videoFiles {
                if let subURL = subFiles[baseName] {
                    var job = MuxJob(
                        baseName: baseName,
                        videoURL: videoURL,
                        subtitleURL: subURL,
                        externalSubtitleTrack: MediaTrack(trackID: 0, type: "subtitles", codec: "外挂字幕", language: "chi", isExternal: true)
                    )
                    job.internalTracks = self.identifyTracks(in: videoURL)
                    tempJobs.append(job)
                }
            }
            
            tempJobs.sort { $0.baseName < $1.baseName }
            DispatchQueue.main.async {
                self.jobs = tempJobs
                self.selectedJobID = self.jobs.first?.id
            }
        }
    }
    
    private func identifyTracks(in fileURL: URL) -> [MediaTrack] {
        let process = Process()
        let pipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: mkvmergePath)
        process.arguments = ["-J", fileURL.path]
        process.standardOutput = pipe
        
        do {
            try process.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()
            
            if data.isEmpty { return [] }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let tracks = json["tracks"] as? [[String: Any]] else { return [] }
            
            var result: [MediaTrack] = []
            for t in tracks {
                guard let type = t["type"] as? String else { continue }
                let id: Int
                if let idInt = t["id"] as? Int { id = idInt }
                else if let idNum = t["id"] as? NSNumber { id = idNum.intValue }
                else { continue }
                
                let props = t["properties"] as? [String: Any] ?? [:]
                let lang = (props["language"] as? String) ?? "und"
                let codec = (props["codec_id"] as? String) ?? (props["codec"] as? String) ?? "未知编码"
                
                result.append(MediaTrack(trackID: id, type: type, codec: codec, language: lang, isExternal: false))
            }
            return result
        } catch {
            return []
        }
    }
    
    func setLanguage(_ language: String, for track: MediaTrack, in sourceJobID: UUID) {
        guard let sourceJobIndex = jobs.firstIndex(where: { $0.id == sourceJobID }) else { return }

        if track.isExternal {
            jobs[sourceJobIndex].externalSubtitleTrack.language = language
        } else if let trackIndex = jobs[sourceJobIndex].internalTracks.firstIndex(
            where: { $0.trackID == track.trackID }
        ) {
            jobs[sourceJobIndex].internalTracks[trackIndex].language = language
        }

        let sourceJob = jobs[sourceJobIndex]
        for jobIndex in jobs.indices where jobIndex != sourceJobIndex {
            for trackIndex in jobs[jobIndex].internalTracks.indices {
                let trackID = jobs[jobIndex].internalTracks[trackIndex].trackID
                if let sourceTrack = sourceJob.internalTracks.first(where: { $0.trackID == trackID }) {
                    jobs[jobIndex].internalTracks[trackIndex].language = sourceTrack.language
                }
            }
            jobs[jobIndex].externalSubtitleTrack.language = sourceJob.externalSubtitleTrack.language
        }
    }
    
    func startBatchMuxing() {
        guard !jobs.isEmpty else { return }
        isProcessing = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let requestedMediaInfoCount = max(0, self.mediaInfoCount)
            let requestedScreenshotCount = max(0, self.screenshotCount)
            let totalJobCount = self.jobs.count
            var generatedMediaInfoCount = 0
            var generatedScreenshotCount = 0

            for index in self.jobs.indices {
                DispatchQueue.main.async { self.jobs[index].status = "处理中..." }
                
                let job = self.jobs[index]
                let targetFolderURL = self.outputDirectory ?? job.videoURL.deletingLastPathComponent()
                let outputFileName = self.outputFileName(for: job)
                
                let outputURL = targetFolderURL.appendingPathComponent(outputFileName)
                let success = self.runMkvMerge(job: job, output: outputURL)

                guard success else {
                    DispatchQueue.main.async {
                        self.jobs[index].status = "❌ 封装失败"
                        self.jobs[index].outputURL = nil
                    }
                    continue
                }

                DispatchQueue.main.async {
                    self.jobs[index].outputURL = outputURL
                }

                var failures: [String] = []
                if generatedMediaInfoCount < requestedMediaInfoCount {
                    let nextMediaInfoNumber = generatedMediaInfoCount + 1
                    DispatchQueue.main.async {
                        self.jobs[index].status = "生成 MediaInfo \(nextMediaInfoNumber)/\(requestedMediaInfoCount)..."
                    }
                    do {
                        let url = try self.generateMediaInfo(
                            for: outputURL,
                            in: self.mediaInfoDirectory ?? targetFolderURL
                        )
                        generatedMediaInfoCount += 1
                        DispatchQueue.main.async {
                            self.jobs[index].mediaInfoURL = url
                        }
                    } catch {
                        failures.append("MediaInfo")
                    }
                }

                let remainingScreenshotCount = requestedScreenshotCount - generatedScreenshotCount
                let remainingJobCount = max(1, totalJobCount - index)
                let screenshotCountForCurrentJob = remainingScreenshotCount > 0
                    ? (remainingScreenshotCount + remainingJobCount - 1) / remainingJobCount
                    : 0

                if screenshotCountForCurrentJob > 0 {
                    let completedBeforeCurrentJob = generatedScreenshotCount
                    DispatchQueue.main.async {
                        self.jobs[index].status = "生成字幕截图 \(completedBeforeCurrentJob)/\(requestedScreenshotCount)..."
                    }
                    do {
                        let urls = try self.generateSubtitleScreenshots(
                            for: job,
                            outputURL: outputURL,
                            destinationDirectory: self.screenshotDirectory ?? targetFolderURL,
                            screenshotCount: screenshotCountForCurrentJob,
                            progress: { completedForCurrentJob in
                                DispatchQueue.main.async {
                                    self.jobs[index].status = "生成字幕截图 \(completedBeforeCurrentJob + completedForCurrentJob)/\(requestedScreenshotCount)..."
                                }
                            }
                        )
                        generatedScreenshotCount += urls.count
                        DispatchQueue.main.async {
                            self.jobs[index].screenshotURLs = urls
                        }
                    } catch {
                        failures.append("截图")
                    }
                }

                let finalStatus = failures.isEmpty
                    ? "✅ \(outputFileName)"
                    : "⚠️ 已封装，\(failures.joined(separator: "/"))失败"
                DispatchQueue.main.async {
                    self.jobs[index].status = finalStatus
                }
            }
            DispatchQueue.main.async { self.isProcessing = false }
        }
    }
    
    private func runMkvMerge(job: MuxJob, output: URL) -> Bool {
        var args = ["-o", output.path]
        for track in job.internalTracks {
            args.append("--language")
            args.append("\(track.trackID):\(track.language)")
            if track.type == "subtitles" {
                args.append("--default-track")
                args.append("\(track.trackID):no")
            }
        }
        args.append(job.videoURL.path)
        
        args.append("--language")
        args.append("0:\(job.externalSubtitleTrack.language)")
        args.append("--default-track")
        args.append("0:yes")
        if let characterSet = detectSubtitleCharacterSet(at: job.subtitleURL) {
            args.append("--sub-charset")
            args.append("0:\(characterSet)")
        }
        args.append(job.subtitleURL.path)
        
        do {
            let result = try runCommand(executablePath: mkvmergePath, arguments: args)
            // mkvmerge: 0 = 成功，1 = 成功但有警告，2 = 失败。
            return result.status < 2
        } catch {
            return false
        }
    }

    private func detectSubtitleCharacterSet(at fileURL: URL) -> String? {
        guard let data = try? Data(contentsOf: fileURL), !data.isEmpty else { return nil }

        // UTF-8 是 mkvmerge 的默认值，无需额外参数。
        if String(data: data, encoding: .utf8) != nil { return nil }

        var convertedString: NSString?
        var usedLossyConversion = ObjCBool(false)
        let encoding = NSString.stringEncoding(
            for: data,
            encodingOptions: nil,
            convertedString: &convertedString,
            usedLossyConversion: &usedLossyConversion
        )

        guard convertedString != nil, !usedLossyConversion.boolValue else { return nil }
        let cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding)
        guard cfEncoding != kCFStringEncodingInvalidId,
              let characterSetName = CFStringConvertEncodingToIANACharSetName(cfEncoding) else {
            return nil
        }

        return characterSetName as String
    }

    private func generateMediaInfo(for outputURL: URL, in destinationDirectory: URL) throws -> URL {
        guard let mediaInfoPath else {
            throw PostProcessingError.toolUnavailable("MediaInfo")
        }

        try FileManager.default.createDirectory(
            at: destinationDirectory,
            withIntermediateDirectories: true
        )

        let result = try runCommand(executablePath: mediaInfoPath, arguments: [outputURL.path])
        guard result.status == 0 else {
            throw PostProcessingError.commandFailed(
                "MediaInfo 生成失败：\(result.text.trimmingCharacters(in: .whitespacesAndNewlines))"
            )
        }
        guard !result.data.isEmpty else {
            throw PostProcessingError.invalidOutput("MediaInfo 未返回任何内容")
        }

        let stem = outputURL.deletingPathExtension().lastPathComponent
        let destinationURL = destinationDirectory.appendingPathComponent("\(stem).MediaInfo.txt")
        try result.data.write(to: destinationURL, options: .atomic)
        return destinationURL
    }

    private func generateSubtitleScreenshots(
        for job: MuxJob,
        outputURL: URL,
        destinationDirectory: URL,
        screenshotCount: Int,
        progress: (Int) -> Void
    ) throws -> [URL] {
        guard let ffmpegPath else {
            throw PostProcessingError.toolUnavailable("ffmpeg")
        }

        let subtitleTracks = job.internalTracks.filter { $0.type == "subtitles" } + [job.externalSubtitleTrack]
        guard let selectedIndex = subtitleTracks.lastIndex(where: { isChineseLanguage($0.language) })
                ?? subtitleTracks.indices.last else {
            throw PostProcessingError.invalidOutput("封装文件中没有可用于截图的字幕轨")
        }

        try FileManager.default.createDirectory(
            at: destinationDirectory,
            withIntermediateDirectories: true
        )

        let temporaryDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("mkv-package-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: temporaryDirectory) }

        let cueTimes = subtitleCueTimes(
            outputURL: outputURL,
            subtitleIndex: selectedIndex,
            count: screenshotCount
        )
        let extractedSubtitleURL = temporaryDirectory.appendingPathComponent("selected.ass")
        let hasTextSubtitle = extractTextSubtitle(
            outputURL: outputURL,
            subtitleIndex: selectedIndex,
            destinationURL: extractedSubtitleURL,
            ffmpegPath: ffmpegPath
        )

        let stem = outputURL.deletingPathExtension().lastPathComponent
        var screenshotURLs: [URL] = []

        for (offset, cueTime) in cueTimes.enumerated() {
            let destinationURL = destinationDirectory.appendingPathComponent(
                String(format: "%@.%02d.png", stem, offset + 1)
            )
            let result: (status: Int32, data: Data, text: String)

            if hasTextSubtitle {
                let escapedOutputPath = escapeFFmpegFilterValue(outputURL.path)
                var subtitleFilter = "subtitles=filename='\(escapedOutputPath)':si=\(selectedIndex)"
                if isChineseLanguage(subtitleTracks[selectedIndex].language) {
                    subtitleFilter += ":force_style='FontName=Hiragino Sans GB'"
                }
                result = try runCommand(
                    executablePath: ffmpegPath,
                    arguments: [
                        "-y", "-v", "error",
                        "-ss", String(format: "%.3f", cueTime),
                        "-copyts", "-i", outputURL.path,
                        "-map", "0:v:0",
                        "-vf", subtitleFilter,
                        "-frames:v", "1", "-an", "-sn",
                        destinationURL.path
                    ]
                )
            } else {
                result = try runCommand(
                    executablePath: ffmpegPath,
                    arguments: [
                        "-y", "-v", "error",
                        "-ss", String(format: "%.3f", cueTime),
                        "-copyts", "-i", outputURL.path,
                        "-filter_complex", "[0:v:0][0:s:\(selectedIndex)]overlay=eof_action=pass",
                        "-frames:v", "1", "-an",
                        destinationURL.path
                    ]
                )
            }

            guard result.status == 0,
                  FileManager.default.fileExists(atPath: destinationURL.path),
                  let attributes = try? FileManager.default.attributesOfItem(atPath: destinationURL.path),
                  (attributes[.size] as? NSNumber)?.intValue ?? 0 > 0 else {
                try? FileManager.default.removeItem(at: destinationURL)
                for screenshotURL in screenshotURLs {
                    try? FileManager.default.removeItem(at: screenshotURL)
                }
                let detail = result.text.trimmingCharacters(in: .whitespacesAndNewlines)
                throw PostProcessingError.commandFailed(
                    detail.isEmpty ? "第 \(offset + 1) 张字幕截图生成失败" : detail
                )
            }

            screenshotURLs.append(destinationURL)
            progress(offset + 1)
        }

        return screenshotURLs
    }

    private func subtitleCueTimes(outputURL: URL, subtitleIndex: Int, count: Int) -> [Double] {
        let count = max(0, count)
        guard count > 0 else { return [] }
        guard let ffprobePath,
              let result = try? runCommand(
                executablePath: ffprobePath,
                arguments: [
                    "-v", "error",
                    "-select_streams", "s:\(subtitleIndex)",
                    "-show_packets",
                    "-show_entries", "packet=pts_time,duration_time",
                    "-of", "json",
                    outputURL.path
                ]
              ),
              result.status == 0,
              let json = try? JSONSerialization.jsonObject(with: result.data) as? [String: Any],
              let packets = json["packets"] as? [[String: Any]] else {
            return fallbackScreenshotTimes(for: outputURL, count: count)
        }

        let cues: [Double] = packets.compactMap { packet in
            guard let startText = packet["pts_time"] as? String,
                  let start = Double(startText),
                  start >= 0 else { return nil }
            let duration = (packet["duration_time"] as? String).flatMap(Double.init) ?? 0.2
            return start + min(max(duration / 2, 0.05), 2.0)
        }.sorted()

        guard !cues.isEmpty else { return fallbackScreenshotTimes(for: outputURL, count: count) }

        return (0..<count).map { offset in
            let position = Double(offset + 1) / Double(count + 1)
            let index = min(cues.count - 1, Int(Double(cues.count) * position))
            return cues[index]
        }
    }

    private func fallbackScreenshotTimes(for outputURL: URL, count: Int = 3) -> [Double] {
        let duration = mediaDuration(for: outputURL) ?? 240
        guard count > 0 else { return [] }
        return (0..<count).map { offset in
            let position = Double(offset + 1) / Double(count + 1)
            return max(duration * position, 0)
        }
    }

    private func mediaDuration(for outputURL: URL) -> Double? {
        guard let mediaInfoPath,
              let result = try? runCommand(
                executablePath: mediaInfoPath,
                arguments: ["--Inform=General;%Duration%", outputURL.path]
              ),
              result.status == 0,
              let milliseconds = Double(result.text.trimmingCharacters(in: .whitespacesAndNewlines)),
              milliseconds > 0 else { return nil }
        return milliseconds / 1000
    }

    private func extractTextSubtitle(
        outputURL: URL,
        subtitleIndex: Int,
        destinationURL: URL,
        ffmpegPath: String
    ) -> Bool {
        guard let result = try? runCommand(
            executablePath: ffmpegPath,
            arguments: [
                "-y", "-v", "error",
                "-i", outputURL.path,
                "-map", "0:s:\(subtitleIndex)",
                "-c:s", "ass",
                destinationURL.path
            ]
        ), result.status == 0,
           let attributes = try? FileManager.default.attributesOfItem(atPath: destinationURL.path),
           (attributes[.size] as? NSNumber)?.intValue ?? 0 > 0 else {
            return false
        }
        return true
    }

    private func isChineseLanguage(_ language: String) -> Bool {
        let normalized = language.lowercased().split(separator: "-").first.map(String.init) ?? language.lowercased()
        return ["chi", "zho", "zh", "cmn", "yue"].contains(normalized)
    }

    private func escapeFFmpegFilterValue(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: ":", with: "\\:")
            .replacingOccurrences(of: ",", with: "\\,")
            .replacingOccurrences(of: "[", with: "\\[")
            .replacingOccurrences(of: "]", with: "\\]")
            .replacingOccurrences(of: ";", with: "\\;")
    }

    private func runCommand(
        executablePath: String,
        arguments: [String]
    ) throws -> (status: Int32, data: Data, text: String) {
        let process = Process()
        let outputPipe = Pipe()
        process.executableURL = URL(fileURLWithPath: executablePath)
        process.arguments = arguments
        process.standardOutput = outputPipe
        process.standardError = outputPipe

        if ["ffmpeg", "ffprobe"].contains(URL(fileURLWithPath: executablePath).lastPathComponent),
           let resourceURL = Bundle.main.resourceURL {
            let fontConfigDirectory = resourceURL
                .appendingPathComponent("ffmpeg_portable/fontconfig", isDirectory: true)
            let fontConfigFile = fontConfigDirectory.appendingPathComponent("fonts.conf")
            if FileManager.default.fileExists(atPath: fontConfigFile.path) {
                var environment = ProcessInfo.processInfo.environment
                environment["FONTCONFIG_PATH"] = fontConfigDirectory.path
                environment["FONTCONFIG_FILE"] = fontConfigFile.path
                process.environment = environment
            }
        }

        try process.run()
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        return (
            process.terminationStatus,
            data,
            String(data: data, encoding: .utf8) ?? ""
        )
    }

    private func outputFileName(for job: MuxJob) -> String {
        let episodeNum = extractEpisodeNumber(from: job.baseName)
        if episodeNum.isEmpty {
            return "\(customShowName)\(outputPrefix)_\(job.baseName)\(customSuffix).mkv"
        }

        return "\(customShowName)\(outputPrefix)\(episodeNum)\(customSuffix).mkv"
    }

    private func extractEpisodeNumber(from filename: String) -> String {
        let patterns = [
            "^\\s*(\\d+(?:\\.\\d+)?)\\s*$",
            "(?i)(?:ep|e)\\s*(\\d+(?:\\.\\d+)?)",
            "第\\s*(\\d+(?:\\.\\d+)?)\\s*[集话話]",
            "-\\s*(\\d+(?:\\.\\d+)?)(?!\\d)"
        ]

        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: filename, range: NSRange(filename.startIndex..., in: filename)),
               match.numberOfRanges > 1,
               let range = Range(match.range(at: 1), in: filename),
               let formatted = formatEpisodeNumber(String(filename[range])) {
                return formatted
            }
        }

        let fallbackPattern = "\\d+(?:\\.\\d+)?"
        if let regex = try? NSRegularExpression(pattern: fallbackPattern) {
            let matches = regex.matches(in: filename, range: NSRange(filename.startIndex..., in: filename))
            let ignoreList = ["1080", "720", "2160", "264", "265", "2020", "2021", "2022", "2023", "2024", "120", "5.1", "7.1", "2.0", "2.1"]

            for match in matches {
                if let range = Range(match.range, in: filename) {
                    let numStr = String(filename[range])
                    if !ignoreList.contains(numStr),
                       !isTechnicalNumber(numStr, endingAt: range.upperBound, in: filename),
                       let formatted = formatEpisodeNumber(numStr) {
                        return formatted
                    }
                }
            }
        }
        return ""
    }

    private func formatEpisodeNumber(_ value: String) -> String? {
        guard let number = Double(value) else { return nil }
        return number.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%02d", Int(number))
            : value
    }

    private func isTechnicalNumber(_ value: String, endingAt endIndex: String.Index, in filename: String) -> Bool {
        let trailingText = filename[endIndex...]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if value == "10" && trailingText.hasPrefix("bit") { return true }
        if value == "120" && trailingText.hasPrefix("fps") { return true }
        return false
    }
    
    func translateType(_ type: String) -> String {
        switch type {
        case "video": return "视频 🎬"
        case "audio": return "音频 🎵"
        case "subtitles": return "字幕 💬"
        default: return type
        }
    }
}

// MARK: - 新增组件：更多语言搜索窗口 (Sheet)
struct LanguageSearchSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCode: String
    @State private var searchText = ""
    
    var filteredLanguages: [LanguageInfo] {
        if searchText.isEmpty {
            return LanguageDB.allLanguages
        } else {
            return LanguageDB.allLanguages.filter {
                $0.name.contains(searchText) ||
                $0.code.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("查找更多语言")
                .font(.headline)
                .padding()
            
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("搜索语言 (如: 冰岛, is, 泰语...)", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .padding(8)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            List(filteredLanguages) { lang in
                Button(action: {
                    selectedCode = lang.code
                    dismiss()
                }) {
                    HStack {
                        Text(lang.name).foregroundColor(.primary)
                        Spacer()
                        Text(lang.code).foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 4)
            }
            
            Button("取消") {
                dismiss()
            }
            .padding()
        }
        .frame(width: 320, height: 450)
    }
}

// MARK: - 新增组件：智能单行轨道视图
struct TrackRowView: View {
    @Binding var track: MediaTrack
    let typeLabel: String
    let codecLabel: String
    
    @State private var showSearchSheet = false
    
    var body: some View {
        HStack {
            Text("ID \(track.trackID):")
                .frame(width: 40, alignment: .leading)
            Text(typeLabel)
                .frame(width: 80, alignment: .leading)
            Text(codecLabel)
                .foregroundColor(.gray)
                .lineLimit(1)
                .frame(width: 100, alignment: .leading)
            
            let pickerBinding = Binding<String>(
                get: { track.language },
                set: { newValue in
                    if newValue == "more_languages_trigger" {
                        showSearchSheet = true
                    } else {
                        track.language = newValue
                    }
                }
            )
            
            Picker("", selection: pickerBinding) {
                ForEach(LanguageDB.commonLanguages) { lang in
                    Text("\(lang.name) (\(lang.code))").tag(lang.code)
                }
                
                Divider()
                Text("更多语言...").tag("more_languages_trigger")
                
                if !LanguageDB.commonLanguages.contains(where: { $0.code == track.language }) {
                    Divider()
                    Text("\(LanguageDB.getName(for: track.language)) (\(track.language))").tag(track.language)
                }
            }
            .frame(maxWidth: 150)
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showSearchSheet) {
            LanguageSearchSheet(selectedCode: $track.language)
        }
    }
}

// MARK: - 主界面 UI
struct ContentView: View {
    @StateObject private var viewModel = MuxerViewModel()

    private var backgroundImage: NSImage? {
        guard let url = viewModel.backgroundImageURL else { return nil }
        return NSImage(contentsOf: url)
    }

    private func trackBinding(for track: MediaTrack, in jobID: UUID) -> Binding<MediaTrack> {
        Binding(
            get: {
                guard let job = viewModel.jobs.first(where: { $0.id == jobID }) else {
                    return track
                }
                if track.isExternal {
                    return job.externalSubtitleTrack
                }
                return job.internalTracks.first(where: { $0.trackID == track.trackID }) ?? track
            },
            set: { updatedTrack in
                viewModel.setLanguage(updatedTrack.language, for: track, in: jobID)
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 顶部工具栏
            VStack(spacing: 12) {
                HStack {
                    Button("选择输入文件夹") { viewModel.selectFolder() }
                        .frame(width: 120)
                    
                    Button("选择保存目录") { viewModel.selectOutputDirectory() }
                        .frame(width: 120)
                    
                    Text(viewModel.outputDirectory?.path ?? "保存路径：默认与源文件同目录")
                        .foregroundColor(viewModel.outputDirectory == nil ? .gray : .primary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    
                    Spacer()
                }

                HStack(spacing: 12) {
                    Button("MediaInfo 目录") { viewModel.selectMediaInfoDirectory() }
                        .frame(width: 120)

                    Text(viewModel.mediaInfoDirectory?.path ?? "MediaInfo：选择输入文件夹后使用该目录")
                        .foregroundColor(viewModel.mediaInfoDirectory == nil ? .gray : .primary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button("截图目录") { viewModel.selectScreenshotDirectory() }
                        .frame(width: 100)

                    Text(viewModel.screenshotDirectory?.path ?? "截图：选择输入文件夹后使用该目录")
                        .foregroundColor(viewModel.screenshotDirectory == nil ? .gray : .primary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: 18) {
                    Stepper("MediaInfo 获取个数：\(viewModel.mediaInfoCount)", value: $viewModel.mediaInfoCount, in: 1...999)
                        .fixedSize()
                    Stepper("截图张数：\(viewModel.screenshotCount)", value: $viewModel.screenshotCount, in: 1...99)
                        .fixedSize()

                    Divider().frame(height: 20)

                    Button("设定背景图片") { viewModel.selectBackgroundImage() }
                    if viewModel.backgroundImageURL != nil {
                        Button("清除背景") { viewModel.backgroundImageURL = nil }
                    }
                    Text("透明度")
                    Slider(value: $viewModel.backgroundOpacity, in: 0...1)
                        .frame(width: 130)
                    Text("\(Int(viewModel.backgroundOpacity * 100))%")
                        .monospacedDigit()
                        .frame(width: 36, alignment: .trailing)
                    Spacer()
                }
                
                HStack {
                    Text("主体名:")
                    TextField("如: 权力的游戏.", text: $viewModel.customShowName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 110)
                    
                    Text("季数:")
                    TextField("S01E", text: $viewModel.outputPrefix)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 50)
                    
                    Text("后缀:")
                    TextField("如: .1080p.x265", text: $viewModel.customSuffix)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                    
                    Spacer()
                    
                    HStack {
                        Text("预览: ")
                            .foregroundColor(.gray)
                        // 动态读取选中的文件进行预览展示
                        Text(viewModel.previewFileName)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                }
            }
            .padding()
            .background(Color.clear)
            
            Divider()
            
            // MARK: - 主体分栏视图
            HStack(spacing: 0) {
                // 左侧：文件列表
                VStack(alignment: .leading, spacing: 0) {
                    Text("待封装文件 (\(viewModel.jobs.count))")
                        .font(.headline)
                        .padding()
                    
                    List(selection: $viewModel.selectedJobID) {
                        ForEach(viewModel.jobs) { job in
                            HStack {
                                Text(job.baseName).lineLimit(1).truncationMode(.middle)
                                Spacer()
                                if job.status != "等待中" {
                                    Text(job.status)
                                        .font(.caption)
                                        .foregroundColor(
                                            job.status.contains("✅") ? .green
                                                : job.status.contains("⚠️") ? .orange
                                                : job.status.contains("❌") ? .red
                                                : .secondary
                                        )
                                        .lineLimit(1)
                                }
                            }
                            .tag(job.id)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                .frame(minWidth: 280, maxWidth: .infinity)
                
                Divider()
                
                // 右侧：轨道编辑器
                VStack(alignment: .leading, spacing: 0) {
                    Text("轨道语言设定")
                        .font(.headline)
                        .padding()
                    
                    if let selectedJobIndex = viewModel.jobs.firstIndex(where: { $0.id == viewModel.selectedJobID }) {
                        Form {
                            Section(header: Text("内部轨道 (源视频文件)").bold().padding(.top)) {
                                if viewModel.jobs[selectedJobIndex].internalTracks.isEmpty {
                                    Text("未检测到内部轨道，或正在解析中...")
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 8)
                                } else {
                                    ForEach(viewModel.jobs[selectedJobIndex].internalTracks) { track in
                                        TrackRowView(
                                            track: trackBinding(
                                                for: track,
                                                in: viewModel.jobs[selectedJobIndex].id
                                            ),
                                            typeLabel: viewModel.translateType(track.type),
                                            codecLabel: track.codec
                                        )
                                    }
                                }
                            }
                            
                            Divider().padding(.vertical)
                            
                            Section(header: Text("外部轨道 (源字幕文件)").bold()) {
                                TrackRowView(
                                    track: trackBinding(
                                        for: viewModel.jobs[selectedJobIndex].externalSubtitleTrack,
                                        in: viewModel.jobs[selectedJobIndex].id
                                    ),
                                    typeLabel: "外挂字幕 💬",
                                    codecLabel: "srt/ass"
                                )
                            }
                        }
                        .padding(.horizontal)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    } else {
                        VStack {
                            Spacer()
                            Text("请在左侧选择一个文件查看其轨道信息")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    Spacer()
                }
                .frame(minWidth: 280, maxWidth: .infinity)
            }
            
            Divider()
            
            // MARK: - 底部操作按钮
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.startBatchMuxing()
                    }) {
                        Text(viewModel.isProcessing ? "正在封装..." : "开始批量封装 (\(viewModel.jobs.count) 个文件)")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(width: geometry.size.width / 4)
                    .disabled(viewModel.jobs.isEmpty || viewModel.isProcessing)
                    Spacer()
                }
            }
            .frame(height: 38)
            .padding()
            .background(Color.clear)
        }
        .frame(minWidth: 900, minHeight: 600)
        .background {
            GeometryReader { geometry in
                ZStack {
                    Color(NSColor.windowBackgroundColor)

                    if let backgroundImage {
                        Image(nsImage: backgroundImage)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                            .clipped()
                            .opacity(viewModel.backgroundOpacity)
                    }
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .clipped()
                .allowsHitTesting(false)
            }
        }
    }
}
