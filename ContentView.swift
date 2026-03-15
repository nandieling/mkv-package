import SwiftUI
import UniformTypeIdentifiers
import Foundation
import Combine

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
    
    var internalTracks: [MediaTrack] = []
    var externalSubtitleTrack: MediaTrack
}

// MARK: - 逻辑处理 ViewModel
class MuxerViewModel: ObservableObject {
    @Published var jobs: [MuxJob] = []
    @Published var selectedJobID: UUID?
    @Published var isProcessing = false
    
    // 命名与路径状态
    @Published var outputDirectory: URL? = nil
    @Published var customShowName: String = ""
    @Published var outputPrefix: String = "S01E"
    @Published var customSuffix: String = ""
    
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
    
    // 动态生成预览文件名
    var previewFileName: String {
        if let selectedID = selectedJobID, let job = jobs.first(where: { $0.id == selectedID }) {
            let episodeNum = extractEpisodeNumber(from: job.baseName)
            if episodeNum.isEmpty {
                return "\(customShowName)\(outputPrefix)_\(job.baseName)\(customSuffix).mkv"
            } else {
                return "\(customShowName)\(outputPrefix)\(episodeNum)\(customSuffix).mkv"
            }
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
            self.outputDirectory = panel.url
        }
    }
    
    private func scanAndMatchFiles(in folderURL: URL) {
        jobs.removeAll()
        selectedJobID = nil
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
    
    func applyCurrentSettingsToAll() {
        guard let selectedJobIndex = jobs.firstIndex(where: { $0.id == selectedJobID }) else { return }
        let sourceJob = jobs[selectedJobIndex]
        
        for i in 0..<jobs.count {
            if i == selectedJobIndex { continue }
            for j in 0..<jobs[i].internalTracks.count {
                let trackID = jobs[i].internalTracks[j].trackID
                if let sourceTrack = sourceJob.internalTracks.first(where: { $0.trackID == trackID }) {
                    jobs[i].internalTracks[j].language = sourceTrack.language
                }
            }
            jobs[i].externalSubtitleTrack.language = sourceJob.externalSubtitleTrack.language
        }
    }
    
    func startBatchMuxing() {
        guard !jobs.isEmpty else { return }
        isProcessing = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            for index in self.jobs.indices {
                DispatchQueue.main.async { self.jobs[index].status = "处理中..." }
                
                let job = self.jobs[index]
                let targetFolderURL = self.outputDirectory ?? job.videoURL.deletingLastPathComponent()
                
                let episodeNum = self.extractEpisodeNumber(from: job.baseName)
                
                let outputFileName: String
                if episodeNum.isEmpty {
                    outputFileName = "\(self.customShowName)\(self.outputPrefix)_\(job.baseName)\(self.customSuffix).mkv"
                } else {
                    outputFileName = "\(self.customShowName)\(self.outputPrefix)\(episodeNum)\(self.customSuffix).mkv"
                }
                
                let outputURL = targetFolderURL.appendingPathComponent(outputFileName)
                let success = self.runMkvMerge(job: job, output: outputURL)
                
                DispatchQueue.main.async {
                    self.jobs[index].status = success ? "✅ \(outputFileName)" : "❌ 失败"
                }
            }
            DispatchQueue.main.async { self.isProcessing = false }
        }
    }
    
    private func runMkvMerge(job: MuxJob, output: URL) -> Bool {
        let process = Process()
        let pipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: mkvmergePath)
        
        var args = ["-o", output.path]
        for track in job.internalTracks {
            args.append("--language")
            args.append("\(track.trackID):\(track.language)")
        }
        args.append(job.videoURL.path)
        
        args.append("--language")
        args.append("0:\(job.externalSubtitleTrack.language)")
        args.append(job.subtitleURL.path)
        
        process.arguments = args
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
    
    private func extractEpisodeNumber(from filename: String) -> String {
            // 1. 升级正则：支持识别小数集数 (如 11.5)，(?:\\.\\d+)? 代表可选的小数部分
            let patterns = [
                "(?i)(?:ep|e)\\s*(\\d+(?:\\.\\d+)?)",
                "第\\s*(\\d+(?:\\.\\d+)?)\\s*[集话話]",
                "-\\s*(\\d+(?:\\.\\d+)?)(?!\\d)"
            ]
            
            for pattern in patterns {
                if let regex = try? NSRegularExpression(pattern: pattern),
                   let match = regex.firstMatch(in: filename, range: NSRange(filename.startIndex..., in: filename)),
                   match.numberOfRanges > 1, let range = Range(match.range(at: 1), in: filename) {
                    let numStr = String(filename[range])
                    if let num = Double(numStr) {
                        // 如果是纯整数，补齐两位 (如 08)；如果是小数，原样返回 (如 11.5)
                        return num.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%02d", Int(num)) : numStr
                    }
                }
            }
            
            let fallbackPattern = "\\d+(?:\\.\\d+)?"
            if let regex = try? NSRegularExpression(pattern: fallbackPattern) {
                let matches = regex.matches(in: filename, range: NSRange(filename.startIndex..., in: filename))
                // 2. 增加防误伤机制：排除 5.1, 7.1, 2.0 等常见声道参数，防止被误认为集数
                let ignoreList = ["1080", "720", "2160", "264", "265", "2020", "2021", "2022", "2023", "2024", "10", "120", "5.1", "7.1", "2.0", "2.1"]
                
                for match in matches {
                    if let range = Range(match.range, in: filename) {
                        let numStr = String(filename[range])
                        if !ignoreList.contains(numStr), let num = Double(numStr) {
                            return num.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%02d", Int(num)) : numStr
                        }
                    }
                }
            }
            return ""
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
            .background(Color(NSColor.windowBackgroundColor))
            
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
                                        .foregroundColor(job.status.contains("✅") ? .green : .red)
                                        .lineLimit(1)
                                }
                            }
                            .tag(job.id)
                        }
                    }
                }
                .frame(minWidth: 280, maxWidth: 380)
                
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
                                    ForEach($viewModel.jobs[selectedJobIndex].internalTracks) { $track in
                                        TrackRowView(
                                            track: $track,
                                            typeLabel: viewModel.translateType(track.type),
                                            codecLabel: track.codec
                                        )
                                    }
                                }
                            }
                            
                            Divider().padding(.vertical)
                            
                            Section(header: Text("外部轨道 (源字幕文件)").bold()) {
                                TrackRowView(
                                    track: $viewModel.jobs[selectedJobIndex].externalSubtitleTrack,
                                    typeLabel: "外挂字幕 💬",
                                    codecLabel: "srt/ass"
                                )
                            }
                            
                            Button(action: {
                                viewModel.applyCurrentSettingsToAll()
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc")
                                    Text("将此语言组合应用到所有其他文件")
                                }
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal)
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
                .frame(minWidth: 500)
            }
            
            Divider()
            
            // MARK: - 底部运行按钮
            Button(action: {
                viewModel.startBatchMuxing()
            }) {
                Text(viewModel.isProcessing ? "正在封装..." : "开始批量封装 (\(viewModel.jobs.count) 个文件)")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.jobs.isEmpty || viewModel.isProcessing)
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(minWidth: 900, minHeight: 600)
    }
}
