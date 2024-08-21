import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../repositories/education_repository.dart';

class EducationAudioScreen extends StatefulWidget {
  const EducationAudioScreen({super.key});

  @override
  _EducationAudioScreenState createState() => _EducationAudioScreenState();
}

class _EducationAudioScreenState extends State<EducationAudioScreen> with SingleTickerProviderStateMixin {
  final EducationRepository _educationRepository = EducationRepository();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlayingUrl;
  bool _isPlaying = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _playAudio(String url) async {
    if (_currentPlayingUrl == url && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
        _animationController.stop(); // Hentikan animasi saat audio berhenti
      });
    } else {
      if (_currentPlayingUrl != null) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _currentPlayingUrl = url;
        _isPlaying = true;
        _animationController.repeat(reverse: true); // Mulai animasi saat audio diputar
      });
    }
  }

  Widget _buildWaveform(bool isActive) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(8, (index) {
            double heightFactor = isActive
                ? (index.isEven
                    ? _animationController.value * 20.0 + 10.0
                    : _animationController.value * 30.0 + 10.0)
                : 10.0;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              height: heightFactor,
              width: 4.0,
              color: isActive ? Colors.blue : Colors.grey,
            );
          }),
        );
      },
    );
  }

  Widget _buildAudioListTile(String audioUrl) {
    return ListTile(
      title: _buildWaveform(_currentPlayingUrl == audioUrl && _isPlaying),
      trailing: IconButton(
        icon: Icon(
          _currentPlayingUrl == audioUrl && _isPlaying
              ? Icons.pause_circle
              : Icons.play_circle_filled,
          color: _currentPlayingUrl == audioUrl && _isPlaying
              ? Colors.red
              : Colors.blue,
        ),
        onPressed: () => _playAudio(audioUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioSections = _educationRepository.getAudioEducation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi Audio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: audioSections.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ...entry.value.map((audioUrl) {
                  return _buildAudioListTile(audioUrl);
                }).toList(),
                const SizedBox(height: 16), // Adds space between sections
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}