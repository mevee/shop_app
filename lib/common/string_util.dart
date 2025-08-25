String formatSecondsToMinSec(int totalSeconds) {
  final minutes = (totalSeconds ~/ 60).toString().padLeft(1, '0');
  final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}