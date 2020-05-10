# cocoapods-x

    扩展pod x命令, 实现快速清理缓存, 快速打开Xcode等操作, 使用souce, pods两个dsl实现快速切换pod 'NAME', :path=>'url'开发模式, 对壳工程无入侵.

## Installation

    $ gem install cocoapods-x

## Usage

    alias pox="pod x"
    pox env install # 拉取必要的模版文件在~/.cocoapods/x中, 用于包括lib模版 pods模版 source模版
    pox env update # 更新到最新的模版文件
    pox env init # 在拥有Podfile的项目中初始化构建环境, 映射的工程目录在~/.cocoapods/x/projects/{name}中
    pox lib create NAME # 创建项目脚手架
    pox lib build # 尚未开发完成
    pox xc clean # 清理 Pods Podfile.lock 和 DerivedData 
    pox xc open # 打开Xcode, 优先打开当前目录的 *.xcworkspace

    例: 在项目Demo中, 将AFNetworking切换到Development Pods开发模式
    (Demo) $ pox env init
    (Demo) $ pox edit --pods # 编辑pods文件
    在pods文件中添加
    pod 'AFNetworking'
    (Demo) $ pox edit --source # 编辑source文件
    在source文件中添加
    source 'https://github.com' do # source 'git@github.com' do
        pod 'AFNetworking'
    end
    (Demo) $ pod install
    完成AFNetworking开发模式切换, AFNetworking将被存放在Demo映射项目下的repos中.
    通过命令快速打开AFNetworking所在目录
    (Demo) $ pox repos AFNetworking

    pods 文件用于声明需要切换Development Pods的pod, 不同的项目拥有各自的pods文件, 项目隔离.
    source 文件用于声明pod对应git源地址, 全局公用一份.