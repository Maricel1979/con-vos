import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Instancia global del cliente de Supabase
final supabase = Supabase.instance.client;

class SupabaseService {
  // 1. Obtener el saldo real de tokens de un usuario
  static Future<int> getUserBalance(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select('token_balance')
          .eq('id', userId)
          .single();
      return response['token_balance'] as int;
    } catch (e) {
      debugPrint('Error al obtener saldo: $e');
      return 0;
    }
  }

  // 2. Registrar cuando una creadora inicia un vivo
  static Future<String?> startStream({
    required String creatorId,
    required bool isVip,
    required int entryPrice,
  }) async {
    try {
      final response = await supabase
          .from('streams')
          .insert({
            'creator_id': creatorId,
            'is_vip': isVip,
            'entry_price': entryPrice,
            'is_live': true,
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      debugPrint('Error al iniciar transmisión: $e');
      return null;
    }
  }

  // 3. Finalizar la transmisión
  static Future<void> stopStream(String streamId) async {
    try {
      await supabase.from('streams').update({
        'is_live': false,
        'ended_at': DateTime.now().toIso8601String(),
      }).eq('id', streamId);
    } catch (e) {
      debugPrint('Error al finalizar transmisión: $e');
    }
  }

  // 4. Escuchar en tiempo real las transmisiones activas
  static Stream<List<Map<String, dynamic>>> getLiveStreams() {
    return supabase
        .from('streams')
        .stream(primaryKey: ['id'])
        .eq('is_live', true);
  }
}