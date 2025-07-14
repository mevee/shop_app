// Main class for the entire JSON object
class OnboardingData {
  String? id;
  String? type;
  OnboardingDetails? data;

  OnboardingData({this.id, this.type, this.data});

  // Factory constructor to create an instance from JSON
  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      id: json['id'],
      type: json['type'],
      data: json['data'] != null
          ? OnboardingDetails.fromJson(json['data'])
          : null,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data?.toJson(),
    };
  }
}

// Class for the 'data' field
class OnboardingDetails {
  List<OnboardingQuestion>? onboardingQuestions;

  OnboardingDetails({this.onboardingQuestions});

  factory OnboardingDetails.fromJson(Map<String, dynamic> json) {
    return OnboardingDetails(
      onboardingQuestions: json['ONBOARDING_QUESTIONS'] != null
          ? (json['ONBOARDING_QUESTIONS'] as List)
              .map((item) => OnboardingQuestion.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ONBOARDING_QUESTIONS':
          onboardingQuestions?.map((item) => item.toJson()).toList(),
    };
  }
}

// Class for each onboarding question
class OnboardingQuestion {
  int? index;
  String? label;
  String? cta;
  List<Option>? options;

  OnboardingQuestion({
    this.index,
    this.label,
    this.cta,
    this.options,
  });

  factory OnboardingQuestion.fromJson(Map<String, dynamic> json) {
    return OnboardingQuestion(
      index: json['index'],
      label: json['label'],
      cta: json['cta'],
      options: json['options'] != null
          ? (json['options'] as List)
              .map((item) => Option.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'label': label,
      'cta': cta,
      'options': options?.map((item) => item.toJson()).toList(),
    };
  }
}

// Class for each option
class Option {
  int? index;
  String? label;
  String? subLabel;
  List<String>? options;

  Option({
    this.index,
    this.label,
    this.subLabel,
    this.options,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      index: json['index'],
      label: json['label'],
      subLabel: json['subLabel'],
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'label': label,
      'subLabel': subLabel,
      'options': options,
    };
  }
}
