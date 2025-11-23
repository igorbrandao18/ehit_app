import Flutter
import UIKit
import AVFoundation
import MediaPlayer

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var nowPlayingChannel: FlutterMethodChannel?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configurar AVAudioSession para permitir reprodução em background
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Erro ao configurar AVAudioSession: \(error)")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Configurar comandos de mídia remota após o registro dos plugins
    DispatchQueue.main.async { [weak self] in
      self?.setupRemoteCommandCenter()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func setupRemoteCommandCenter() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      print("⚠️ FlutterViewController não disponível")
      return
    }
    
    nowPlayingChannel = FlutterMethodChannel(
      name: "com.ehitapp/now_playing",
      binaryMessenger: controller.binaryMessenger
    )
    let commandCenter = MPRemoteCommandCenter.shared()
    
    commandCenter.playCommand.addTarget { [weak self] _ in
      self?.nowPlayingChannel?.invokeMethod("play", arguments: nil)
      return .success
    }
    
    commandCenter.pauseCommand.addTarget { [weak self] _ in
      self?.nowPlayingChannel?.invokeMethod("pause", arguments: nil)
      return .success
    }
    
    commandCenter.nextTrackCommand.addTarget { [weak self] _ in
      self?.nowPlayingChannel?.invokeMethod("next", arguments: nil)
      return .success
    }
    
    commandCenter.previousTrackCommand.addTarget { [weak self] _ in
      self?.nowPlayingChannel?.invokeMethod("previous", arguments: nil)
      return .success
    }
    
    commandCenter.playCommand.isEnabled = true
    commandCenter.pauseCommand.isEnabled = true
    commandCenter.nextTrackCommand.isEnabled = true
    commandCenter.previousTrackCommand.isEnabled = true
    
    // Configurar handler para atualizar MPNowPlayingInfoCenter
    nowPlayingChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "updateNowPlaying" {
        self?.updateNowPlayingInfo(call: call, result: result)
      } else if call.method == "clearNowPlaying" {
        self?.clearNowPlayingInfo(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  func updateNowPlayingInfo(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let title = args["title"] as? String,
          let artist = args["artist"] as? String else {
      result(FlutterError(code: "INVALID_ARGS", message: "Argumentos inválidos", details: nil))
      return
    }
    
    let album = args["album"] as? String ?? ""
    let artworkUrl = args["artworkUrl"] as? String
    let isPlaying = args["isPlaying"] as? Bool ?? false
    let position = args["position"] as? Int ?? 0
    let duration = args["duration"] as? Int ?? 0
    
    var nowPlayingInfo = [String: Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = title
    nowPlayingInfo[MPMediaItemPropertyArtist] = artist
    nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double(position) / 1000.0
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Double(duration) / 1000.0
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
    
    // Definir informações básicas primeiro
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    
    // Carregar artwork de forma assíncrona se disponível
    if let artworkUrl = artworkUrl, !artworkUrl.isEmpty, let url = URL(string: artworkUrl) {
      URLSession.shared.dataTask(with: url) { data, _, _ in
        if let data = data, let image = UIImage(data: data) {
          let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
          var updatedInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
          updatedInfo[MPMediaItemPropertyArtwork] = artwork
          MPNowPlayingInfoCenter.default().nowPlayingInfo = updatedInfo
        }
      }.resume()
    }
    
    result(nil)
  }
  
  func clearNowPlayingInfo(result: @escaping FlutterResult) {
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    result(nil)
  }
}
