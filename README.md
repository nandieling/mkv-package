# MKV Package（批量封装刮削工具）

面向 PT 用户和 Emby、Plex、Jellyfin 媒体库用户的 macOS 原生批量 MKV 封装工具。它可以自动匹配视频与外挂字幕、整理轨道语言，并按 `S01E01` 格式批量命名；整个过程无需手动编写 `mkvmerge` 命令。

## 核心功能

- **智能匹配**：扫描同一目录下同名的视频和字幕，支持 `mkv`、`m2ts`、`mp4` 视频以及 `srt`、`ass` 字幕。
- **集数提取与刮削命名**：可从 `EP08`、`E08`、`第 8 集`、`- 08` 等文件名中提取集数，支持小数集，并自动避开常见的分辨率、编码和帧率数字。
- **自定义命名**：支持“主体名 + 季集前缀 + 后缀”，实时预览输出文件名；选择保存目录时可根据目录名自动填充季数等字段。
- **轨道语言编辑**：使用 `mkvmerge` 读取视频、音频和字幕轨道，可搜索并设置 ISO 639 语言代码。修改任意一集的语言后，会按轨道 ID 自动同步到整批任务，外挂字幕语言也会同步。
- **自动 MediaInfo**：批量封装过程中自动生成 `影片名.MediaInfo.txt`。可设置整批获取个数和独立保存目录，默认生成 1 份并保存到输入目录。
- **自动字幕截图**：使用 FFmpeg/ffprobe 在字幕出现的时间点生成原始分辨率 PNG，可设置整批截图总数和独立保存目录，默认生成 3 张并分配到批量任务中。优先选择最后一条中文轨，没有中文轨时使用最后一条字幕轨，同时支持文本字幕和图形字幕。
- **自定义界面背景**：可选择本地图片作为背景，支持实时调整透明度或一键清除；背景与透明度设置会在下次启动时自动恢复。
- **便携运行**：发布版 App 内置 `mkvmerge`、MediaInfo、FFmpeg、ffprobe 及所需动态库，无需另外安装 Homebrew、MKVToolNix、MediaInfo 或 FFmpeg。

## 本次更新

### 新增

- MediaInfo 改为随批量封装自动生成，并支持设置整批生成数量与单独的保存目录。
- 新增自动字幕截图，按字幕时间点取帧并烧录所选字幕；截图文件按 `影片名.01.png`、`影片名.02.png` 格式保存。
- 新增 FFmpeg、ffprobe 和字体配置的便携打包支持。
- 新增自定义背景图片和透明度控制。
- 轨道语言改为编辑后自动同步到其他任务，无需再点击“应用到所有”。

### 修复与优化

- 封装失败与后处理失败现在分别显示：MKV 已成功生成但 MediaInfo 或截图失败时，会保留输出并显示警告状态。
- 优化截图轨道选择和时间点计算；无法读取字幕时间点时，会根据影片时长均匀取帧。
- 截图中优先使用中文字体配置，并兼容文本字幕与图形字幕。
- 调整文件列表与轨道面板的自适应宽度，改善窗口缩放和背景图片下的可读性。
- 修复退出 App 后背景图片和透明度设置丢失的问题。
- 修复打包脚本对 Homebrew 符号链接及递归动态库依赖的处理，并在产物生成前检查外部依赖、统一签名 App 内二进制。

## 软件截图

![](https://img3.pixhost.cc/images/5277/763235141_2026-08-28-08-53-05.png)

## 使用方法

1. 将视频与对应外挂字幕放在同一目录，并确保扩展名之前的文件名完全相同，例如 `01.mkv` 与 `01.ass`。
2. 点击“选择输入文件夹”。程序会扫描匹配文件、读取内部轨道，并默认把 MediaInfo 和截图目录设为输入目录。
3. 按需选择 MKV 保存目录、MediaInfo 目录和截图目录，设置命名字段及整批生成数量。
4. 在轨道列表中调整语言。每次修改会自动同步到其他匹配任务。
5. 点击“开始批量封装”。任务状态会分别反映封装、MediaInfo 和截图进度。

> “MediaInfo 获取个数”和“截图张数”均指本次批量任务的总数，不是每个视频各自生成的数量。

## 安装与运行

1. 从 [Releases](https://github.com/nandieling/mkv-package/releases) 下载最新版 `MKV Package.app`，并拖入“应用程序”文件夹。
2. 由于 App 未使用 Apple 开发者证书签名，首次运行若提示“文件已损坏”或“无法验证开发者”，请在终端执行：

```bash
sudo xattr -cr "/Applications/MKV Package.app"
```

当前发布版面向 Apple Silicon，最低支持 macOS 14。

## 从源码打包

打包需要 macOS 14 或更高版本及 Xcode Command Line Tools。仓库根目录还需包含：

- `01.png`
- `mkvmerge_portable/mkvmerge`
- `mediainfo_portable/mediainfo`
- `ffmpeg_portable/ffmpeg` 与 `ffmpeg_portable/ffprobe`，或构建机 `PATH` 中可用的 `ffmpeg` 与 `ffprobe`

执行：

```bash
./Scripts/package-mac-app.sh
```

打包完成后生成：

- `dist/MKV Package.app`
- `dist/MKV Package.zip`

脚本会递归收集非系统动态库、改写加载路径、检查是否仍引用 `/opt/homebrew` 或 `/usr/local`，然后对 App 内二进制进行临时签名。生成的 App 会内置 `mkvmerge`、MediaInfo、FFmpeg、ffprobe、可用的 Fontconfig 配置及相关动态库。

如需指定本地工具或资源，可在执行脚本前设置 `FFMPEG_SOURCE`、`FFPROBE_SOURCE`、`FONTCONFIG_SOURCE` 或 `SDL3_SOURCE`。产物架构跟随仓库内的 `mkvmerge`；当前随附版本为 Apple Silicon。
