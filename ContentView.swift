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
                        Text("\(viewModel.customShowName)\(viewModel.outputPrefix)08\(viewModel.customSuffix).mkv")
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
                    // 👉 这里就是你刚才要求修改的地方
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
