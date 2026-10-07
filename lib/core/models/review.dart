enum OpinionType {
  veryBad,
  bad,
  good,
  excellent,
}

extension OpinionTypeExtension on OpinionType {
  String toApiString() {
    switch (this) {
      case OpinionType.veryBad: return 'very_bad';
      case OpinionType.bad: return 'bad';
      case OpinionType.good: return 'good';
      case OpinionType.excellent: return 'excellent';
    }
  }

  String toEmoji() {
    switch (this) {
      case OpinionType.veryBad: return '😡';
      case OpinionType.bad: return '🙁';
      case OpinionType.good: return '😊';
      case OpinionType.excellent: return '🤩';
    }
  }

  String toLabel() {
    switch (this) {
      case OpinionType.veryBad: return 'Nul';
      case OpinionType.bad: return 'Peu satisfaisant';
      case OpinionType.good: return 'Satisfaisant';
      case OpinionType.excellent: return 'Très satisfaisant';
    }
  }
}

class Review {
  final int clientId;
  final int professionalId;
  final double rate;
  final OpinionType opinion;
  final String? comment;

  Review({
    required this.clientId,
    required this.professionalId,
    required this.rate,
    required this.opinion,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'professional_id': professionalId,
      'rate': rate,
      'opinion': opinion.toApiString(),
      'comment': comment,
    };
  }
}