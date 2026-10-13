import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

class AgoraService {
  RtcEngine? engine;

  Future<void> initAgora(String appId) async {
    engine = createAgoraRtcEngine();
    await engine!.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
    await engine!.enableVideo();
    await engine!.startPreview();
  }

  Future<void> joinChannel({
    required String token,
    required String channelId,
    required int uid,
  }) async {
    await engine?.joinChannel(
      token: token,
      channelId: channelId,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
      uid: uid,
    );
  }

  Future<void> leaveChannel() async {
    await engine?.leaveChannel();
    await engine?.release();
  }

  Future<void> setBeautyEffect({
    required bool enabled,
    double lighteningLevel = 0.7,
    double smoothnessLevel = 0.6,
    double rednessLevel = 0.1,
    double sharpnessLevel = 0.3,
  }) async {
    try {
      BeautyOptions beautyOptions = BeautyOptions(
        lighteningLevel: lighteningLevel,
        smoothnessLevel: smoothnessLevel,
        rednessLevel: rednessLevel,
        sharpnessLevel: sharpnessLevel,
      );

      await engine?.setBeautyEffectOptions(
        enabled: enabled,
        options: beautyOptions,
      );

      debugPrint('Filtro de belleza actualizado (Enabled: $enabled)');
    } catch (e) {
      debugPrint('Error al configurar el filtro de belleza: $e');
    }
  }
}
