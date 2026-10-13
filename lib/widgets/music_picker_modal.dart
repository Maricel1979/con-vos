import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';

class MusicPickerModal extends StatefulWidget {
  final Function(String title, String? filePath, String? streamUrl)
  onAudioSelected;

  const MusicPickerModal({Key? key, required this.onAudioSelected})
    : super(key: key);

  @override
  State<MusicPickerModal> createState() => _MusicPickerModalState();
}

class _MusicPickerModalState extends State<MusicPickerModal> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingUrl;
  bool _isPlaying = false;

  final List<Map<String, String>> _freeCatalog = [
    {
      'title': 'Lofi Chill Beat',
      'genre': 'Lofi / Hip Hop',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'title': 'Urban Trap Energy',
      'genre': 'Trap / Rap',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
    {
      'title': 'Acoustic Vibe',
      'genre': 'Acústico / Pop',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    },
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(String url) async {
    try {
      if (_currentlyPlayingUrl == url && _isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
        setState(() {
          _currentlyPlayingUrl = url;
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint('Error al reproducir audio: $e');
    }
  }

  Future<void> _pickLocalAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'aac'],
      );

      if (result != null && result.files.single.path != null) {
        String path = result.files.single.path!;
        String fileName = result.files.single.name;

        widget.onAudioSelected(fileName, path, null);
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error al seleccionar archivo local: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E2C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const TabBar(
              indicatorColor: Colors.pinkAccent,
              labelColor: Colors.pinkAccent,
              unselectedLabelColor: Colors.white60,
              tabs: [
                Tab(icon: Icon(Icons.folder), text: "Mi Dispositivo"),
                Tab(icon: Icon(Icons.library_music), text: "Catálogo Libre"),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.audiotrack,
                        size: 64,
                        color: Colors.pinkAccent,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Elegí una canción guardada en tu equipo',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _pickLocalAudio,
                        icon: const Icon(Icons.file_upload),
                        label: const Text('Explorar Archivos Localmente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    itemCount: _freeCatalog.length,
                    itemBuilder: (context, index) {
                      final track = _freeCatalog[index];
                      final isSelected =
                          _currentlyPlayingUrl == track['url'] && _isPlaying;

                      return ListTile(
                        leading: IconButton(
                          icon: Icon(
                            isSelected
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.pinkAccent,
                            size: 36,
                          ),
                          onPressed: () => _togglePlay(track['url']!),
                        ),
                        title: Text(
                          track['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          track['genre']!,
                          style: const TextStyle(color: Colors.white54),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            widget.onAudioSelected(
                              track['title']!,
                              null,
                              track['url'],
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text('Usar'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
